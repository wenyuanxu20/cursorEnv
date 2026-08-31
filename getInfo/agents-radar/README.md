# agents-radar（getInfo 本地部署）

上游：[duanyytop/agents-radar](https://github.com/duanyytop/agents-radar)

上游本体是 **GitHub Actions 日报流水线**（每天约 07:00 CST 聚合 CLI / Agent / 基建 / HN 等，再写成双语 Markdown）。本目录**不跑**那条需要 `GITHUB_TOKEN` + LLM Key 的 `pnpm start`。

本地部署的是轻量 HTTP 服务：读取已发布的日报（jsDelivr / GitHub Pages / raw），供 AstrBot 推送与查询。

| 项 | 值 |
|----|-----|
| API | `http://127.0.0.1:3355`（仅本机） |
| 启动 | `getInfo/scripts/start-agents-radar.ps1` |
| 停止 | `getInfo/scripts/stop-agents-radar.ps1` |
| 实现 | `getInfo/scripts/agents-radar-serve.py` |
| 缓存 | `getInfo/agents-radar/cache/`（不入库） |
| 可选完整检出 | `getInfo/agents-radar/upstream/`（gitignore；仓库含全部历史日报，约几十 MB） |
| Web UI | https://duanyytop.github.io/agents-radar |
| 托管 MCP | `https://agents-radar-mcp.duanyytop.workers.dev`（Cloudflare Worker，本机不自建 wrangler） |

```text
GET /health
GET /card          今日推送卡片（中文摘要）
GET /latest?type=ai-cli
GET /search?q=OpenClaw
GET /fingerprint
```

AstrBot 插件：`ai/AstrBot/extras/astrbot_plugin_agents_radar/`  
安装：`getInfo/scripts/install-astrbot-agents-radar.ps1`  
私聊：`/radar_bind` 绑定推送 → `/radar_latest` 立刻看今日摘要。
