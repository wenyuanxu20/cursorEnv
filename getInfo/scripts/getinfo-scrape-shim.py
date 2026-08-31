#!/usr/bin/env python3
"""Tiny Firecrawl-compatible scrape API for hosts that cannot run Compose.

Binds 127.0.0.1:3002
  GET  /v0/health/readiness -> {"status":"ok"}
  POST /v2/scrape {"url":"..."} -> {"success":true,"data":{"markdown":"...","metadata":{...}}}

Uses Scrapling HTTP Fetcher when installed; otherwise stdlib urllib + HTML strip.
Do not expose this port to the public internet.
"""
from __future__ import annotations

import html
import json
import re
import sys
import urllib.error
import urllib.request
from html.parser import HTMLParser
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse


HOST = "127.0.0.1"
PORT = 3002
UA = "Mozilla/5.0 (compatible; getinfo-scrape-shim/1.0)"


class _TextExtractor(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self._skip = 0
        self._title: list[str] = []
        self._in_title = False
        self._parts: list[str] = []

    def handle_starttag(self, tag: str, attrs) -> None:
        if tag in {"script", "style", "noscript"}:
            self._skip += 1
        if tag == "title":
            self._in_title = True
        if tag in {"p", "br", "div", "h1", "h2", "h3", "li", "tr"}:
            self._parts.append("\n")

    def handle_endtag(self, tag: str) -> None:
        if tag in {"script", "style", "noscript"} and self._skip:
            self._skip -= 1
        if tag == "title":
            self._in_title = False

    def handle_data(self, data: str) -> None:
        if self._skip:
            return
        text = html.unescape(data)
        if self._in_title:
            self._title.append(text)
            return
        if text.strip():
            self._parts.append(text)

    def result(self) -> tuple[str, str]:
        title = re.sub(r"\s+", " ", "".join(self._title)).strip()
        body = re.sub(r"\n{3,}", "\n\n", "".join(self._parts)).strip()
        return title, body


def _stdlib_fetch(url: str, timeout: int = 25) -> tuple[str, str]:
    req = urllib.request.Request(url, headers={"User-Agent": UA})
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        raw = resp.read()
        ctype = resp.headers.get("Content-Type", "")
    charset = "utf-8"
    if "charset=" in ctype.lower():
        charset = ctype.lower().split("charset=", 1)[1].split(";")[0].strip() or "utf-8"
    html_text = raw.decode(charset, errors="replace")
    parser = _TextExtractor()
    parser.feed(html_text)
    return parser.result()


def _scrapling_fetch(url: str) -> tuple[str, str] | None:
    try:
        from scrapling.fetchers import Fetcher
    except Exception:
        return None
    page = Fetcher.get(url) if hasattr(Fetcher, "get") else Fetcher.fetch(url)
    title = ""
    try:
        nodes = page.css("title")
        if nodes:
            title = str(nodes[0])
    except Exception:
        pass
    text = ""
    if hasattr(page, "get_all_text"):
        try:
            text = page.get_all_text() or ""
        except Exception:
            text = ""
    if not text:
        text = str(page)[:20000]
    return title.strip(), text.strip()


def scrape(url: str) -> dict:
    parsed = urlparse(url)
    if parsed.scheme not in {"http", "https"} or not parsed.netloc:
        raise ValueError(f"invalid url: {url}")
    via = "stdlib"
    pair = _scrapling_fetch(url)
    if pair is None:
        title, body = _stdlib_fetch(url)
    else:
        title, body = pair
        via = "scrapling"
    md = f"# {title}\n\n{body}" if title else body
    return {
        "success": True,
        "data": {
            "markdown": md[:20000],
            "metadata": {"title": title, "sourceURL": url, "shim": via},
        },
    }


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt: str, *args) -> None:
        sys.stderr.write("%s - %s\n" % (self.address_string(), fmt % args))

    def _send(self, code: int, payload: dict) -> None:
        raw = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(raw)))
        self.end_headers()
        self.wfile.write(raw)

    def do_GET(self) -> None:
        path = self.path.split("?", 1)[0]
        if path in {"/v0/health/readiness", "/health", "/"}:
            self._send(200, {"status": "ok", "shim": "getinfo-scrape-shim"})
            return
        self._send(404, {"error": "not found"})

    def do_POST(self) -> None:
        path = self.path.split("?", 1)[0]
        if path not in {"/v2/scrape", "/v1/scrape"}:
            self._send(404, {"error": "not found"})
            return
        length = int(self.headers.get("Content-Length") or 0)
        raw = self.rfile.read(length) if length else b"{}"
        try:
            body = json.loads(raw.decode("utf-8", errors="replace") or "{}")
            url = str(body.get("url") or "").strip()
            self._send(200, scrape(url))
        except Exception as exc:
            self._send(500, {"success": False, "error": str(exc)})


def main() -> int:
    httpd = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"getinfo-scrape-shim http://{HOST}:{PORT}", file=sys.stderr, flush=True)
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        return 0
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
