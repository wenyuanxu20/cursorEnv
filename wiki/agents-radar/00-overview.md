# agents-radar · 00 总览

## 定义

**agents-radar**（上游 [duanyytop/agents-radar](https://github.com/duanyytop/agents-radar)）每日聚合 AI CLI / Agent / 基建 / HN 等信号，发布双语日报。cursorEnv 在 `getInfo/` 部署的是**已发布日报的本机 HTTP**，不是 GitHub Actions LLM 流水线。

## 关键结论

| 结论 | 说明 |
|------|------|
| 本机 API | `http://127.0.0.1:3355`，仅 loopback |
| 目录 | 说明 `getInfo/agents-radar/`；脚本 `getInfo/scripts/agents-radar-serve.py` |
| 数据 | jsDelivr / GitHub Pages / raw；缓存 `cache/` 不入库 |
| AstrBot | 插件 `astrbot_plugin_agents_radar`；`/radar_bind` 推送 |
| 不跑 | 上游 `pnpm start`（要 LLM Key）；不自建 Cloudflare MCP |
| 安全 | 不要把 3355 放进安全组 |

## 证据与来源

| 来源 | 路径 |
|------|------|
| 根指南 | `AGENTS-RADAR.md` |
| 上游 README | https://github.com/duanyytop/agents-radar |
| Web UI | https://duanyytop.github.io/agents-radar |
| 启动脚本 | `getInfo/scripts/start-agents-radar.ps1` |

## 相关页面

- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用与推送](03-auto-rule.md)
- TrendRadar：[00 · 总览](../trendradar/00-overview.md)
- AstrBot 桥接：[Cursor Agent API · 04](../cursor-agent-api/04-getinfo-bridge.md)
