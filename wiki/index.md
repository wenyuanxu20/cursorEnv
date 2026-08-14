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

## 其他工具链

| 文档 | 说明 |
|------|------|
| [GRAPHIFY.md](../GRAPHIFY.md) | 代码知识图谱 CLI |
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

## 维护

- 规范：[AGENTS.md](../AGENTS.md)
- 变更：[log.md](log.md)
