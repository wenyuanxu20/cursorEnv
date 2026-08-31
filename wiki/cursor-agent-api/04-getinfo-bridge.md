# Cursor Agent API · 04 AstrBot ↔ getInfo

## 定义

让 **AstrBot 查询网上信息** 时也能用 cursorEnv `getInfo/`（TrendRadar 热榜、Firecrawl 正文、Scrapling 反爬回退、agents-radar 日报推送）。IDE 里靠用户 `mcp.json`；AstrBot 有 HTTP 插件路径，对应 Cursor 主模型与 SiliconFlow 回退。

## 关键结论

| 路径 | 何时用 | 怎么调 getInfo |
|------|--------|----------------|
| **A. Cursor Agent MCP** | AstrBot 主模型走 cursor-proxy `:18791` | `agent --approve-mcps`；工作区 `ai/AstrBot/.cursor/mcp.json` + `firecrawl-web-fetch.mdc` |
| **B. AstrBot 插件 HTTP** | SiliconFlow 回退，或未走 Agent MCP | `astrbot_plugin_getinfo` 直连 `:3002` / `:3333` / 可选 `:3344` |
| 安装 | Windows 本机 | `getInfo/scripts/install-astrbot-getinfo.ps1` |
| 自测 | 私聊 | `/getinfo_ping` |
| 阿里云 ECS | 手机 IM | **已部署 2026-08-31**：TrendRadar `:3333` + scrape shim `:3002`；完整 Firecrawl Compose 因 3.5 GiB **未装** |

### 本机约定（Windows）

| 项 | 值 |
|----|-----|
| 插件源 | `ai/AstrBot/extras/astrbot_plugin_getinfo/` |
| 运行时 | `ai/AstrBot/data/plugins/astrbot_plugin_getinfo/`（`data/` 不入库） |
| Agent 规则 | `ai/AstrBot/.cursor/rules/firecrawl-web-fetch.mdc` |
| Agent MCP | `ai/AstrBot/.cursor/mcp.json`（Windows 路径，gitignore，勿原样拷到 Aliyun） |
| MCP 模板 | `getInfo/astrbot-mcp.windows.json` |
| 工具 | `getinfo_latest_news`、`getinfo_search_news`、`getinfo_scrape` |
| agents-radar | `http://127.0.0.1:3355`；插件 `astrbot_plugin_agents_radar`；`/radar_bind` |
| 回复图片 | 不走 getInfo。插件 `astrbot_plugin_sf_image` + `siliconflow_vl`；见 `ai/AstrBot/wiki/aliyun/sf-image.md` |

路由与 IDE 相同：热榜 TrendRadar → 正文 Firecrawl → 失败再 Scrapling。不要用 AstrBot 内置 `websearch_firecrawl_key` 打 Cloud。

### 与 Notion 插件的对照

| | Notion | getInfo |
|--|--------|---------|
| 为何不用只靠 Cursor MCP | ECS 无头 OAuth 会 401 | SiliconFlow 回退没有 MCP；ECS 也没有 Windows 上的 `:3002` |
| 做法 | 官方 REST + 预检索注入 | 本机 HTTP + 热榜/URL 预检索注入 |

## 证据与来源

- 插件：`ai/AstrBot/extras/astrbot_plugin_getinfo/`
- 安装：`getInfo/scripts/install-astrbot-getinfo.ps1`
- 规则：`.cursor/rules/firecrawl-web-fetch.mdc`（AstrBot 段）
- 本机探活（2026-08-31）：Firecrawl `/v0/health/readiness` HTTP 200；TrendRadar `:3333/mcp` HTTP 406（无 MCP 头的 GET，服务在听）

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 本地 CLI + proxy](01-local-cli-proxy.md)
- Firecrawl：[03 · 自动调用规则](../firecrawl/03-auto-rule.md)
- TrendRadar：[00 · 总览](../trendradar/00-overview.md)
- Scrapling：[00 · 总览](../scrapling/00-overview.md)
