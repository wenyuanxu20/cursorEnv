# Cloud Agent · 总览

## 定义

**Cloud Agent** 是 Cursor 在远程隔离 Ubuntu 环境中运行的自主编码 Agent，可检出仓库、改代码、跑测试、推送分支并开 PR。

## 关键结论

| 项 | 要点 |
|----|------|
| 入口 | Cursor Agents 面板 · [仪表盘](https://cursor.com/dashboard/cloud-agents) · Automations |
| 环境 | `.cursor/environment.json` > 个人 Environment > 团队 Environment |
| 加速 | **Builds** 预跑幂等 `install`，Agent 从快照启动 |
| 密钥 | 仅放 Dashboard **Secrets**，不进 Git |
| cursorEnv | Graphify 可装；agentmemory/Headroom 为本机向，Cloud 需单独方案 |
| 验收 | 要求 PR + 终端/截图/录屏证据 |

## 证据与来源

- 仓库根 [CLOUD-AGENT.md](../../CLOUD-AGENT.md)
- 官方：[Setup](https://cursor.com/docs/cloud-agent/setup) · [Builds](https://cursor.com/docs/cloud-agent/builds)
- Schema：https://cursor.com/schemas/environment.schema.json

## 相关页面

- [wiki/index.md](../index.md)
- [AGENTS.md](../../AGENTS.md)
