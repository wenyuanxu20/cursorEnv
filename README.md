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
| [HEADROOM.md](./HEADROOM.md) | Headroom token 压缩 × Cursor 子项目映射 | 见 manifest |
| [wiki/index.md](./wiki/index.md) | LLM Wiki（含 Headroom 结构化知识页） | 推荐 |

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
