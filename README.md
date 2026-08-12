# cursorEnv

Cursor 开发环境配置与迁移文档仓库。

本仓库集中管理 Cursor 相关工具的安装、配置与一键迁移说明，便于在新机器上快速复现开发环境。

## 文档索引

| 文件 | 说明 | 必要程度 |
|------|------|----------|
| [GRAPHIFY.md](./GRAPHIFY.md) | Graphify 代码知识图谱 | 必要 |
| [AGENTSVIEW.md](./AGENTSVIEW.md) | AgentsView 会话浏览器 | 见 manifest |
| [KARPATHY.md](./KARPATHY.md) | Karpathy 编码风格规则 | 见 manifest |
| [agency-agents.md](./agency-agents.md) | 多 Agent 编排规则 | 见 manifest |
| [OKF.md](./OKF.md) | Open Knowledge Format 调研 | 参考 |
| [cursor-env-manifest.json](./cursor-env-manifest.json) | 环境配置清单（机器可读） | 核心 |
| [repos/](./repos/) | 归并子仓库（agency-agents、serenity-bottleneck-hunter） | 见 manifest |
| [Quant-Research](https://github.com/wenyuanxu20/Quant-Research) | 投研 Skills monorepo（ai-berkshire 等） | 见 manifest |
| [HEADROOM.md](./HEADROOM.md) | Headroom token 压缩 × Cursor 子项目映射 | 见 manifest |
| [MATTPOCOCK-SKILLS.md](./MATTPOCOCK-SKILLS.md) | Matt Pocock 工程流程 Skills | 见 manifest |
| [CAVEMAN.md](./CAVEMAN.md) | Caveman 输出压缩 Skill | 见 manifest |
| [PONYTAIL.md](./PONYTAIL.md) | Ponytail YAGNI / 最小实现 Skill | 见 manifest |
| [UZI.md](./UZI.md) | UZI（游资）股票深度分析 Skill | 见 manifest |
| [SERENITY.md](./SERENITY.md) | Serenity 供应链瓶颈猎人 Skill | 见 manifest |
| [BOTTLENECK-HUNTER.md](./BOTTLENECK-HUNTER.md) | Bottleneck Hunter（AI Berkshire） | 见 manifest |
| [SERENITY-BOTTLENECK-HUNTER.md](./SERENITY-BOTTLENECK-HUNTER.md) | Serenity Bottleneck Hunter（mrjie7205） | 见 manifest |
| [NOTION-MCP.md](./NOTION-MCP.md) | Notion MCP 连接、授权与飞书桥接 | 见 manifest |
| [wiki/index.md](./wiki/index.md) | LLM Wiki（含 Headroom、Skills、Notion MCP） | 推荐 |

## 新机器快速开始

1. 克隆本仓库
2. 阅读 `cursor-env-manifest.json` 中的 `necessary_only` 部分
3. 按 `GRAPHIFY.md` 安装最小 Cursor 环境
4. 按需部署其他工具

## 最小部署

```powershell
uv tool install "graphifyy[openai]"
graphify install --platform cursor
```

详见各文档与 `cursor-env-manifest.json`。
