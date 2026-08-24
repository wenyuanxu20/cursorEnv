# Scrapling · 01 用法

## 定义

Agent 在 Firecrawl 不够用时，用 Scrapling 抓单个或少量 URL。

## 关键结论

| 意图 | 优先动作 |
|------|----------|
| 静态 / 普通 HTML | MCP `make_request`（HTTP + TLS 指纹） |
| JS / SPA | `fetch`（Chromium） |
| Cloudflare / 反爬 | `stealthy_fetch` |
| 同一站点多页 | `open_session` → `session_fetch` → `close_session` |
| 多 URL | `bulk_get` / `bulk_fetch` / `bulk_stealthy_fetch` |
| MCP 未加载 | `getInfo/scripts/scrapling-scrape.ps1 -Url <url>`；动态页加 `-Mode dynamic` 或 `-Mode stealthy` |

探活（安装后）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\scrapling-scrape.ps1 -Url https://example.com
```

期望输出含 `status=200`。该命令走 HTTP Fetcher，**不**证明隐身浏览器可用；反爬页需 `-Mode stealthy` 或 MCP `stealthy_fetch`。

0.4.15 起工具名是 `make_request`，不是旧文档里的 `get`。

回退：仅当 Firecrawl **与** Scrapling 都抓不到该 URL，才用 `WebFetch`/`WebSearch` 当主通道，并说明原因。

## 证据与来源

- 规则：`.cursor/rules/firecrawl-web-fetch.mdc`
- 脚本：`getInfo/scripts/scrapling-scrape.ps1`、`getInfo/scrapling/smoke.py`
- 上游：https://scrapling.readthedocs.io/en/latest/ai/mcp-server.html

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
