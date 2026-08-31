#!/usr/bin/env python3
"""Local agents-radar digest API (published reports, not the Actions LLM pipeline).

Binds 127.0.0.1:3355 — do not expose this port.

  GET /health
  GET /manifest
  GET /latest?type=ai-cli&lang=zh
  GET /report?date=YYYY-MM-DD&type=ai-cli
  GET /card?types=ai-cli,ai-agents&max_chars=3500
  GET /search?q=...&limit=8
  GET /fingerprint
"""
from __future__ import annotations

import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlparse

HOST = os.environ.get("AGENTS_RADAR_HOST", "127.0.0.1")
PORT = int(os.environ.get("AGENTS_RADAR_PORT", "3355"))
UA = "getinfo-agents-radar/1.0"
PAGES = "https://duanyytop.github.io/agents-radar"
JSDELIVR = "https://cdn.jsdelivr.net/gh/duanyytop/agents-radar@master"
RAW = "https://raw.githubusercontent.com/duanyytop/agents-radar/master"
WEB_UI = PAGES + "/"

ROOT = Path(__file__).resolve().parents[1] / "agents-radar"
CACHE = ROOT / "cache"
LOCAL_DIGEST_DIRS = [
    ROOT / "upstream" / "digests",
    ROOT / "digests",
]

TYPE_LABELS = {
    "ai-cli": "CLI 工具",
    "ai-agents": "Agent 生态",
    "ai-infra": "AI 基建",
    "ai-web": "官方站点",
    "ai-trending": "GitHub 热门",
    "ai-hn": "Hacker News",
    "ai-ph": "Product Hunt",
    "ai-arxiv": "ArXiv",
    "ai-hf": "Hugging Face",
    "ai-community": "社区",
}
DEFAULT_CARD_TYPES = [
    "ai-cli",
    "ai-agents",
    "ai-infra",
    "ai-trending",
    "ai-hn",
    "ai-community",
]
_MEM: dict[str, tuple[float, object]] = {}


def _now() -> float:
    return time.time()


def _cache_get(key: str, ttl: float):
    hit = _MEM.get(key)
    if not hit:
        return None
    ts, val = hit
    if _now() - ts > ttl:
        return None
    return val


def _cache_set(key: str, val: object) -> None:
    _MEM[key] = (_now(), val)


def _http_get(url: str, timeout: int = 12) -> str:
    req = urllib.request.Request(url, headers={"User-Agent": UA, "Accept": "*/*"})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        raw = resp.read()
        ctype = resp.headers.get("Content-Type", "")
    charset = "utf-8"
    if "charset=" in ctype.lower():
        charset = ctype.lower().split("charset=", 1)[1].split(";")[0].strip() or "utf-8"
    return raw.decode(charset, errors="replace")


def _try_urls(urls: list[str]) -> tuple[str, str]:
    errors: list[str] = []
    for url in urls:
        try:
            text = _http_get(url)
            if text and len(text.strip()) > 8 and "404" not in text[:40].lower():
                return text, url
            errors.append(url + " empty")
        except Exception as exc:
            errors.append(f"{url}: {exc}")
    raise RuntimeError("all sources failed: " + " | ".join(errors[:4]))


def _disk_report(date: str, report_type: str) -> str | None:
    name = f"{report_type}.md"
    for base in LOCAL_DIGEST_DIRS:
        path = base / date / name
        if path.is_file() and path.stat().st_size > 20:
            return path.read_text(encoding="utf-8", errors="replace")
    cached = CACHE / date / name
    if cached.is_file() and cached.stat().st_size > 20:
        age = _now() - cached.stat().st_mtime
        if age < 6 * 3600:
            return cached.read_text(encoding="utf-8", errors="replace")
    return None


def _save_cache(date: str, report_type: str, text: str) -> None:
    dest = CACHE / date
    dest.mkdir(parents=True, exist_ok=True)
    (dest / f"{report_type}.md").write_text(text, encoding="utf-8")


def fetch_manifest() -> dict:
    cached = _cache_get("manifest", 180)
    if isinstance(cached, dict):
        return cached
    disk = CACHE / "manifest.json"
    if disk.is_file() and (_now() - disk.stat().st_mtime) < 180:
        data = json.loads(disk.read_text(encoding="utf-8"))
        _cache_set("manifest", data)
        return data
    text, src = _try_urls(
        [
            f"{PAGES}/manifest.json",
            f"{JSDELIVR}/manifest.json",
            f"{RAW}/manifest.json",
        ]
    )
    if text.strip().startswith("```"):
        text = re.sub(r"^```(?:json)?\s*", "", text.strip())
        text = re.sub(r"\s*```$", "", text)
    data = json.loads(text)
    data["_source"] = src
    CACHE.mkdir(parents=True, exist_ok=True)
    disk.write_text(json.dumps(data, ensure_ascii=False), encoding="utf-8")
    _cache_set("manifest", data)
    return data


def latest_day(manifest: dict | None = None) -> dict:
    data = manifest or fetch_manifest()
    days = data.get("dates") or []
    if not days:
        raise RuntimeError("manifest has no dates")
    return days[0]


def resolve_type(name: str, lang: str = "zh") -> str:
    raw = (name or "ai-cli").strip().lower()
    aliases = {
        "cli": "ai-cli",
        "agents": "ai-agents",
        "agent": "ai-agents",
        "infra": "ai-infra",
        "web": "ai-web",
        "trending": "ai-trending",
        "hn": "ai-hn",
        "ph": "ai-ph",
        "arxiv": "ai-arxiv",
        "hf": "ai-hf",
        "community": "ai-community",
    }
    raw = aliases.get(raw, raw)
    if lang == "en" and not raw.endswith("-en"):
        return raw + "-en"
    if lang != "en" and raw.endswith("-en"):
        return raw[:-3]
    return raw


def fetch_report(date: str, report_type: str) -> tuple[str, str]:
    key = f"report:{date}:{report_type}"
    cached = _cache_get(key, 3600)
    if isinstance(cached, tuple):
        return cached
    local = _disk_report(date, report_type)
    if local:
        _cache_set(key, (local, "local"))
        return local, "local"
    rel = f"digests/{date}/{report_type}.md"
    text, src = _try_urls(
        [
            f"{JSDELIVR}/{rel}",
            f"{PAGES}/{rel}",
            f"{RAW}/{rel}",
        ]
    )
    _save_cache(date, report_type, text)
    _cache_set(key, (text, src))
    return text, src


def excerpt(markdown: str, limit: int = 520) -> str:
    text = re.sub(r"<details>.*?</details>", "", markdown, flags=re.S | re.I)
    text = re.sub(r"<[^>]+>", "", text)
    text = re.sub(r"```.*?```", "", text, flags=re.S)
    lines = []
    for line in text.splitlines():
        s = line.strip()
        if not s or s.startswith("|---") or s.startswith("![") or s.startswith("<"):
            continue
        if s.startswith("|") and s.count("|") >= 3:
            continue
        lines.append(s)
    blob = "\n".join(lines).strip()
    blob = re.sub(r"\n{3,}", "\n\n", blob)
    if len(blob) > limit:
        blob = blob[: limit - 1].rstrip() + "…"
    return blob


def fingerprint(day: dict | None = None) -> dict:
    d = day or latest_day()
    date = str(d.get("date") or "")
    reports = [str(x) for x in (d.get("reports") or [])]
    zh = [r for r in reports if not r.endswith("-en")]
    sig = date + "|" + ",".join(sorted(zh))
    return {"date": date, "reports": reports, "zh": zh, "fingerprint": sig}


def build_card(types: list[str] | None = None, max_chars: int = 3500, lang: str = "zh") -> dict:
    day = latest_day()
    date = str(day.get("date") or "")
    available = set(day.get("reports") or [])
    wanted = types or list(DEFAULT_CARD_TYPES)
    resolved = []
    for item in wanted:
        name = resolve_type(item, lang)
        if name in available:
            resolved.append(name)
    if not resolved:
        resolved = [resolve_type(r, lang) for r in DEFAULT_CARD_TYPES if resolve_type(r, lang) in available]
    chunks = [
        f"📡 agents-radar {date}",
        "报告：" + " · ".join(TYPE_LABELS.get(t.replace("-en", ""), t) for t in resolved),
        "",
    ]
    sources = []
    fetched: dict[str, tuple[str, str] | Exception] = {}

    def _one(name: str):
        try:
            return name, fetch_report(date, name)
        except Exception as exc:
            return name, exc

    with ThreadPoolExecutor(max_workers=6) as pool:
        for fut in as_completed([pool.submit(_one, name) for name in resolved]):
            name, item = fut.result()
            fetched[name] = item

    for name in resolved:
        item = fetched.get(name)
        if isinstance(item, tuple):
            body, src = item
            sources.append(src)
            label = TYPE_LABELS.get(name.replace("-en", ""), name)
            chunks.append(f"【{label}】")
            chunks.append(excerpt(body, 420))
            chunks.append("")
        else:
            chunks.append(f"【{name}】拉取失败：{item}")
            chunks.append("")
    chunks.append(f"全文 {WEB_UI}")
    text = "\n".join(chunks).strip()
    if len(text) > max_chars:
        text = text[: max_chars - 1].rstrip() + "…"
    fp = fingerprint(day)
    return {
        "date": date,
        "types": resolved,
        "text": text,
        "fingerprint": fp["fingerprint"],
        "web": WEB_UI,
        "sources": sources,
    }


def search_reports(query: str, limit: int = 8) -> dict:
    q = (query or "").strip()
    if not q:
        raise ValueError("q required")
    day = latest_day()
    date = str(day.get("date") or "")
    hits = []
    for name in day.get("reports") or []:
        if str(name).endswith("-en"):
            continue
        try:
            body, src = fetch_report(date, str(name))
        except Exception:
            continue
        if q.lower() not in body.lower() and q not in body:
            continue
        idx = body.lower().find(q.lower())
        start = max(0, idx - 80)
        snippet = body[start : start + 240].replace("\n", " ")
        hits.append(
            {
                "type": name,
                "label": TYPE_LABELS.get(str(name), name),
                "snippet": snippet,
                "source": src,
            }
        )
        if len(hits) >= limit:
            break
    return {"date": date, "query": q, "hits": hits}


def _json_bytes(obj: object, code: int = 200) -> tuple[int, bytes, str]:
    payload = json.dumps(obj, ensure_ascii=False, indent=2).encode("utf-8")
    return code, payload, "application/json; charset=utf-8"


def _text_bytes(text: str, code: int = 200) -> tuple[int, bytes, str]:
    return code, text.encode("utf-8"), "text/plain; charset=utf-8"


def handle(path: str, qs: dict[str, list[str]]) -> tuple[int, bytes, str]:
    def one(key: str, default: str = "") -> str:
        vals = qs.get(key) or []
        return vals[0] if vals else default

    if path in {"/", "/health"}:
        try:
            fp = fingerprint()
            return _json_bytes(
                {
                    "ok": True,
                    "service": "agents-radar",
                    "latest": fp["date"],
                    "fingerprint": fp["fingerprint"],
                    "port": PORT,
                }
            )
        except Exception as exc:
            return _json_bytes({"ok": False, "error": str(exc)}, 503)

    if path == "/manifest":
        return _json_bytes(fetch_manifest())

    if path == "/fingerprint":
        return _json_bytes(fingerprint())

    if path == "/latest":
        lang = one("lang", "zh")
        report_type = resolve_type(one("type", "ai-cli"), lang)
        day = latest_day()
        date = str(day.get("date") or "")
        body, src = fetch_report(date, report_type)
        if one("format") == "json":
            return _json_bytes(
                {"date": date, "type": report_type, "source": src, "markdown": body}
            )
        header = f"# {date} {report_type}\nsource: {src}\n\n"
        return _text_bytes(header + body)

    if path == "/report":
        date = one("date")
        if not date:
            date = str(latest_day().get("date") or "")
        report_type = resolve_type(one("type", "ai-cli"), one("lang", "zh"))
        body, src = fetch_report(date, report_type)
        if one("format") == "json":
            return _json_bytes(
                {"date": date, "type": report_type, "source": src, "markdown": body}
            )
        return _text_bytes(body)

    if path == "/card":
        types = [t.strip() for t in one("types").split(",") if t.strip()]
        max_chars = int(one("max_chars", "3500") or 3500)
        card = build_card(types or None, max_chars=max_chars, lang=one("lang", "zh"))
        if one("format") == "text":
            return _text_bytes(card["text"])
        return _json_bytes(card)

    if path == "/search":
        return _json_bytes(search_reports(one("q"), int(one("limit", "8") or 8)))

    return _json_bytes({"error": "not found", "path": path}, 404)


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt: str, *args) -> None:
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))

    def do_GET(self) -> None:  # noqa: N802
        parsed = urlparse(self.path)
        qs = parse_qs(parsed.query)
        try:
            code, body, ctype = handle(parsed.path, qs)
        except Exception as exc:
            code, body, ctype = _json_bytes({"ok": False, "error": str(exc)}, 500)
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.end_headers()
        self.wfile.write(body)


def main() -> int:
    CACHE.mkdir(parents=True, exist_ok=True)
    httpd = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"agents-radar listening http://{HOST}:{PORT}", flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        httpd.server_close()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
