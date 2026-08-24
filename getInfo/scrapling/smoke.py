"""One-shot fetch for getInfo smoke tests. Usage: python smoke.py URL [http|dynamic|stealthy]"""
from __future__ import annotations

import sys


def fetch(url: str, mode: str):
    from scrapling.fetchers import DynamicFetcher, Fetcher, StealthyFetcher

    if mode == "http":
        if hasattr(Fetcher, "get"):
            return Fetcher.get(url)
        return Fetcher.fetch(url)
    if mode == "dynamic":
        return DynamicFetcher.fetch(url, headless=True)
    if mode == "stealthy":
        return StealthyFetcher.fetch(url, headless=True)
    raise SystemExit(f"unknown mode: {mode}")


def preview(page) -> str:
    if hasattr(page, "get_all_text"):
        try:
            text = page.get_all_text() or ""
            if text.strip():
                return text
        except Exception:
            pass
    try:
        nodes = page.css("h1, title")
        return " ".join(str(n) for n in nodes[:4])
    except Exception:
        return str(page)[:400]


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: smoke.py URL [http|dynamic|stealthy]", file=sys.stderr)
        return 2
    url = sys.argv[1]
    mode = sys.argv[2] if len(sys.argv) > 2 else "http"
    page = fetch(url, mode)
    status = getattr(page, "status", getattr(page, "status_code", "?"))
    print(f"status={status}")
    print(f"url={getattr(page, 'url', url)}")
    print((preview(page) or "")[:800])
    s = str(status)
    return 0 if s[:1] in "23" else 1


if __name__ == "__main__":
    raise SystemExit(main())
