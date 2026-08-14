# cursorEnv

Cursor 开发环境配置中枢：把 **规则、Skills、工具链、LLM Wiki、知识图谱、跨会话记忆** 收在一个仓库里，方便新机器复现，也方便 Agent 按同一套优先级查资料。

本仓库不是单一工具的说明页。根目录 `*.md` 是迁移/部署指南；`wiki/` 是结构化知识层；`graphify-out/`（本地生成、不入库）是代码与文档图谱；本机 `agentmemory` 是跨会话记忆。查询顺序见 [AGENTS.md](./AGENTS.md)。

## 四层入口

| 层 | 路径 | 用途 |
|----|------|------|
| 介绍与部署 | 本 README、`cursor-env-manifest.json`、根目录 `*.md` | 人读的「装什么、怎么装」 |
| LLM Wiki | [`wiki/index.md`](./wiki/index.md) | 主题页：定义 / 结论 / 来源 / 相关页 |
| Graphify | 本地 `graphify-out/` · [GRAPHIFY.md](./GRAPHIFY.md) | Agent 探索代码前先 `graphify query` |
| agentmemory | 本机 REST `:3111` / Viewer `:3113` · [AGENTMEMORY.md](./AGENTMEMORY.md) | 会话开场自动 recall；决策自动 save；可读 Notion 页增量同步 |

静态介绍页（规则藏书阁）：打开 [`web/index.html`](./web/index.html)。

## 文档索引

| 文件 | 说明 | 必要程度 |
|------|------|----------|
| [GRAPHIFY.md](./GRAPHIFY.md) | Graphify 代码知识图谱 | 必要 |
| [AGENTMEMORY.md](./AGENTMEMORY.md) | 跨会话持久记忆 + 自动 recall/save + Notion 同步 | 必要 |
| [NOVEL-WRITING.md](./NOVEL-WRITING.md) | 长篇连续性：wiki canon + 记忆该记/不该记 | 见 manifest |
| [NOTION-MCP.md](./NOTION-MCP.md) | Notion MCP 连接、授权与飞书桥接 | 见 manifest |
| [HEADROOM.md](./HEADROOM.md) | Headroom token 压缩 × Cursor 子项目映射 | 见 manifest |
| [AGENTSVIEW.md](./AGENTSVIEW.md) | AgentsView 会话浏览器 | 见 manifest |
| [KARPATHY.md](./KARPATHY.md) | Karpathy 编码风格规则 | 见 manifest |
| [karpathy-llm-wiki-knowledge-base-guide.md](./karpathy-llm-wiki-knowledge-base-guide.md) | LLM Wiki 脚手架（「构建LLM wiki」） | 必要 |
| [agency-agents.md](./agency-agents.md) | 多 Agent 编排规则 | 见 manifest |
| [MATTPOCOCK-SKILLS.md](./MATTPOCOCK-SKILLS.md) | Matt Pocock 工程流程 Skills | 见 manifest |
| [CAVEMAN.md](./CAVEMAN.md) | Caveman 输出压缩 Skill | 见 manifest |
| [PONYTAIL.md](./PONYTAIL.md) | Ponytail YAGNI / 最小实现 Skill | 见 manifest |
| [UZI.md](./UZI.md) | UZI（游资）股票深度分析 Skill | 见 manifest |
| [SERENITY.md](./SERENITY.md) | Serenity 供应链瓶颈猎人 Skill | 见 manifest |
| [BOTTLENECK-HUNTER.md](./BOTTLENECK-HUNTER.md) | Bottleneck Hunter（AI Berkshire） | 见 manifest |
| [SERENITY-BOTTLENECK-HUNTER.md](./SERENITY-BOTTLENECK-HUNTER.md) | Serenity Bottleneck Hunter（mrjie7205） | 见 manifest |
| [OKF.md](./OKF.md) | Open Knowledge Format 调研 | 参考 |
| [cursor-env-manifest.json](./cursor-env-manifest.json) | 环境配置清单（机器可读） | 核心 |
| [wiki/index.md](./wiki/index.md) | LLM Wiki 目录（Headroom、Skills、Notion MCP、agentmemory） | 推荐 |
| [repos/](./repos/) | 归并子仓库（agency-agents、serenity-bottleneck-hunter） | 见 manifest |
| [Quant-Research](https://github.com/wenyuanxu20/Quant-Research) | 投研 Skills monorepo（ai-berkshire 等） | 见 manifest |

## 新机器快速开始

1. 克隆本仓库
2. 阅读 `cursor-env-manifest.json` 中的 `necessary_only`（Graphify + LLM Wiki 脚手架）
3. 按 `GRAPHIFY.md` 安装最小 Cursor 环境
4. 按 `AGENTMEMORY.md` 启动本机记忆服务，并确认 `~\.cursor\mcp.json` 含 `agentmemory`
5. 按需部署 Notion MCP、Headroom 与其它 Skills（见 manifest `deploy_order`）

Agent 查本仓库时：`memory_recall` → `graphify query` → `wiki/index.md` → 根目录指南。

## 最小部署

```powershell
uv tool install "graphifyy[openai]"
graphify install --platform cursor
```

记忆服务（Windows：需手动放置 `iii.exe`，见 `AGENTMEMORY.md`）：

```powershell
pwsh .\scripts\start-agentmemory.ps1
```

详见各文档与 `cursor-env-manifest.json`。

## 本仓库不包含

- **agentmemory 记忆 blob**（`data/state_store.db/`）：本机运行时数据，含项目路径与会话结论，不入库。
- **Graphify 构建产物**（`graphify-out/`）：克隆后在仓库根执行 `graphify update .`（纯 AST）。文档语义提取需要 API Key。
- **密钥**：`NOTION_TOKEN`、API Key 只放用户环境变量，不进 Git。
