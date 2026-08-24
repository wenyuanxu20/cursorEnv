# TrendRadar · 00 总览

## 定义

**TrendRadar**（上游 [sansan0/TrendRadar](https://github.com/sansan0/TrendRadar)）是多平台热榜聚合器。cursorEnv 在 `getInfo/` 部署它，作为 Agent **查热点 / 舆情 / 今日新闻** 的默认通道；具体网页正文仍走本机 Firecrawl。

## 关键结论

| 结论 | 说明 |
|------|------|
| 必选安装 | `cursor-env-manifest.json` 中 `necessity=必要`；与 Firecrawl、调用规则一起进最小环境 |
| 本机 MCP | `http://127.0.0.1:3333/mcp`，键名 `trendradar`，运行时 id `user-trendradar` |
| 目录 | 脚本在 `getInfo/scripts/`；源码检出 `getInfo/TrendRadar/` 不入库 |
| 部署路径 | 先 Docker Compose；Hub 镜像站 403 时脚本改 uv HTTP MCP + 一次 crawl |
| 自动调用 | 全局 `firecrawl-web-fetch.mdc`：热榜走 TrendRadar，URL 走 Firecrawl |
| 数据 | `getInfo/TrendRadar/output/`；MCP 只分析已抓到的日期，不是全网任意搜 |

## 证据与来源

| 来源 | 路径 |
|------|------|
| 根指南 | `TRENDRADAR.md` |
| 启动脚本 | `getInfo/scripts/start-trendradar.ps1` |
| 上游 | https://github.com/sansan0/TrendRadar |
| MCP FAQ | 检出内 `README-MCP-FAQ.md` |
| 原始笔记 | `raw/trendradar/research-notes.md` |

## 相关页面

- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
- Firecrawl：[00 · 总览](../firecrawl/00-overview.md)
- Scrapling：[00 · 总览](../scrapling/00-overview.md)
- 目录：`wiki/index.md`
