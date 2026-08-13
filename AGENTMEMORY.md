# agentmemory · 本机部署与使用指南

> 上游：[rohitg00/agentmemory](https://github.com/rohitg00/agentmemory) · 站点：[agent-memory.dev](https://agent-memory.dev/)  
> Wiki：`wiki/agentmemory/` · 启动脚本：`scripts/start-agentmemory.ps1`  
> 本机验证日期：2026-08-12

## 是什么

**agentmemory** 是面向 AI 编码 Agent 的**跨会话持久记忆**服务。本地后台进程捕获/索引工作记忆，通过 **REST**（默认 `:3111`）与 **MCP** 供 Cursor / Claude Code 等调用。默认 **零 LLM**（BM25 + 可选本地 embedding），不强制 API Key。

与 sticky notes 式记忆（`.cursorrules`、`MEMORY.md`）不同：它是可检索的记忆库，可在多 Agent / 多会话间共用同一台本机服务。

## 本机状态（已验证）

| 项 | 值 |
|----|-----|
| CLI | `@agentmemory/agentmemory@0.9.28`（全局 npm） |
| MCP shim | `@agentmemory/mcp@0.9.28` → 命令 `agentmemory-mcp` |
| 引擎 | `iii` **0.11.2** → `%USERPROFILE%\.local\bin\iii.exe` |
| REST | `http://127.0.0.1:3111/agentmemory/*` |
| Viewer | `http://127.0.0.1:3113` |
| Streams | `ws://127.0.0.1:3112` |
| Engine WS | `ws://127.0.0.1:49134` |
| 数据目录 | `%USERPROFILE%\.agentmemory\` |
| Cursor MCP | `%USERPROFILE%\.cursor\mcp.json` → `agentmemory`（`AGENTMEMORY_TOOLS=core`） |
| 模式 | zero-LLM / BM25-only（未配 Provider Key） |

## 快速开始

### 1. 确认服务

```powershell
curl.exe -fsS http://127.0.0.1:3111/agentmemory/livez
agentmemory status
```

若未运行：

```powershell
pwsh C:\Users\xwy12\Desktop\my-project\cursorEnv\scripts\start-agentmemory.ps1
```

### 2. Cursor 使用

1. 确认 `mcp.json` 含 `agentmemory` 块（见下）。
2. **重启 Cursor** 或重载 MCP。
3. **自动调用（默认）：** 全局规则 `%USERPROFILE%\.cursor\rules\agentmemory-auto.mdc`（`alwaysApply`）要求 Agent 会话开场 `memory_recall`，有可复用结论时 `memory_save`，无需口头提醒。Wiki：[03 · 自动调用规则](wiki/agentmemory/03-auto-rule.md)。
4. 仍可口头补充：`memory_save` 记下决策；`memory_smart_search` / `memory_recall` 找回。

当前 core 工具集（约 8 个）：`memory_save`、`memory_recall`、`memory_consolidate`、`memory_smart_search`、`memory_sessions`、`memory_diagnose`、lesson save、reflect。

### 3. REST 冒烟

PowerShell 下 JSON 建议写文件再 curl：

```powershell
[System.IO.File]::WriteAllText("$env:TEMP\am-remember.json", '{"content":"probe","concepts":["install-check"]}')
curl.exe -s -X POST http://127.0.0.1:3111/agentmemory/remember -H "Content-Type: application/json" --data-binary "@$env:TEMP\am-remember.json"
```

## Cursor MCP 配置（本机）

```json
"agentmemory": {
  "command": "agentmemory-mcp",
  "args": [],
  "env": {
    "AGENTMEMORY_URL": "http://127.0.0.1:3111",
    "AGENTMEMORY_TOOLS": "core"
  }
}
```

- `AGENTMEMORY_URL` 必须指向已启动的 REST 服务；否则 MCP 会落入本地 fallback，工具变少。
- `AGENTMEMORY_TOOLS=core`：Cursor 工具限额友好；需要全量时改为 `all` 或删掉该 env。

> Windows 上 `agentmemory connect cursor` **不支持**，须手改 `mcp.json`（已完成）。

## Windows 部署要点

1. Node ≥ 20；npm 建议 `--registry=https://registry.npmmirror.com`（直连 registry.npmjs.org 易 ECONNRESET）。
2. 引擎 **不会**自动解压 Windows zip：需手动下载  
   `iii-x86_64-pc-windows-msvc.zip`（tag `iii/v0.11.2`）→ 放到 `%USERPROFILE%\.local\bin\iii.exe`。
3. 备选：`AGENTMEMORY_USE_DOCKER=1` + `docker pull iiidev/iii:0.11.2`。
4. 用户 PATH 已加入 `.local\bin` 与 `.agentmemory\bin`。

详页：`wiki/agentmemory/02-local-deploy.md`。

## 可选增强（默认关闭）

在 `%USERPROFILE%\.agentmemory\.env` 写入（无 `export` 前缀），然后重启服务：

| 变量 | 作用 |
|------|------|
| `ANTHROPIC_API_KEY` / `OPENAI_API_KEY` / `GEMINI_API_KEY` 等 | 启用 LLM 摘要 |
| `AGENTMEMORY_AUTO_COMPRESS=true` | LLM 压缩观察（耗 token） |
| `AGENTMEMORY_INJECT_CONTEXT=true` | 会话自动注入历史记忆（耗上下文） |
| `AGENTMEMORY_SECRET` | REST 需 `Authorization: Bearer …` |

## 常用命令

| 命令 | 作用 |
|------|------|
| `agentmemory` / `scripts/start-agentmemory.ps1` | 启动 |
| `agentmemory status` | 健康与计数 |
| `agentmemory doctor` | 诊断 |
| `agentmemory stop` | 停引擎（`--force` 强制） |
| `agentmemory demo --serve` | 端到端演示后退出 |
| `agentmemory upgrade` | 升级 CLI + 引擎 |

## 排障

| 现象 | 处理 |
|------|------|
| `livez` 不通 | 跑启动脚本；检查 3111/3112/3113/49134 占用 |
| MCP 只有很少工具 | 先起服务，确认 `AGENTMEMORY_URL` |
| `Could not start iii-engine` | 确认 `iii.exe` 在 PATH / `.local\bin` |
| npm ECONNRESET | 用 npmmirror；或检查代理 |
| Viewer 打不开 | 服务起来后开 `http://127.0.0.1:3113` |

## 相关文档

- Wiki：[00 总览](wiki/agentmemory/00-overview.md) · [01 用法](wiki/agentmemory/01-usage.md) · [02 本机部署](wiki/agentmemory/02-local-deploy.md) · [03 自动调用](wiki/agentmemory/03-auto-rule.md)
- 上游：`INSTALL_FOR_AGENTS.md`、README
- 对比：`agency-agents/integrations/mcp-memory` 仅为 **Prompt 模板**，不是本服务
