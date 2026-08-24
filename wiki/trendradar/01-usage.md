# TrendRadar · 01 用法

## 定义

Agent 查热榜、舆情、今日新闻时的 MCP 工具顺序。

## 关键结论

| 意图 | 优先动作 |
|------|----------|
| 今天有什么热点 | `get_latest_news`；缺今日数据则 `trigger_crawl` |
| 按日期 / 「最近一周」 | 先 `resolve_date_range`，再 `get_news_by_date` |
| 关键词 / 实体 | `search_news`（需要链接时 `include_url=true`） |
| 话题统计 | `get_trending_topics` |
| 条目全文 | 用返回的 URL 调 Firecrawl `firecrawl_scrape`，不要默认 `read_article` |
| 探活 | `curl` `http://127.0.0.1:3333/mcp`（Accept 含 `text/event-stream`） |

默认返回约 50 条、偏「今天」、默认不含 URL（省 token）。对话里说「要链接」「最近 7 天」即可放宽。

服务未起：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-trendradar.ps1
```

回退：TrendRadar 与 Firecrawl **都失败** 时才用 `WebSearch`/`WebFetch` 当主通道，并说明原因。

## 证据与来源

- 规则：`.cursor/rules/firecrawl-web-fetch.mdc`
- 上游 FAQ：`getInfo/TrendRadar/README-MCP-FAQ.md`
- 根指南：`TRENDRADAR.md`

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
