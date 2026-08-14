# Cursor Agent API · 00 总览

## 定义

**Cursor Agent API** 在本知识库里指：在 Cursor IDE **之外** 用程序调用 Cursor Agent（本地 CLI 或云端 Cloud Agents）。cursorEnv 只存调用方式；可运行代码在 sibling 仓 `ai/`（AstrBot `cursor-proxy` + `cursor_api.py`）。

与 **Headroom BYOK** 不同：BYOK 改的是 IDE 聊天的 LLM Base URL；本主题是 bot / 脚本把 Cursor 当后端。

## 关键结论

| 结论 | 说明 |
|------|------|
| 本仓此前无专题 | 2026-08-14 从 `ai/AstrBot` 整理入库 |
| AstrBot 主路径 | 同机 `streaming-proxy` `:18791` → `agent -p`（OpenAI `chat/completions`） |
| AstrBot 回退 | Cloud REST `https://api.cursor.com`（Basic `api_key:`）或 SiliconFlow |
| 官方 SDK | `@cursor/sdk` / `cursor-sdk`；AstrBot IM **未用** |
| 三个 CLI | `cursor`（编辑器）≠ `agent`（Agent CLI）≠ `openclaw`（网关） |
| 两个 proxy 端口 | AstrBot **18791**；OpenClaw cursor-brain **18790** |
| 密钥 | `CURSOR_API_KEY` 只放 `.env`，本仓与公开 Git **不写值** |

### 选型

| 需求 | 用 |
|------|-----|
| 把 Cursor 接进 AstrBot / 任意 OpenAI 客户端 | 路径 A：本地 proxy |
| 无本机 `agent`、要云端仓库/PR | 路径 B：Cloud REST |
| 新写 TS/Python 自动化（非 OpenAI 兼容层） | 路径 C：官方 SDK |

## 证据与来源

| 来源 | 路径 | 性质 |
|------|------|------|
| 根指南 | `CURSOR-AGENT-API.md` | 本仓 |
| Proxy 实现 | `ai/AstrBot/cursor-proxy/streaming-proxy.mjs` | 本机已验证（AstrBot） |
| Python 双路径客户端 | `ai/AstrBot/cursor-proxy/cursor_client.py` | 本机已验证 |
| Cloud REST 客户端 | `ai/cursor_api.py` | 本机已验证 |
| ECS 路由 | `ai/AstrBot/wiki/aliyun/provider-routing.md` | 本机已验证 |
| OpenClaw 变体 | `ai/OpenClaw-Cursor-接入指南.md` | 本机已验证（2026-07-02） |
| 上游 Cloud | https://cursor.com/docs/cloud-agent/api/endpoints | 上游文档 |
| 上游 SDK | https://cursor.com/docs/sdk/typescript | 上游文档 |

## 相关页面

- [01 · 本地 CLI + OpenAI proxy](01-local-cli-proxy.md)
- [02 · Cloud Agents REST](02-cloud-rest.md)
- [03 · 官方 SDK 与陷阱](03-sdk-and-traps.md)
- Headroom BYOK：[../headroom/03-byok-cursor.md](../headroom/03-byok-cursor.md)
- 目录：`wiki/index.md`
