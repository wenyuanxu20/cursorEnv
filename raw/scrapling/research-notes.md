# Scrapling 本机部署笔记（cursorEnv/getInfo）

日期：2026-08-24

## 上游（文档）

- 仓库：https://github.com/D4Vinci/Scrapling
- 安装：`pip install "scrapling[all]"` 后必须 `scrapling install` 才有浏览器
- 官方 MCP：`pip install "scrapling[ai]"` → `scrapling-mcp` / `scrapling mcp`
  https://scrapling.readthedocs.io/en/latest/ai/mcp-server.html
- 0.4.15：`get` 改名为 `make_request`；Streamable HTTP 默认要 `--auth-token` 或显式 `--no-auth`；默认绑 `127.0.0.1`

## 本机已验证

- 钉选 `scrapling[all]==0.4.15`，uv + CPython 3.12.10
- PyPI：`HTTPS_PROXY=http://127.0.0.1:7897` 成功；`socks5://127.0.0.1:7897` → uv `tls handshake eof`
- 清华 simple 当时最新到 `0.4.14`，没有 `0.4.15`
- `scrapling install` 完成后 `Fetcher.get(https://example.com)` → `status=200`
- MCP 可执行文件：`getInfo/scrapling/.venv/Scripts/scrapling-mcp.exe`

## 本仓决策

- 部署根：`cursorEnv/getInfo/scrapling/`（uv 项目入库，`.venv` gitignore）
- 不 clone 上游源码（与 Firecrawl/TrendRadar 检出不同）
- Cursor 默认 STDIO MCP；HTTP `:3344 --no-auth` 仅 `-Http`
- 路由：普通 URL 仍走 Firecrawl；Scrapling 用于反爬 / Firecrawl 失败
