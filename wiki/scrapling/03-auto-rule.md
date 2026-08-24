# Scrapling · 03 自动调用规则

## 定义

全局 Cursor 规则 `firecrawl-web-fetch.mdc`：任意工作区要从**网络**取信息时，热榜走 TrendRadar、普通页面走 Firecrawl、反爬或 Firecrawl 失败走 Scrapling，**不需要**用户点名工具。

## 关键结论

| 项 | 值 |
|----|-----|
| 生效范围 | **所有 Cursor 项目**（`alwaysApply: true`） |
| 全局规则 | `%USERPROFILE%\.cursor\rules\firecrawl-web-fetch.mdc` |
| 中枢副本 | `cursorEnv/.cursor/rules/firecrawl-web-fetch.mdc` |
| Scrapling MCP | 键名 `scrapling`，运行时 id `user-scrapling`，STDIO |
| Firecrawl MCP | 键名 `firecrawl`，运行时 id `user-firecrawl`，API `:3002` |
| TrendRadar MCP | 键名 `trendradar`，运行时 id `user-trendradar`，`:3333` |
| 未安装 | 跑 `getInfo/scripts/start-scrapling.ps1`，不要空等 |
| 回退 | 该 URL 上 Firecrawl 与 Scrapling 都失败（热榜还要 TrendRadar 失败）才用 WebFetch/WebSearch，并写明原因 |
| 点名工具 | 回复里写明实际用了哪些 getInfo 工具（Firecrawl / TrendRadar / Scrapling 及 MCP 名） |

与 graphify / agentmemory 同类：默认执行。本规则只在**联网取内容**时插入，不替代 `graphify query` 或 `memory_recall`。

## 证据与来源

- 规则正文：`%USERPROFILE%\.cursor\rules\firecrawl-web-fetch.mdc`
- 备份：`cursor-rules/latest/rules/firecrawl-web-fetch.mdc`、`firecrawl-web-fetch--global.mdc`
- 根指南：`SCRAPLING.md`、`FIRECRAWL.md`、`TRENDRADAR.md`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- Firecrawl：[03 · 自动调用规则](../firecrawl/03-auto-rule.md)
- TrendRadar：[03 · 自动调用规则](../trendradar/03-auto-rule.md)
