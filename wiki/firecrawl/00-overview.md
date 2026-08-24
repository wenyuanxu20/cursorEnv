# Firecrawl · 00 总览

## 定义

**Firecrawl** 是网页 → Markdown/结构化数据的抓取服务。cursorEnv 在 `getInfo/` 自托管其开源 API，作为 Agent **抓具体 URL / 站点正文** 的默认通道（先于 Cursor `WebFetch`/`WebSearch`）。热榜 / 舆情走并列的 [TrendRadar](../trendradar/00-overview.md)。

## 关键结论

| 结论 | 说明 |
|------|------|
| 必选安装 | `cursor-env-manifest.json` 中 `necessity=必要`；最小环境含 Firecrawl |
| 本机已部署 | 2026-08-24：API `:3002` 健康检查 ok，scrape example.com 成功 |
| 本机 API | `http://127.0.0.1:3002`，钉选上游 `v2.11.162` |
| 目录 | 脚本与说明在 `getInfo/`；源码检出 `getInfo/firecrawl/` 不入库 |
| Cursor | `%USERPROFILE%\.cursor\mcp.json` 键名 `firecrawl`，`FIRECRAWL_API_URL` 指向本机 |
| 自动调用 | 全局 `firecrawl-web-fetch.mdc`（`alwaysApply`）：URL/正文走 Firecrawl，热榜走 TrendRadar |
| 鉴权 | 本机评估栈关闭 DB auth；禁止把 3002 暴露到公网 |
| 能力边界 | 自托管有 scrape/crawl/map；截图/Fire-engine/Cloud Agent 能力默认没有 |

## 证据与来源

| 来源 | 路径 |
|------|------|
| 根指南 | `FIRECRAWL.md` |
| 启动脚本 | `getInfo/scripts/start-firecrawl.ps1` |
| 上游自托管 | https://docs.firecrawl.dev/contributing/self-host |
| 本地 MCP | https://docs.firecrawl.dev/mcp-server/local |
| 原始笔记 | `raw/firecrawl/research-notes.md` |

## 相关页面

- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
- TrendRadar：[00 · 总览](../trendradar/00-overview.md)
- Scrapling：[00 · 总览](../scrapling/00-overview.md)
- 目录：`wiki/index.md`
