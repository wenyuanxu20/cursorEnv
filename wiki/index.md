# cursorEnv 知识库索引

Cursor 开发环境配置与迁移文档仓库的知识层。跨会话决策优先 `memory_recall`；代码与配置问题优先 `graphify query "<问题>"`（图谱在本地 `graphify-out/`，不入库）；人读总览见根目录 [README.md](../README.md)。

## Headroom（Token 压缩 × Cursor）

> 配置中枢：`cursorEnv` · 代理 `http://127.0.0.1:8787` · 16 个子项目 `/p/{name}` 路由

| 页 | 内容 |
|----|------|
| [00 · Headroom 总览](headroom/00-overview.md) | 是什么、本机部署状态、与 Graphify 关系 |
| [01 · 架构与路由](headroom/01-architecture.md) | Hub 模型、URL 前缀、单代理多项目 |
| [02 · 日常使用](headroom/02-daily-usage.md) | 启动代理 → 切换子项目 → 粘贴 Base URL |
| [03 · Cursor BYOK](headroom/03-byok-cursor.md) | 为何订阅模型不走代理、OpenAI/Anthropic 配置 |
| [04 · 子项目映射表](headroom/04-subproject-map.md) | 16 个项目 ID、类别、Base URL |
| [05 · 脚本参考](headroom/05-scripts-reference.md) | `scripts/headroom-*.ps1` 参数与用法 |
| [06 · 排障与验证](headroom/06-troubleshooting.md) | verify 脚本、PATH、持久服务、stats 判定 |
| [07 · 与其他方案对比](headroom/07-comparison.md) | RTK / CCR / 竞品简要对比 |

快速入口：仓库根 [HEADROOM.md](../HEADROOM.md)

## Caveman（输出压缩 Skill）

> 全局安装：`%USERPROFILE%\.agents\skills\caveman*` · 不占 Headroom 端口

| 页 | 内容 |
|----|------|
| [00 · 总览](caveman/00-overview.md) | 定位、本机部署状态、冲突确认 |
| [01 · 用法与命令](caveman/01-usage.md) | `/caveman` 档位与辅助技能 |

快速入口：仓库根 [CAVEMAN.md](../CAVEMAN.md)

## Ponytail（YAGNI Skill）

> 全局安装：`%USERPROFILE%\.agents\skills\ponytail*` · 不占 Headroom 端口

| 页 | 内容 |
|----|------|
| [00 · 总览](ponytail/00-overview.md) | 定位、本机部署状态、冲突确认 |
| [01 · 用法与命令](ponytail/01-usage.md) | `/ponytail` 档位、阶梯与辅助技能 |

快速入口：仓库根 [PONYTAIL.md](../PONYTAIL.md)

## UZI（游资 · 股票深度分析 Skill）

> 全局安装：`%USERPROFILE%\.agents\skills\{uzi,deep-analysis,…}` · 运行时：`github/UZI-Skill`

| 页 | 内容 |
|----|------|
| [00 · 总览](uzi/00-overview.md) | 定位、本机部署状态、冲突确认 |
| [01 · 用法与命令](uzi/01-usage.md) | CLI 深度档位与五技能路由 |

快速入口：仓库根 [UZI.md](../UZI.md)

## Serenity（供应链瓶颈猎人 Skill）

> 全局安装：`%USERPROFILE%\.agents\skills\serenity-skill` · 整仓：`github/serenity-skill`

| 页 | 内容 |
|----|------|
| [00 · 总览](serenity/00-overview.md) | 定位、本机部署状态、冲突确认 |
| [01 · 用法与命令](serenity/01-usage.md) | 触发词、路由模式与 scorecard |

快速入口：仓库根 [SERENITY.md](../SERENITY.md)

## Bottleneck Hunter（AI Berkshire · 供应链瓶颈猎手）

> 全局安装：`%USERPROFILE%\.agents\skills\bottleneck-hunter` · 整仓：`github/ai-berkshire`

| 页 | 内容 |
|----|------|
| [00 · 总览](bottleneck-hunter/00-overview.md) | 定位、本机部署状态、冲突确认 |
| [01 · 用法与命令](bottleneck-hunter/01-usage.md) | 触发词与 tools 运行时 |

快速入口：仓库根 [BOTTLENECK-HUNTER.md](../BOTTLENECK-HUNTER.md)

## Serenity Bottleneck Hunter（mrjie7205）

> 全局安装：`%USERPROFILE%\.agents\skills\serenity-bottleneck-hunter` · 整仓：`github/serenity-bottleneck-hunter`

| 页 | 内容 |
|----|------|
| [00 · 总览](serenity-bottleneck-hunter/00-overview.md) | 定位、完整包部署、与姊妹 skill 关系 |
| [01 · 用法](serenity-bottleneck-hunter/01-usage.md) | 触发词、scripts、价格纪律 |

快速入口：仓库根 [SERENITY-BOTTLENECK-HUNTER.md](../SERENITY-BOTTLENECK-HUNTER.md)

## Notion MCP（连接 / 授权 / 飞书桥接）

> 全局安装：`%USERPROFILE%\.cursor\skills\notion-mcp`、`%USERPROFILE%\.agents\skills\notion-mcp` · IDE：`plugin-notion-workspace-notion` + `user-notion-token`

| 页 | 内容 |
|----|------|
| [00 · 总览](notion-mcp/00-overview.md) | 定位、本机路径、与 Fate 分工 |
| [01 · 授权与配置](notion-mcp/01-auth-and-config.md) | 插件 MCP、`mcp_auth`、OAuth / PAT 存放 |
| [02 · 飞书桥接](notion-mcp/02-feishu-bridge.md) | Fate `notion_bridge` 与 CLI needsAuth |
| [03 · 桥接直连建页](notion-mcp/03-bridge-create-page.md) | needsAuth 时 refresh OAuth + `notion-create-pages` |
| [04 · Token 兜底](notion-mcp/04-token-fallback.md) | PAT `notion-token` + Agent 自动切换顺序 |
| [05 · 环境与运维](notion-mcp/05-environment-and-ops.md) | 本机快照、能力边界、AiRec 锚点（2026-08-12） |

快速入口：仓库根 [NOTION-MCP.md](../NOTION-MCP.md)

## agentmemory（Agent 持久记忆）

> 全局 npm：`@agentmemory/agentmemory` + `@agentmemory/mcp` · 引擎 `iii` 0.11.2 · REST `:3111` / Viewer `:3113`

| 页 | 内容 |
|----|------|
| [00 · 总览](agentmemory/00-overview.md) | 定位、本机状态、与 mcp-memory 模板区别 |
| [01 · 用法与命令](agentmemory/01-usage.md) | Cursor MCP、REST、Viewer、记什么/不记什么 |
| [02 · 本机部署](agentmemory/02-local-deploy.md) | Windows 安装路径、端口、MCP、排障（2026-08-12） |
| [03 · 自动调用规则](agentmemory/03-auto-rule.md) | 全局 `alwaysApply`：开场 recall、决策 save，无需口头提醒 |
| [04 · Notion 同步](agentmemory/04-notion-sync.md) | 可读 Notion 页写入 `mem:memories.bin`；会话增量自动同步 |

快速入口：仓库根 [AGENTMEMORY.md](../AGENTMEMORY.md)

## Firecrawl（本机网页抓取）

> 部署根：`getInfo/` · API `http://127.0.0.1:3002` · MCP `firecrawl` · 全局规则 `firecrawl-web-fetch.mdc`

| 页 | 内容 |
|----|------|
| [00 · 总览](firecrawl/00-overview.md) | 必选安装、本机 API、与 WebFetch 分工 |
| [01 · 用法](firecrawl/01-usage.md) | scrape / crawl / map / HTTP 回退 |
| [02 · 本机部署](firecrawl/02-local-deploy.md) | Docker Compose、MCP、资源与安全 |
| [03 · 自动调用规则](firecrawl/03-auto-rule.md) | 联网：正文本机 Firecrawl，热榜本机 TrendRadar，反爬本机 Scrapling |

快速入口：仓库根 [FIRECRAWL.md](../FIRECRAWL.md)

## TrendRadar（本机热榜 MCP）

> 部署根：`getInfo/` · MCP `http://127.0.0.1:3333/mcp` · 键 `trendradar` · 与 Firecrawl / Scrapling 共用 `firecrawl-web-fetch.mdc`

| 页 | 内容 |
|----|------|
| [00 · 总览](trendradar/00-overview.md) | 必选安装、热榜 vs 正文分工 |
| [01 · 用法](trendradar/01-usage.md) | get_latest_news / search_news / trigger_crawl |
| [02 · 本机部署](trendradar/02-local-deploy.md) | Docker 优先、uv 回退、MCP |
| [03 · 自动调用规则](trendradar/03-auto-rule.md) | 与 Firecrawl / Scrapling 同一条 alwaysApply 规则 |

快速入口：仓库根 [TRENDRADAR.md](../TRENDRADAR.md)

## Scrapling（本机反爬抓取）

> 部署根：`getInfo/scrapling/` · 钉选 `0.4.15` · MCP 键 `scrapling` · 与 Firecrawl / TrendRadar 共用 `firecrawl-web-fetch.mdc`

| 页 | 内容 |
|----|------|
| [00 · 总览](scrapling/00-overview.md) | 必选安装、与 Firecrawl 分工 |
| [01 · 用法](scrapling/01-usage.md) | make_request / fetch / stealthy_fetch |
| [02 · 本机部署](scrapling/02-local-deploy.md) | uv 钉选、浏览器、STDIO MCP |
| [03 · 自动调用规则](scrapling/03-auto-rule.md) | 本机已部署；反爬或 Firecrawl 失败时调用 |

快速入口：仓库根 [SCRAPLING.md](../SCRAPLING.md)

## agents-radar（AI 生态日报）

> 部署根：`getInfo/agents-radar/` · HTTP `http://127.0.0.1:3355` · AstrBot `/radar_bind`

| 页 | 内容 |
|----|------|
| [00 · 总览](agents-radar/00-overview.md) | 已发布日报的本机 HTTP，不是 Actions LLM 流水线 |
| [01 · 用法](agents-radar/01-usage.md) | /health /card /latest /search |
| [02 · 本机部署](agents-radar/02-local-deploy.md) | start 脚本与阿里云 systemd |
| [03 · 自动调用与推送](agents-radar/03-auto-rule.md) | 与 TrendRadar 分工；AstrBot 按日推送 |

快速入口：仓库根 [AGENTS-RADAR.md](../AGENTS-RADAR.md)

## 长篇小说连续性（Wiki canon）

> 全局技能：`novel-continuity` · 触发词 `构建小说wiki` · 记忆只记铁律

| 页 | 内容 |
|----|------|
| [00 · 总览](novel-writing/00-overview.md) | 脚手架、与 agentmemory 的分工 |
| [01 · 记忆政策](novel-writing/01-memory-policy.md) | 该记 / 不该记 |
| [02 · 用法](novel-writing/02-usage.md) | 新开小说仓与每章流程 |

快速入口：仓库根 [NOVEL-WRITING.md](../NOVEL-WRITING.md)

## 跨项目知识库总览（knowledge-hub）

> 路径：`C:\Users\xwy12\Desktop\my-project\knowledge-hub` · 全局规则 `knowledge-hub-dual-update.mdc`

| 页 | 内容 |
|----|------|
| [00 · 总览](knowledge-hub/00-overview.md) | 各项目 wiki 保留原地，总览目录双写；graphify 用 junction |

## Cursor Agent API（程序化调用）

> 实现在 sibling `ai/`（AstrBot cursor-proxy）；本仓只存调用方式。主路径：本地 `agent` CLI + OpenAI 兼容 proxy `:18791`

| 页 | 内容 |
|----|------|
| [00 · 总览](cursor-agent-api/00-overview.md) | 三条路径选型：本地 proxy / Cloud REST / 官方 SDK |
| [01 · 本地 CLI + proxy](cursor-agent-api/01-local-cli-proxy.md) | AstrBot 生产：`agent -p` + `streaming-proxy.mjs` |
| [02 · Cloud REST](cursor-agent-api/02-cloud-rest.md) | `https://api.cursor.com`，Basic `api_key:` |
| [03 · SDK 与陷阱](cursor-agent-api/03-sdk-and-traps.md) | `@cursor/sdk`；与 A/B 对照；已踩坑 |
| [04 · AstrBot ↔ getInfo](cursor-agent-api/04-getinfo-bridge.md) | 查网上信息时走本机 TrendRadar / Firecrawl / Scrapling |

快速入口：仓库根 [CURSOR-AGENT-API.md](../CURSOR-AGENT-API.md)

## 其他工具链

| 文档 | 说明 |
|------|------|
| [GRAPHIFY.md](../GRAPHIFY.md) | 代码知识图谱 CLI |
| [knowledge-hub](knowledge-hub/00-overview.md) | my-project 跨项目 wiki/graphify 总览与双写 |
| [cursor-env-manifest.json](../cursor-env-manifest.json) | 机器可读环境清单 |
| [agency-agents.md](../agency-agents.md) | 多 Agent 编排 |
| [MATTPOCOCK-SKILLS.md](../MATTPOCOCK-SKILLS.md) | 工程流程 Skills |
| [CAVEMAN.md](../CAVEMAN.md) | Caveman 输出压缩 Skill |
| [PONYTAIL.md](../PONYTAIL.md) | Ponytail YAGNI Skill |
| [UZI.md](../UZI.md) | UZI 股票深度分析 Skill |
| [SERENITY.md](../SERENITY.md) | Serenity 供应链瓶颈猎人 Skill（muxuuu） |
| [BOTTLENECK-HUNTER.md](../BOTTLENECK-HUNTER.md) | Bottleneck Hunter（AI Berkshire） |
| [SERENITY-BOTTLENECK-HUNTER.md](../SERENITY-BOTTLENECK-HUNTER.md) | Serenity Bottleneck Hunter（mrjie7205） |
| [NOTION-MCP.md](../NOTION-MCP.md) | Notion MCP 连接与授权 |
| [AGENTMEMORY.md](../AGENTMEMORY.md) | agentmemory 持久记忆部署与使用 |
| [FIRECRAWL.md](../FIRECRAWL.md) | 本机 Firecrawl 网页抓取 |
| [TRENDRADAR.md](../TRENDRADAR.md) | 本机 TrendRadar 热榜 MCP |
| [SCRAPLING.md](../SCRAPLING.md) | 本机 Scrapling 反爬 / Firecrawl 失败 |
| [AGENTS-RADAR.md](../AGENTS-RADAR.md) | 本机 agents-radar AI 生态日报 + AstrBot 推送 |
| [NOVEL-WRITING.md](../NOVEL-WRITING.md) | 长篇连续性 wiki 与记忆政策 |
| [CURSOR-AGENT-API.md](../CURSOR-AGENT-API.md) | 程序化调用 Cursor Agent（AstrBot proxy / Cloud REST / SDK） |

## 维护

- 规范：[AGENTS.md](../AGENTS.md)
- 变更：[log.md](log.md)
