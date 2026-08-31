# agents-radar · 03 自动调用与推送

## 定义

问 **AI CLI / OpenClaw / Agent 生态日报** 时走本机 agents-radar，不要先当普通热榜丢给 TrendRadar。AstrBot 在已 `/radar_bind` 的会话里，fingerprint 变化（新的一天）就推送。

## 关键结论

| 项 | 值 |
|----|-----|
| 本机 API | `http://127.0.0.1:3355` |
| 未起服务 | `start-agents-radar.ps1`，不要空等 |
| AstrBot 推送 | `/radar_bind` 绑定 + 立刻发今日；之后按日推 |
| 重启不刷屏 | 默认 `alert_on_first_fetch=false`，指纹写入 KV |
| 点名工具 | 回复写明 agents-radar（及 `/card` 或工具名） |

与 TrendRadar 分工：国内平台热搜 → TrendRadar；海外 AI 工具/Agent 日报 → agents-radar。

## 证据与来源

- 规则：`.cursor/rules/firecrawl-web-fetch.mdc`（agents-radar 行）
- 插件：`ai/AstrBot/extras/astrbot_plugin_agents_radar/`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- TrendRadar：[03 · 自动调用规则](../trendradar/03-auto-rule.md)
