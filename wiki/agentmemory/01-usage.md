# agentmemory · 01 用法与命令

## 定义

在 Cursor（及任意 MCP/HTTP 客户端）中，如何把决策写入 agentmemory、跨会话召回，以及 CLI / REST / Viewer 的日常操作。

## 关键结论

### A. Cursor 对话用法

**默认自动（无需口头提醒）：** 全局规则 `agentmemory-auto.mdc`（`alwaysApply`）要求 Agent 会话开场先 `memory_recall`，有可复用结论时 `memory_save`。详页：[03 · 自动调用规则](03-auto-rule.md)。

前提：本机 `agentmemory` 服务已起，且 MCP 已加载（重启 Cursor 后看 Tools）。

| 场景 | 默认行为 / 也可口头说 |
|------|------------------------|
| 新会话续上 | **自动** `memory_recall`（过薄再 `memory_smart_search`） |
| 记下架构决策 / 排障根因 / 偏好 | **自动** `memory_save`；也可说「把这次 API 选型记入 memory」 |
| 会话列表 | 「列出近期 memory sessions」→ `memory_sessions` |
| 健康检查 | 「跑一下 memory diagnose」→ `memory_diagnose` |
| 合并重复记忆 | 「consolidate 关于认证的记忆」→ `memory_consolidate` |

**标签建议：** `项目名` + `主题` + `agent 角色`（如 `cursorEnv`、`auth`、`deploy`），方便精确召回。

**工具集：** 本机 `AGENTMEMORY_TOOLS=core`（约 8 个）。需要全量约 50+ 工具时，改 `mcp.json` 为 `all` 或删除该 env 后重载 MCP。

### B. 日常运维命令

| 命令 | 作用 |
|------|------|
| `pwsh …\scripts\start-agentmemory.ps1` | 已运行则跳过，否则前台启动 |
| `agentmemory status` | 健康、记忆条数、Flags |
| `agentmemory doctor` | 配置诊断 |
| `agentmemory stop` / `stop --force` | 停止引擎 |
| `agentmemory demo --serve` | 种子数据 + 语义检索演示（结束后退出） |
| `agentmemory upgrade` | 升级 CLI 与引擎 |

### C. REST 直接调用

Base：`http://127.0.0.1:3111/agentmemory`

| 方法 | 路径 | 用途 |
|------|------|------|
| GET | `/livez` | 存活 |
| GET | `/health` | 详细健康 JSON |
| POST | `/remember` | 写入（body: `content`, `concepts[]`） |
| POST | `/smart-search` | 检索（body: `query`, `limit`） |

PowerShell 注意：`-d "{\"…\"}"` 易被转义破坏；用临时 JSON 文件 + `--data-binary "@file"`。

若设置了 `AGENTMEMORY_SECRET`，请求加头：`Authorization: Bearer <secret>`。

### D. Viewer

浏览器打开：http://127.0.0.1:3113 — 可视化记忆与会话（服务运行时）。

### E. 何时该记 / 不该记

**适合记：** 架构取舍、排障根因、环境路径、账号无关的偏好、跨会话会重复解释的事实。  
**不要记：** 密钥、PAT、密码、完整 `.env`、未脱敏的客户数据。

### F. 可选「更聪明」模式

在 `%USERPROFILE%\.agentmemory\.env`：

```env
# 任选一个 Provider
ANTHROPIC_API_KEY=…
# OPENAI_API_KEY=…
AGENTMEMORY_AUTO_COMPRESS=true
AGENTMEMORY_INJECT_CONTEXT=true
```

然后重启服务。Inject 会增加上下文消耗；Compress 会消耗 API token。

## 证据与来源

- 本机实测：`livez` / `remember`→201 / `smart-search`→200（2026-08-12）
- 根文档：`AGENTMEMORY.md`
- 上游：`INSTALL_FOR_AGENTS.md`

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
- [04 · Notion 同步](04-notion-sync.md)
