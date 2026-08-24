# Firecrawl · 03 自动调用规则

## 定义

全局 Cursor 规则 `firecrawl-web-fetch.mdc`：任意工作区要从**网络**取信息时，页面走本机 Firecrawl、热榜走 TrendRadar、反爬或 Firecrawl 失败走 Scrapling，**不需要**用户点名工具。

## 关键结论

| 项 | 值 |
|----|-----|
| 生效范围 | **所有 Cursor 项目**（`alwaysApply: true`） |
| 全局规则 | `%USERPROFILE%\.cursor\rules\firecrawl-web-fetch.mdc` |
| 中枢副本 | `cursorEnv/.cursor/rules/firecrawl-web-fetch.mdc` |
| MCP | 键名 `firecrawl`，运行时 id `user-firecrawl` |
| API | `http://127.0.0.1:3002` |
| 主路径 | scrape / crawl / map；search 不可用则 WebSearch 发现 URL 后再 scrape |
| 服务未起 | 跑 `getInfo/scripts/start-firecrawl.ps1`，不要空等 |
| 回退 | 该 URL 上 Firecrawl 与 Scrapling 都失败时才用 WebFetch/WebSearch 当主抓取器，并写明原因 |
| 点名工具 | 回复里写明实际用了 Firecrawl / TrendRadar / Scrapling（及 MCP 工具名）；回退 WebFetch 同样点名 |

与 graphify / agentmemory 同类：默认执行。区别是本规则只在**联网取内容**时插入，不替代代码库内的 `graphify query` 或 `memory_recall`。

## 证据与来源

- 规则正文：`%USERPROFILE%\.cursor\rules\firecrawl-web-fetch.mdc`
- 备份：`cursor-rules/latest/rules/firecrawl-web-fetch.mdc`、`firecrawl-web-fetch--global.mdc`
- 根指南：`FIRECRAWL.md`、`TRENDRADAR.md`、`SCRAPLING.md`
- TrendRadar：[03 · 自动调用规则](../trendradar/03-auto-rule.md)
- Scrapling：[03 · 自动调用规则](../scrapling/03-auto-rule.md)

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
