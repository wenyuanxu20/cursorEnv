# agentmemory 本机部署与调研笔记（2026-08-12）

## 调研

- 上游：https://github.com/rohitg00/agentmemory（Apache-2.0）
- my-project / cursorEnv：**无**现成 agentmemory/mem0 服务仓
- 仅有 `repos/agency-agents/integrations/mcp-memory` Prompt 模板

## 部署动作

1. `npm i -g @agentmemory/agentmemory @agentmemory/mcp`（npmmirror）
2. 手动安装 `iii.exe` 0.11.2 → `.local\bin`
3. 启动服务；写入 Cursor `mcp.json`
4. 脚本：`scripts/start-agentmemory.ps1`

## 验证

- livez ok；remember 201；smart-search 命中 probe
- status：healthy，Memories≥1，bm25-only
