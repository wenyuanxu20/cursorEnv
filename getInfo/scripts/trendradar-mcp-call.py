"""Call TrendRadar Streamable-HTTP MCP without Cursor (localhost :3333)."""
from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request
from pathlib import Path

MCP_URL = "http://127.0.0.1:3333/mcp"


def _parse_sse(raw: str) -> dict | None:
    for line in raw.splitlines():
        if line.startswith("data:"):
            payload = line[5:].strip()
            if payload:
                return json.loads(payload)
    raw = raw.strip()
    if raw.startswith("{"):
        return json.loads(raw)
    return None


def mcp_request(body: dict, session: str | None = None, timeout: int = 120) -> tuple[dict | None, str | None]:
    data = json.dumps(body).encode("utf-8")
    headers = {
        "Accept": "application/json, text/event-stream",
        "Content-Type": "application/json",
        "MCP-Protocol-Version": "2025-03-26",
    }
    if session:
        headers["Mcp-Session-Id"] = session
    req = urllib.request.Request(MCP_URL, data=data, headers=headers, method="POST")
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        sid = resp.headers.get("Mcp-Session-Id")
        raw = resp.read().decode("utf-8", errors="replace")
    parsed = _parse_sse(raw) if raw else None
    return parsed, sid


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("tool")
    parser.add_argument("--args", default="{}")
    parser.add_argument("--args-file")
    parser.add_argument("--timeout", type=int, default=180)
    ns = parser.parse_args()
    raw_args = Path(ns.args_file).read_text(encoding="utf-8") if ns.args_file else ns.args
    try:
        arguments = json.loads(raw_args)
    except json.JSONDecodeError as exc:
        print(f"invalid --args JSON: {exc}", file=sys.stderr)
        return 2

    init, session = mcp_request(
        {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {
                "protocolVersion": "2025-03-26",
                "capabilities": {},
                "clientInfo": {"name": "cursorEnv-trendradar-call", "version": "1"},
            },
        },
        timeout=30,
    )
    if not init or "result" not in init:
        print(json.dumps({"error": "initialize failed", "raw": init}, ensure_ascii=False))
        return 1

    notify = {
        "jsonrpc": "2.0",
        "method": "notifications/initialized",
    }
    try:
        mcp_request(notify, session=session, timeout=15)
    except (urllib.error.HTTPError, urllib.error.URLError):
        pass

    result, _ = mcp_request(
        {
            "jsonrpc": "2.0",
            "id": 2,
            "method": "tools/call",
            "params": {"name": ns.tool, "arguments": arguments},
        },
        session=session,
        timeout=ns.timeout,
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if result and "error" not in result else 1


if __name__ == "__main__":
    raise SystemExit(main())
