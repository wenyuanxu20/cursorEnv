# Scrapling · 本机自适应抓取与 Cursor 调用指南

> 上游：[D4Vinci/Scrapling](https://github.com/D4Vinci/Scrapling) · 文档：[MCP Server](https://scrapling.readthedocs.io/en/latest/ai/mcp-server.html)  
> 运行时：`getInfo/scrapling/`（uv 钉 `scrapling[all]==0.4.15`，Python 3.12）  
> 启动：`getInfo/scripts/start-scrapling.ps1`  
> MCP：STDIO `getInfo/scrapling/.venv/Scripts/scrapling-mcp.exe`（键名 `scrapling`）  
> 本主题为 cursorEnv **必选**安装项；与 Firecrawl / TrendRadar 一起由全局规则 `firecrawl-web-fetch.mdc` 调用。

## 是什么

**Scrapling** 是自适应网页抓取框架：HTTP Fetcher、Playwright `DynamicFetcher`、反爬 `StealthyFetcher`，以及官方 **MCP**（`make_request` / `fetch` / `stealthy_fetch` 等）。cursorEnv 把它放在 `getInfo/`，作为 **Firecrawl 抓不到、或目标站有 Cloudflare / 强 JS** 时的本机通道，不替代 Firecrawl 做普通文档站。

| 意图 | 工具 |
|------|------|
| 热榜 / 舆情 / 今日新闻 | TrendRadar |
| 普通 URL / 文档站正文 | Firecrawl（`:3002`） |
| 反爬 / Cloudflare / Firecrawl 失败 | Scrapling |
| 热点条目要全文 | TrendRadar 给链接 → Firecrawl，失败再 Scrapling |

## 本机约定

| 项 | 值 |
|----|-----|
| 运行时目录 | `cursorEnv/getInfo/scrapling/`（`pyproject.toml` / `uv.lock` 入库；`.venv/` 不入库） |
| 钉选 | `scrapling[all]==0.4.15` + CPython 3.12 |
| 浏览器 | `scrapling install`（Playwright Chromium 等，写入本机缓存） |
| STDIO MCP | `getInfo/scrapling/.venv/Scripts/scrapling-mcp.exe` |
| HTTP MCP（可选） | `http://127.0.0.1:3344/mcp`（`start-scrapling.ps1 -Http`，`--no-auth`，仅 localhost） |
| 用户 MCP | `%USERPROFILE%\.cursor\mcp.json` → 键名 `scrapling` |
| 运行时 id | `user-scrapling` |
| 自动规则 | 全局 `firecrawl-web-fetch.mdc`（`alwaysApply`） |
| 启动 | `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\start-scrapling.ps1` |

PyPI 走本机 **HTTP** 代理 `http://127.0.0.1:7897`。`socks5://127.0.0.1:7897` 会让 uv 对 `pypi.org` 出现 `tls handshake eof`。清华镜像在 2026-08-24 时尚无 `0.4.15`，不要用 tuna 钉这一版。

## 快速开始

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-scrapling.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\scrapling-scrape.ps1 -Url https://example.com
```

可选 HTTP MCP：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-scrapling.ps1 -Http
```

停止 HTTP MCP（STDIO 由 Cursor 按需拉起，不必常驻）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\stop-scrapling.ps1
```

## Cursor MCP（本机）

```json
"scrapling": {
  "command": "C:\\Users\\xwy12\\Desktop\\my-project\\cursorEnv\\getInfo\\scrapling\\.venv\\Scripts\\scrapling-mcp.exe"
}
```

- 改 `mcp.json` 后重启 Cursor 或重载 MCP。
- 常用工具：`make_request`（HTTP）、`fetch`（Chromium）、`stealthy_fetch`（反爬）；会话：`open_session` / `session_fetch` / `close_session`。
- 0.4.15 起 HTTP 传输默认要 token；本机可选 `--http --no-auth`，不要把 `:3344` 暴露到公网。

## 新机器检查清单（必选）

1. 安装 uv（`%USERPROFILE%\.local\bin\uv.exe`）与 CPython 3.12。
2. 本机 HTTP 代理 `http://127.0.0.1:7897` 可访问 `pypi.org`（不要用 socks5 喂给 uv）。
3. 运行 `getInfo/scripts/start-scrapling.ps1`。
4. 把上面的 `scrapling` 块写入 `%USERPROFILE%\.cursor\mcp.json`（与 `firecrawl` / `trendradar` 并列）。
5. 复制规则到 `%USERPROFILE%\.cursor\rules\firecrawl-web-fetch.mdc`。
6. 对 `https://example.com` 跑一次 `scrapling-scrape.ps1`。

## 资源与限制

- 普通页面优先 Firecrawl；Scrapling 浏览器路径更重。
- `.venv/` 与 `getInfo/logs/` 不入库。
- 默认未配代理出网；目标站若需代理，在 MCP 工具参数或 `SCRAPLING_EXECUTABLE_PATH` 里配，不要把密钥写进 Git。

详页：`wiki/scrapling/`。
