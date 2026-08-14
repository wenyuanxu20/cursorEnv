# Cursor Agent API · 03 官方 SDK 与陷阱

## 定义

官方 **Cursor SDK**（公开 beta）用 `Agent` → `Run` 模型在本地或云端跑 Agent，不必自己 spawn CLI，也不必手写 `/v1/agents`。TypeScript：`@cursor/sdk`；Python：`cursor-sdk`。AstrBot 的 IM 路径 **没有** 用 SDK，因为它需要 OpenAI 兼容的 `chat/completions`。

细节以 Cursor 内置 skill `sdk` 与 [TS 文档](https://cursor.com/docs/sdk/typescript) / [Python 文档](https://cursor.com/docs/sdk/python) 为准。

## 关键结论

### 三种调用形

| 形 | 何时 |
|----|------|
| `Agent.prompt(...)` | 一次性脚本 / CI，自动 dispose |
| `Agent.create` + `send` | 多轮、流式、可 cancel |
| `Agent.resume(id)` | 跨进程续跑；`bc-` 前缀走 cloud |

必须显式传 `local.cwd` 或 `cloud.repos`。省略时 SDK **默默走 local**。

### 与路径 A/B 的关系

| 能力 | A proxy+CLI | B Cloud REST | C SDK |
|------|-------------|--------------|-------|
| OpenAI `chat/completions` | 有 | 无 | 无 |
| 本机仓库 `cwd` | 有（spawn cwd） | 无（克隆 repos） | local 有 |
| 云端 VM / PR | 无 | 有 | cloud 有 |
| MCP | CLI `--approve-mcps` + 机器上的 mcp.json | 云端配置 | `Agent.create` 内联 servers（resume 须再传） |

新写服务：要接 bot 框架 → **A**；要云端改 GitHub → **B 或 C-cloud**；要在 TS/Python 里编排且不在乎 OpenAI 形状 → **C**。

### 已验证陷阱（A/B + CLI）

| 现象 | 处理 |
|------|------|
| 误用 `cursor agent` | 改装独立 `agent` CLI |
| 模型 id 带 `cursor-local/` | 客户端剥前缀（`CursorClient._proxy_model_id`） |
| Windows spawn `.cmd` EINVAL | proxy 对 `.cmd`/`.bat` 使用 `shell: true` |
| Gateway/服务环境无 `LOCALAPPDATA` | `agent login` 凭据读不到 |
| 连续超时 | proxy 记失败次数，超阈值 `process.exit(2)` 等 systemd 拉起 |
| Cloud 401 | 改用 Basic `key:`，不要 Bearer |
| 双开 OpenClaw 18789 | 与 AstrBot 无关；OpenClaw 场景只留 Windows 或 WSL 一套 |
| `CURSOR_API_KEY` 进 Git | 禁止；`.env` chmod 600 |

SDK 侧另见 skill：`wait()` 必调用、区分 `CursorAgentError` vs `result.status == "error"`、用 `await using` / `with` dispose。

## 证据与来源

- 上游 SDK 文档与 Cursor skill `sdk`（推断/官方，非 AstrBot 运行时）
- 陷阱中的 A/B 项：`streaming-proxy.mjs`、`cursor_client.py`、`ai/OpenClaw-Cursor-接入指南.md`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 本地 proxy](01-local-cli-proxy.md)
- [02 · Cloud REST](02-cloud-rest.md)
