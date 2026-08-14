# agentmemory · 00 总览

## 定义

**agentmemory**（上游 [rohitg00/agentmemory](https://github.com/rohitg00/agentmemory)）是本机运行的 AI 编码 Agent **持久记忆层**：REST + MCP + Web Viewer，跨会话检索决策、偏好与排障结论。本主题记录本机部署状态、与 Cursor 的接线方式，以及日常用法。

## 关键结论

| 结论 | 说明 |
|------|------|
| 本机已部署 | CLI `0.9.28` + iii `0.11.2`；REST `:3111` / Viewer `:3113`（2026-08-12 验证） |
| Cursor 已接线 | `%USERPROFILE%\.cursor\mcp.json` → `agentmemory` / `agentmemory-mcp` |
| 默认零 LLM | 无 Provider Key 时 BM25-only；可选开 compress / inject |
| Windows 注意 | 引擎需手动放 `iii.exe`；`agentmemory connect` 不可用，须手改 MCP |
| 非同类物 | `agency-agents/integrations/mcp-memory` 是 Prompt 集成说明，不是记忆服务 |
| 启动入口 | `scripts/start-agentmemory.ps1` |
| 自动调用 | 全局规则 `agentmemory-auto.mdc`（`alwaysApply`）：会话开场 `memory_recall`，有可复用结论时 `memory_save`，无需用户口头提醒 |
| Notion 同步 | 全局 `notion-agentmemory-sync.mdc`：开场增量 ingest 已分享给 `xwy-notion` 的页面 |
| 落盘不入库 | 记忆 blob 在 `data/state_store.db/`，公开仓库不提交 |

## 证据与来源

| 来源 | 路径 |
|------|------|
| 根指南 | `AGENTMEMORY.md` |
| 启动脚本 | `scripts/start-agentmemory.ps1` |
| 用户 MCP | `%USERPROFILE%\.cursor\mcp.json` |
| 数据目录 | `%USERPROFILE%\.agentmemory\` |
| 上游 | https://github.com/rohitg00/agentmemory · https://agent-memory.dev |

## 相关页面

- [01 · 用法与命令](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
- [04 · Notion 同步](04-notion-sync.md)
- 长篇写作：[小说连续性 · 记忆政策](../novel-writing/01-memory-policy.md)
- 目录：`wiki/index.md`
