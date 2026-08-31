# agents-radar · 本机 AI 生态日报

> 上游：[duanyytop/agents-radar](https://github.com/duanyytop/agents-radar)  
> 本地 API：`http://127.0.0.1:3355`（仅本机）  
> 启动：`getInfo/scripts/start-agents-radar.ps1`  
> AstrBot：`extras/astrbot_plugin_agents_radar` · `/radar_bind`

## 是什么

**agents-radar** 每天聚合 AI CLI、Agent 生态、基建、GitHub 热门、HN 等，写成双语日报。上游用 GitHub Actions + LLM 生成；cursorEnv **不跑**那条流水线（需要 `GITHUB_TOKEN` 和模型 Key，整仓还含全部历史日报）。

本机部署的是轻量 HTTP：读**已发布**的 Markdown（jsDelivr / GitHub Pages / raw），给查询和 AstrBot 推送。

| 意图 | 工具 |
|------|------|
| 热榜 / 舆情 | TrendRadar |
| AI CLI / OpenClaw / Agent 日报 | **agents-radar** `:3355` |
| 具体 URL 正文 | Firecrawl |
| 反爬 | Scrapling |

## 本机约定

| 项 | 值 |
|----|-----|
| 说明目录 | `getInfo/agents-radar/`（README 入库；`cache/` 不入库） |
| API | `http://127.0.0.1:3355` |
| 启动 | `powershell.exe -File .\getInfo\scripts\start-agents-radar.ps1` |
| 停止 | `.\getInfo\scripts\stop-agents-radar.ps1` |
| 实现 | `getInfo/scripts/agents-radar-serve.py` |
| 插件源 | `ai/AstrBot/extras/astrbot_plugin_agents_radar/` |
| 安装 | `getInfo/scripts/install-astrbot-agents-radar.ps1` |
| 阿里云 | systemd `getinfo-agents-radar` · `/opt/getInfo` · **不要**放行 3355 |

## 快速开始

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\start-agents-radar.ps1
curl.exe -s http://127.0.0.1:3355/health
curl.exe -s "http://127.0.0.1:3355/card?format=text"
```

AstrBot 私聊：`/radar_bind`（绑定当前会话并立刻推今日摘要）。之后每天新日报自动推。`/radar_latest` 只看不推。

## 与上游 MCP 的关系

上游托管 MCP：`https://agents-radar-mcp.duanyytop.workers.dev`（Cloudflare Worker）。本机不自建 wrangler；AstrBot 走本地 `:3355`，避免手机路径依赖外网 Worker。
