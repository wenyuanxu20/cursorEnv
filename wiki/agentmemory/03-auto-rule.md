# agentmemory · 03 自动调用规则

## 定义

全局 Cursor 规则 `agentmemory-auto.mdc`：任意工作区会话开始时自动 `memory_recall`，有可复用结论时自动 `memory_save`，**不需要用户口头提醒**。

## 关键结论

| 项 | 值 |
|----|-----|
| 生效范围 | **所有 Cursor 项目**（全局 `alwaysApply: true`） |
| 全局规则 | `%USERPROFILE%\.cursor\rules\agentmemory-auto.mdc` |
| 中枢副本 | `cursorEnv/.cursor/rules/agentmemory-auto.mdc` |
| MCP 运行时 id | `user-agentmemory`（`mcp.json` 键名 `agentmemory`） |
| 开场动作 | `memory_recall`（`limit` 8, `format` compact）；召回过薄再 `memory_smart_search` |
| 收尾动作 | 架构取舍 / 排障根因 / 本机路径 / 用户偏好 → `memory_save` |
| `project` 字段 | 工作区文件夹名（slug），**禁止**写文件系统路径 |
| 失败策略 | MCP 缺失 / `error` / `needsAuth` 时静默跳过，不阻断任务 |
| 禁止写入 | 密钥、PAT、token、密码、完整 `.env` |
| 阿里云 AstrBot | **另一套** store。手机 IM 走 ECS `agentmemory.service` + Cursor CLI `agentmemory` MCP，不是本机 `:3111`。调用链：[Cloud Agent · 01 AstrBot](../cloud-agent/01-astrbot.md)；ECS 详页仍在 `ai/AstrBot/wiki/aliyun/agentmemory.md` |

与 graphify 全局规则同类：Agent 默认执行，用户不必说「查 memory」或「记一下」。

## 证据与来源

- 规则正文：`%USERPROFILE%\.cursor\rules\agentmemory-auto.mdc`
- 备份：`cursor-rules/latest/rules/agentmemory-auto.mdc`、`agentmemory-auto--global.mdc`
- 根指南：`AGENTMEMORY.md`
- 本机 MCP：`%USERPROFILE%\.cursor\mcp.json` → `agentmemory`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法与命令](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- [04 · Notion 同步](04-notion-sync.md)
- [Cloud Agent · 01 AstrBot](../cloud-agent/01-astrbot.md)
