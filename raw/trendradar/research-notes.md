# TrendRadar 本机部署笔记（cursorEnv/getInfo）

日期：2026-08-24

- 上游：https://github.com/sansan0/TrendRadar ；本机 `git clone --depth 1` → `8ee2602`
- 部署根：`cursorEnv/getInfo/`（与 Firecrawl 并列）
- Docker：`wantcat/trendradar` + `wantcat/trendradar-mcp`；本机 daemon 走 `docker.m.daocloud.io` 时 HEAD `latest` 曾 **403**
- 回退：`uv sync` + `uv run python -m mcp_server.server --transport http --host 127.0.0.1 --port 3333` + 一次 `uv run python -m trendradar`
- Cursor MCP：`~/.cursor/mcp.json` 键名 `trendradar`，`url` = `http://127.0.0.1:3333/mcp`
- 全局规则：`firecrawl-web-fetch.mdc`（热榜 TrendRadar，正文 Firecrawl）
- 样例数据：检出自带 `output/news/2025-12-21`～`27`；今日数据需 crawl / `trigger_crawl`
- 2026-08-24 本机一次 crawl：`toutiao/baidu/weibo/douyin/zhihu/...` 成功 11 平台、新增 255 条 → `output/news/2026-08-24.db`；未配 AI Key 时分析/翻译跳过；雅虎财经 RSS 403
