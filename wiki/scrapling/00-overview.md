# Scrapling · 00 总览

## 定义

**Scrapling**（上游 [D4Vinci/Scrapling](https://github.com/D4Vinci/Scrapling)）是自适应网页抓取框架，带官方 MCP。cursorEnv 在 `getInfo/scrapling/` 用 uv 钉选 PyPI 包，作为 Agent **反爬 / Cloudflare / Firecrawl 失败** 时的本机通道；普通文档站仍走 [Firecrawl](../firecrawl/00-overview.md)，热榜走 [TrendRadar](../trendradar/00-overview.md)。

## 关键结论

| 结论 | 说明 |
|------|------|
| 必选安装 | `cursor-env-manifest.json` 中 `necessity=必要`；与 Firecrawl / TrendRadar 共用联网规则 |
| 本机已部署 | 2026-08-24：`getInfo/scrapling/` uv 钉选 `0.4.15`；STDIO MCP `scrapling-mcp.exe` |
| 钉选 | `scrapling[all]==0.4.15` + CPython 3.12 |
| 目录 | uv 项目 `getInfo/scrapling/` 入库；`.venv/` 不入库 |
| Cursor | `%USERPROFILE%\.cursor\mcp.json` 键名 `scrapling`，STDIO `scrapling-mcp.exe` |
| 自动调用 | 全局 `firecrawl-web-fetch.mdc`：三件套本机已部署；先 Firecrawl，失败或反爬再本机 Scrapling |
| HTTP MCP | 可选 `:3344`，`--no-auth` 仅 localhost |

## 证据与来源

| 来源 | 路径 |
|------|------|
| 根指南 | `SCRAPLING.md` |
| 启动脚本 | `getInfo/scripts/start-scrapling.ps1` |
| 上游 | https://github.com/D4Vinci/Scrapling |
| MCP 文档 | https://scrapling.readthedocs.io/en/latest/ai/mcp-server.html |
| 原始笔记 | `raw/scrapling/research-notes.md` |

## 相关页面

- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
- Firecrawl：[00 · 总览](../firecrawl/00-overview.md)
- TrendRadar：[00 · 总览](../trendradar/00-overview.md)
- 目录：`wiki/index.md`
