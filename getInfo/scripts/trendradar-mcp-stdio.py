"""Cursor STDIO entry for TrendRadar.

Upstream `mcp_server.server.run_server` prints a startup banner to stdout.
Cursor uses stdout as the JSON-RPC channel, so that banner breaks tool
discovery. HTTP `url` in mcp.json also fails here: Cursor treats localhost
Streamable-HTTP as OAuth and only exposes `mcp_auth`.
"""
from __future__ import annotations

import builtins
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "TrendRadar"
if not ROOT.is_dir():
    raise SystemExit(f"TrendRadar checkout missing: {ROOT}")

sys.path.insert(0, str(ROOT))

_real_print = builtins.print


def _print_to_stderr(*args, **kwargs):
    kwargs.setdefault("file", sys.stderr)
    _real_print(*args, **kwargs)


builtins.print = _print_to_stderr

from mcp_server.server import run_server  # noqa: E402

if __name__ == "__main__":
    run_server(project_root=str(ROOT), transport="stdio")
