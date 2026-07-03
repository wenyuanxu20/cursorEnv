# cursorEnv 知识库索引

Cursor 开发环境配置与迁移文档仓库的知识层。代码与配置问题优先用 `graphify query "<问题>"`（图谱在 `graphify-out/`）。

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

## 其他工具链

| 文档 | 说明 |
|------|------|
| [GRAPHIFY.md](../GRAPHIFY.md) | 代码知识图谱 CLI |
| [cursor-env-manifest.json](../cursor-env-manifest.json) | 机器可读环境清单 |
| [agency-agents.md](../agency-agents.md) | 多 Agent 编排 |

## 维护

- 规范：[AGENTS.md](../AGENTS.md)
- 变更：[log.md](log.md)
