"""Sync Notion pages shared with xwy-notion into local agentmemory.

Usage:
  python sync.py              # incremental (default)
  python sync.py --full       # ignore checkpoints, re-ingest all readable pages

Env:
  NOTION_TOKEN          required (user-level)
  AGENTMEMORY_URL       default http://127.0.0.1:3111
  NOTION_SYNC_ROOT      optional extra root page id (default: AiRec)
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

NOTION_VERSION = "2022-06-28"
DEFAULT_ROOT = "3a954d8e-86f6-81ac-808c-fa1bb6a8422e"
MAX_CHARS = 12000
SLEEP_S = 0.35
STATE_PATH = Path.home() / ".agentmemory" / "notion-sync-state.json"
SECRET_RE = re.compile(r"(secret_|ntn_|sk-|ghp_|github_pat_)[A-Za-z0-9_\-]{8,}", re.I)


def env_token() -> str:
    tok = (os.environ.get("NOTION_TOKEN") or "").strip()
    if not tok:
        raise SystemExit("NOTION_TOKEN is not set")
    return tok


def clear_proxy() -> None:
    """Notion API is reachable direct from this PC; SOCKS proxy breaks TLS."""
    for k in (
        "HTTP_PROXY",
        "HTTPS_PROXY",
        "ALL_PROXY",
        "http_proxy",
        "https_proxy",
        "all_proxy",
    ):
        os.environ.pop(k, None)


def notion(method: str, path: str, token: str, body: dict | None = None) -> dict:
    url = "https://api.notion.com/v1" + path
    data = None if body is None else json.dumps(body).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        method=method,
        headers={
            "Authorization": f"Bearer {token}",
            "Notion-Version": NOTION_VERSION,
            "Content-Type": "application/json",
            "User-Agent": "Mozilla/5.0 cursorEnv-notion-sync",
        },
    )
    last: Exception | None = None
    for attempt in range(4):
        try:
            with urllib.request.urlopen(req, timeout=45) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except urllib.error.HTTPError as e:
            err = e.read().decode("utf-8", "replace")[:400]
            raise RuntimeError(f"Notion {e.code} {path}: {err}") from e
        except Exception as e:  # noqa: BLE001
            last = e
            time.sleep(1.2 * (attempt + 1))
    raise RuntimeError(f"Notion {path}: {last}") from last


def remember(base: str, content: str, concepts: list[str], files: str) -> dict:
    payload = {
        "content": SECRET_RE.sub("[redacted]", content)[:MAX_CHARS],
        "concepts": concepts,
        "type": "fact",
        "project": "notion",
        "files": files,
    }
    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        base.rstrip("/") + "/agentmemory/remember",
        data=data,
        method="POST",
        headers={"Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        return json.loads(resp.read().decode("utf-8"))


def livez(base: str) -> None:
    req = urllib.request.Request(base.rstrip("/") + "/agentmemory/livez")
    with urllib.request.urlopen(req, timeout=5) as resp:
        body = json.loads(resp.read().decode("utf-8"))
    if body.get("status") != "ok":
        raise SystemExit(f"agentmemory not ok: {body}")


def rich_text(items: list | None) -> str:
    if not items:
        return ""
    return "".join((it.get("plain_text") or "") for it in items)


def page_title(page: dict) -> str:
    props = page.get("properties") or {}
    for v in props.values():
        if isinstance(v, dict) and v.get("type") == "title":
            t = rich_text(v.get("title"))
            if t:
                return t
    return page.get("id", "untitled")


def collect_search(token: str) -> dict[str, dict]:
    pages: dict[str, dict] = {}
    cursor = None
    while True:
        body: dict = {
            "query": "",
            "page_size": 100,
            "sort": {"direction": "descending", "timestamp": "last_edited_time"},
        }
        if cursor:
            body["start_cursor"] = cursor
        data = notion("POST", "/search", token, body)
        for obj in data.get("results") or []:
            if obj.get("object") == "page" and not obj.get("in_trash") and not obj.get("archived"):
                pages[obj["id"]] = obj
        if not data.get("has_more"):
            break
        cursor = data.get("next_cursor")
        time.sleep(SLEEP_S)
    return pages


def list_children(token: str, block_id: str) -> list[dict]:
    out: list[dict] = []
    cursor = None
    while True:
        path = f"/blocks/{block_id}/children?page_size=100"
        if cursor:
            path += f"&start_cursor={cursor}"
        data = notion("GET", path, token)
        out.extend(data.get("results") or [])
        if not data.get("has_more"):
            break
        cursor = data.get("next_cursor")
        time.sleep(SLEEP_S)
    return out


def retrieve_page(token: str, page_id: str) -> dict:
    return notion("GET", f"/pages/{page_id}", token)


def flatten_blocks(token: str, block_id: str, depth: int = 0) -> tuple[str, list[str]]:
    if depth > 8:
        return "", []
    lines: list[str] = []
    child_pages: list[str] = []
    for b in list_children(token, block_id):
        btype = b.get("type") or ""
        payload = b.get(btype) or {}
        if btype == "child_page":
            child_pages.append(b["id"])
            title = (payload.get("title") if isinstance(payload, dict) else "") or ""
            lines.append(f"[child page] {title}".strip())
            continue
        if btype == "child_database":
            title = (payload.get("title") if isinstance(payload, dict) else "") or "database"
            lines.append(f"[database] {title}")
            continue
        text = ""
        if isinstance(payload, dict):
            text = rich_text(payload.get("rich_text") or payload.get("text") or payload.get("caption"))
            if btype == "code" and payload.get("rich_text"):
                text = "```\n" + rich_text(payload.get("rich_text")) + "\n```"
            if btype.startswith("heading") and text:
                text = "# " + text
            if btype in {"bulleted_list_item", "numbered_list_item"} and text:
                text = "- " + text
            if btype == "to_do":
                mark = "x" if payload.get("checked") else " "
                text = f"- [{mark}] {text}"
        if text:
            lines.append(text)
        if b.get("has_children") and btype not in {"child_page", "child_database"}:
            nested, nested_pages = flatten_blocks(token, b["id"], depth + 1)
            if nested:
                lines.append(nested)
            child_pages.extend(nested_pages)
    return "\n".join(lines), child_pages


def walk_extra_roots(token: str, root_ids: list[str], pages: dict[str, dict]) -> None:
    queue = list(root_ids)
    seen = set(pages)
    while queue:
        pid = queue.pop()
        if pid in seen and pid not in root_ids:
            continue
        seen.add(pid)
        try:
            if pid not in pages:
                pages[pid] = retrieve_page(token, pid)
                time.sleep(SLEEP_S)
            _, kids = flatten_blocks(token, pid)
        except RuntimeError as e:
            print(f"skip walk {pid}: {e}", file=sys.stderr)
            continue
        for kid in kids:
            if kid not in seen:
                queue.append(kid)


def load_state() -> dict:
    if STATE_PATH.is_file():
        return json.loads(STATE_PATH.read_text(encoding="utf-8"))
    return {"pages": {}}


def save_state(state: dict) -> None:
    STATE_PATH.parent.mkdir(parents=True, exist_ok=True)
    STATE_PATH.write_text(json.dumps(state, ensure_ascii=False, indent=2), encoding="utf-8")


def ingest(full: bool) -> int:
    clear_proxy()
    token = env_token()
    base = os.environ.get("AGENTMEMORY_URL", "http://127.0.0.1:3111")
    livez(base)
    extra = [DEFAULT_ROOT]
    if os.environ.get("NOTION_SYNC_ROOT"):
        extra.append(os.environ["NOTION_SYNC_ROOT"].strip())

    print("searching Notion pages…")
    pages = collect_search(token)
    print(f"search hit {len(pages)}")
    walk_extra_roots(token, extra, pages)
    print(f"after tree walk {len(pages)}")

    state = load_state()
    stored = state.setdefault("pages", {})
    synced = skipped = failed = 0

    for pid, page in sorted(pages.items(), key=lambda kv: kv[1].get("last_edited_time") or ""):
        edited = page.get("last_edited_time") or ""
        title = page_title(page)
        prev = stored.get(pid) or {}
        if not full and prev.get("last_edited") == edited:
            skipped += 1
            continue
        try:
            body, _ = flatten_blocks(token, pid)
            time.sleep(SLEEP_S)
        except RuntimeError as e:
            print(f"FAIL read {title}: {e}")
            failed += 1
            continue
        url = page.get("url") or ""
        content = f"Notion page: {title}\nURL: {url}\nLast edited: {edited}\n\n{body}".strip()
        concepts = ["notion", "airec"]
        slug = re.sub(r"[^a-z0-9]+", "-", title.lower()).strip("-")[:40]
        if slug:
            concepts.append(slug)
        try:
            result = remember(base, content, concepts, url)
            mid = ((result.get("memory") or {}).get("id")) if isinstance(result, dict) else None
            stored[pid] = {"last_edited": edited, "title": title, "memory_id": mid, "url": url}
            synced += 1
            print(f"OK {title} ({len(content)} chars)")
        except Exception as e:  # noqa: BLE001
            print(f"FAIL save {title}: {e}")
            failed += 1
        time.sleep(SLEEP_S)

    state["last_run"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    state["last_mode"] = "full" if full else "incremental"
    save_state(state)
    print(f"done synced={synced} skipped={skipped} failed={failed} total={len(pages)}")
    print(f"checkpoint {STATE_PATH}")
    return 0 if failed == 0 else 1


def main() -> int:
    p = argparse.ArgumentParser()
    p.add_argument("--full", action="store_true")
    args = p.parse_args()
    return ingest(full=args.full)


if __name__ == "__main__":
    raise SystemExit(main())
