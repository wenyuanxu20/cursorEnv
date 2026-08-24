# Firecrawl · 01 用法

## 定义

Agent 从互联网取页面内容时的调用顺序与接口。

## 关键结论

| 意图 | 优先动作 |
|------|----------|
| 读一个 URL | MCP `firecrawl_scrape`，或 `POST http://127.0.0.1:3002/v2/scrape` |
| 爬一个站点 | `firecrawl_crawl` + `firecrawl_check_crawl_status` |
| 列出站内链接 | `firecrawl_map` |
| 开放「网上搜」 | 热榜先 TrendRadar；URL/站点用 Firecrawl scrape。自托管没有 search 时：WebSearch 只拿 URL → Firecrawl scrape |
| MCP 未加载 | `pwsh getInfo/scripts/firecrawl-scrape.ps1 -Url <url>` |

HTTP 抓取体例：

```json
{
  "url": "https://example.com",
  "formats": ["markdown"],
  "timeout": 60000
}
```

成功响应含 `success: true` 与 `data.markdown`。

探活：

```powershell
curl.exe -fsS http://127.0.0.1:3002/v0/health/readiness
```

期望 `{"status":"ok"}`。该心跳**不**证明 Playwright/出网正常；功能冒烟必须 scrape 一次。

回退：仅当本机 API 起不来或目标页抓取失败，才用 `WebFetch`/`WebSearch` 作为主通道，并说明原因。

## 证据与来源

- 规则：`.cursor/rules/firecrawl-web-fetch.mdc`
- 脚本：`getInfo/scripts/firecrawl-scrape.ps1`
- 上游：https://docs.firecrawl.dev/contributing/self-host （`POST /v2/scrape`）

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
