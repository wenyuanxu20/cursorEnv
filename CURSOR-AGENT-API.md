# Cursor Agent API 调用方式

> Wiki：[`wiki/cursor-agent-api/`](wiki/cursor-agent-api/)  
> 实现源（sibling，不在本仓）：`../ai/AstrBot/cursor-proxy/`、`../ai/cursor_api.py`  
> 官方：Cloud REST [cloud-agent/api](https://cursor.com/docs/cloud-agent/api/endpoints) · SDK [TypeScript](https://cursor.com/docs/sdk/typescript) / [Python](https://cursor.com/docs/sdk/python) · CLI [installation](https://cursor.com/docs/cli/installation)

cursorEnv **不实现** Cursor Agent 调用；本页把 `ai` 仓里 **AstrBot 已跑通** 的路径收成可查询知识。密钥只放环境变量，不进 Git。

## 三种入口（先选对）

| 路径 | 谁在跑 | 给谁用 | 本机/ECS 是否在用 |
|------|--------|--------|-------------------|
| **A. 本地 CLI + OpenAI 兼容 proxy** | `agent` CLI ← `streaming-proxy.mjs` | AstrBot / 任何 OpenAI `chat/completions` 客户端 | **是**（AstrBot 主路径） |
| **B. Cloud Agents REST** | `https://api.cursor.com/v1/agents` | 无本机 `agent`、要云端 VM / PR | **回退**（proxy 挂了才走） |
| **C. 官方 SDK** | `@cursor/sdk` / `cursor-sdk` | 新脚本、CI、自建服务 | AstrBot **未用**；IDE 外编程优先看这个 |

不要把下面三个可执行文件混用：

| 命令 | 是什么 |
|------|--------|
| `cursor` / `cursor.exe` | 编辑器 CLI（`cursor agent` **不是** Agent CLI） |
| `agent` / `agent.cmd` | **Cursor Agent CLI**（proxy spawn 的目标） |
| `openclaw` | OpenClaw 网关，不是 Cursor |

## 路径 A：本地 Agent CLI + streaming-proxy（AstrBot 生产）

IM / AstrBot 把 Cursor 当成 **OpenAI 兼容模型**：先打本机（或同机）proxy，再由 Node 进程 `spawn` `agent -p ...`。

```text
微信/飞书/QQ → AstrBot :6185
                 → POST http://127.0.0.1:18791/v1/chat/completions
                 → streaming-proxy.mjs
                 → agent -p --output-format stream-json --trust --approve-mcps
                 → stdin: 用户最后一条 user 消息
```

### 安装 Agent CLI

```powershell
# Windows
irm 'https://cursor.com/install?win32=true' | iex
agent --version
agent login
agent status   # 应 Logged in
```

```bash
# Linux（阿里云 AstrBot）
curl https://cursor.com/install -fsS | bash
# 二进制：~/.local/bin/agent
```

正确路径示例：Windows `%LOCALAPPDATA%\cursor-agent\agent.cmd`；Linux `~/.local/bin/agent`。`cursorPath` / `CURSOR_PATH` 必须指向它。

### Proxy 端口（两套，勿混）

| 场景 | 端口 | 环境 |
|------|------|------|
| **AstrBot standalone** | **18791** | `CURSOR_PROXY_STANDALONE=1` |
| OpenClaw cursor-brain | 18790 | `~/.openclaw/openclaw.json` |

监听 **仅 127.0.0.1**，不对公网开放。

### 启动（本机 Windows）

```powershell
cd C:\Users\xwy12\Desktop\my-project\ai\AstrBot\cursor-proxy
.\start-cursor-proxy.cmd
Invoke-RestMethod http://127.0.0.1:18791/v1/health
```

需要：Node ≥ 18、`ai/.env` 中的 `CURSOR_API_KEY`（chmod 等价：文件权限收紧，**不要提交**）。

### AstrBot Provider 字段

| 项 | 值 |
|----|-----|
| API Base | `http://127.0.0.1:18791/v1` |
| API Key | 占位即可（如 `cursor-local-proxy`）；真 Key 给 **agent** 进程 |
| Model | **裸 id**：`auto` 或 `composer-2.5`（去掉 `cursor-local/` 前缀） |
| Timeout | 300–360 秒 |

主模型失败时 AstrBot 可 fallback 到 SiliconFlow（见 `ai/AstrBot/wiki/aliyun/provider-routing.md`）。

### Proxy HTTP 面

| 方法 | 路径 | 作用 |
|------|------|------|
| `POST` | `/v1/chat/completions` | `stream: true/false`；从 `messages` 取最后一条 user |
| `GET` | `/v1/models` | `agent --list-models` 缓存 |
| `GET` | `/v1/health` | `{ status, cursor, port, ... }` |

会话：请求头 `X-Session-Id` / `X-OpenClaw-Session-Id` 或 body `session_id` → CLI `--resume`。空回复且用过 resume 时，proxy 会清 session 再打一轮。

实现：`ai/AstrBot/cursor-proxy/streaming-proxy.mjs`（源自 openclaw-cursor-brain）。Python 客户端：`cursor_client.py`（`mode=proxy` 优先，失败再 cloud）。

### spawn 参数（已验证）

```text
agent -p --output-format stream-json --stream-partial-output --trust --approve-mcps --force
      [--model <裸id>] [--resume <session>]
```

`-p`：非交互，prompt 走 **stdin**。新版 CLI 要求 `stream-json` 才允许 `--stream-partial-output`。

## 路径 B：Cloud Agents REST

不跑本机 `agent` 时，用 Dashboard 的 **Cursor API Key** 调云端 Agent。

| 项 | 值 |
|----|-----|
| Base | `https://api.cursor.com`（可用 `CURSOR_API_BASE_URL` 覆盖） |
| 鉴权 | **Basic** `base64("{CURSOR_API_KEY}:")`（注意冒号后为空；**不是** Bearer） |
| Key | [Integrations](https://cursor.com/dashboard/integrations) |

常用端点：

| 方法 | 路径 |
|------|------|
| `POST` | `/v1/agents` 创建（`prompt.text`，可选 `repos` / `model.id` / `autoCreatePR`） |
| `POST` | `/v1/agents/{agent_id}/runs` 追问（409 时稍等再试） |
| `GET` | `/v1/agents/{agent_id}/runs/{run_id}` 轮询 |
| `GET` | `/v1/agents/{agent_id}/runs/{run_id}/stream` SSE |
| `GET` | `/v1/models` |
| `GET` | `/v1/agents` 列表 |

终态：`FINISHED` / `ERROR` / `CANCELLED` / `EXPIRED`。实现：`ai/cursor_api.py`、`cursor_client.py` 的 `_chat_via_cloud`。

## 路径 C：官方 SDK（AstrBot 未走）

`Agent.prompt`（一次性）/ `Agent.create` + `send`（多轮流式）/ `Agent.resume`。须显式选 **local**（`cwd`）或 **cloud**（`repos`），否则默认 local。详情见 Cursor 内置 skill `sdk` 与官方文档。AstrBot IM 要的是 OpenAI 兼容 HTTP，所以用路径 A，而不是在 Python 里嵌 SDK。

## 环境变量（名称即可，勿把值写入仓库）

| 变量 | 用途 |
|------|------|
| `CURSOR_API_KEY` | Agent CLI 与 Cloud REST |
| `CURSOR_PATH` | `agent` 可执行文件 |
| `CURSOR_PROXY_STANDALONE` | `1` = 忽略 `~/.openclaw/openclaw.json` |
| `CURSOR_PROXY_PORT` | AstrBot 默认 `18791` |
| `CURSOR_WORKSPACE_DIR` | spawn 的 `cwd`（ECS 上 `/opt/AstrBot`） |
| `CURSOR_PROXY_URL` | Python 客户端，默认 `http://127.0.0.1:18791` |
| `CURSOR_MODE` | `proxy` / `cloud` / `auto` |

## 排障（已踩过）

| 现象 | 原因 | 处理 |
|------|------|------|
| `'p' is not in the list` | 指到了 `cursor.exe` | 改 `CURSOR_PATH` → `agent.cmd` / `agent` |
| `Authentication required. Run agent login` | 服务进程环境缺 `LOCALAPPDATA` 等 | 登录一次；Windows 服务补用户环境 |
| health 无 `cursor: true` | 找不到 CLI | 安装 `agent` 并设 `CURSOR_PATH` |
| 模型报错 `Cannot use this model` | 传了 `cursor-local/auto` | 剥前缀，用裸 `auto` |
| OpenClaw 连错网关 | WSL 与 Windows 双开 18789 | 只留一套；AstrBot **不依赖** OpenClaw 端口 |
| Cloud 401 | 用了 Bearer 或 Key 带空格 | 改 Basic `key:` |

## 查询顺序

1. `memory_recall`：`cursorEnv Cursor Agent API astrbot proxy`
2. `graphify query "Cursor Agent API"` / `graphify explain "streaming-proxy"`
3. 本文件与 `wiki/cursor-agent-api/`
4. sibling：`ai/AstrBot/cursor-proxy/README.md`、`ai/AstrBot/wiki/aliyun/provider-routing.md`

## 相关

- Wiki：[00 总览](wiki/cursor-agent-api/00-overview.md)
- OpenClaw 变体（端口 18790）：`ai/OpenClaw-Cursor-接入指南.md`（不在本仓）
- Headroom BYOK 是 **IDE 里改 Base URL**，与本页的 **程序化调用 Agent** 不是同一条链路
