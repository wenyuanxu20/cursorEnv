# AstrBot × Cursor Agent API · 调研笔记（2026-08-14）

## 背景

- 用户要求：查看 `my-project/ai` 中 AstrBot 调用 Cursor Agent API 的方式；若 cursorEnv 未记录则写入 wiki/文档并 push。
- 本机路径（Headroom 映射）：`C:\Users\xwy12\Desktop\my-project\ai`（`headroom-projects.json` id=`ai`）
- 预期详页（cursorEnv 已引用、本仓未复制）：`ai/AstrBot/wiki/aliyun/agentmemory.md`

## 源码可达性（本次 Cloud Agent 会话）

| 检查 | 结果 |
|------|------|
| 本环境 checkout | 仅 `github.com/wenyuanxu20/cursorEnv` |
| `gh repo view wenyuanxu20/ai` | 仓库不存在（公开/当前 token 可见范围内） |
| `wenyuanxu20/AstrBot` / `wenyuanxu20/Fate` | 同：不可见 |
| Notion MCP | `needsAuth`，未用于检索 |
| agentmemory MCP | 本环境无 `user-agentmemory` |
| 结论 | **未能打开 `ai/AstrBot` 插件源码**；下列「调用方式」来自 cursorEnv 已入库事实 + Cursor 官方 API 面。插件文件名 / 具体 `subprocess` 或 `cursor_sdk` 调用点待本机 ingest。 |

## cursorEnv 已入库事实（verified）

1. 阿里云 AstrBot 与 Windows 本机 **不是同一套 agentmemory**。
   - 证据：`wiki/agentmemory/03-auto-rule.md`、`wiki/log.md`（2026-08-13）
   - 手机 IM → ECS `agentmemory.service` + **Cursor CLI** 的 `agentmemory` MCP（无 `user-` 前缀）
   - 本机仍是 `:3111` + `user-agentmemory`
2. ECS 约束：glibc 2.32 → musl `iii`；ECS 上 GitHub 不通。
3. 另一条 **本机** 路径：`Fate/feishuBot` 走 `cursor-agent` CLI（飞书），与 AstrBot/ECS **不是同一条链路**。证据：`wiki/notion-mcp/02-feishu-bridge.md`。
4. cursorEnv 此前 **没有** 独立页面说明 AstrBot 如何调用 Cursor Agent API（仅有 CLI + MCP 一句）。

## Cursor 官方「Agent API」四面（上游文档，2026-08-14）

AstrBot 作为 Python 异步机器人，可能走其中一面。**cursorEnv 已证实的是 CLI + MCP**，未证实 REST / SDK。

| 面 | 入口 | 认证 | 适合 AstrBot 的形态 |
|----|------|------|---------------------|
| A. Cursor CLI headless | `agent` / `cursor-agent` `-p` `--force` `--trust` | `CURSOR_API_KEY` 或 `--api-key` | 子进程；输出 `--output-format text\|json\|stream-json` |
| B. CLI Cloud 模式 | 同上加 `-c` / `--cloud` | 同上 | 把任务丢到 Cloud Agent VM，而不是 ECS 本地工作区 |
| C. ACP | `agent acp`（stdio JSON-RPC） | 同上 | 长驻进程，自定义客户端 |
| D. Python SDK | `pip install cursor-sdk` → `AsyncAgent` / `AsyncClient` | `CURSOR_API_KEY` | AstrBot 插件原生 async 最贴 |
| E. Cloud Agents REST | `https://api.cursor.com/v0/agents`（legacy）或 `/v1/agents` | Basic `-u KEY:` 或 Bearer | 不经 CLI；适合无仓库机编排多个 Cloud Agent |

官方：

- CLI headless：https://cursor.com/docs/cli/headless
- CLI 参数：https://cursor.com/docs/cli/reference/parameters
- Python SDK：https://cursor.com/docs/sdk/python
- Cloud Agents REST：https://cursor.com/docs/cloud-agent/api/endpoints
- 密钥：https://cursor.com/dashboard/api

## 本用户已证实链路（推断到 CLI，未打开插件）

```
手机 IM（QQ/飞书等）
  → 阿里云 ECS 上的 AstrBot
    → Cursor CLI（agent / cursor-agent）
      → Cursor 后端 Agent API（CLI 用 CURSOR_API_KEY 代发）
      → MCP：agentmemory（ECS 独立 store，systemd `agentmemory.service`）
    → 回复写回 IM
```

**不是** 本机 Headroom `:8787`，也 **不是** 本机 agentmemory `:3111`。

与 Fate 飞书 bot 的差异：Fate 在 **Windows 本机** 调 `cursor-agent`，再经 `notion_bridge.py` 补 Notion；AstrBot 生产路径在 **ECS**。

## 下次本机 ingest 清单（补插件实锤）

在 `C:\Users\xwy12\Desktop\my-project\ai\AstrBot` 内搜索：

```text
CURSOR_API_KEY
cursor-agent
cursor_sdk
api.cursor.com
AsyncAgent
agent acp
--print / -p --force --trust
```

典型位置：`data/plugins/**`、自写 `astrbot_plugin_*`、`wiki/aliyun/`。

把命中的文件路径、函数名、是 CLI 子进程还是 `cursor_sdk` 写回本页与 `wiki/cloud-agent/01-astrbot.md`。
