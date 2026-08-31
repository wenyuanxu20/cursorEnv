# agents-radar · 01 用法

## 定义

本地 HTTP 提供健康检查、今日卡片、分类型全文和关键词搜索。AstrBot 用同一套接口做命令查询与后台推送。

## 关键结论

| 路径 | 作用 |
|------|------|
| `GET /health` | 探活 + 最新日期 |
| `GET /card` | 今日中文推送卡片（`?format=text`） |
| `GET /latest?type=ai-cli` | 指定类型全文 |
| `GET /search?q=OpenClaw` | 在今日日报里搜 |
| `GET /fingerprint` | 日期+报告集合，用于判断「有没有新的一天」 |

类型：`ai-cli` `ai-agents` `ai-infra` `ai-web` `ai-trending` `ai-hn` `ai-ph` `ai-arxiv` `ai-hf` `ai-community`。

AstrBot 命令：`/radar_bind` `/radar_latest` `/radar_push` `/radar_start` `/radar_stop` `/radar_status`。  
工具：`agents_radar_latest`、`agents_radar_search`。

## 证据与来源

- `getInfo/scripts/agents-radar-serve.py`
- `ai/AstrBot/extras/astrbot_plugin_agents_radar/main.py`

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用与推送](03-auto-rule.md)
