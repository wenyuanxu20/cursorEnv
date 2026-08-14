# Cursor Agent API · 01 本地 CLI + OpenAI proxy

## 定义

把 **Cursor Agent CLI**（`agent`）包成 OpenAI 兼容 HTTP：`POST /v1/chat/completions`。AstrBot 与 OpenClaw cursor-brain 共用同一份 `streaming-proxy.mjs` 思路；AstrBot 以 **standalone** 跑，不读 `~/.openclaw/openclaw.json`。

## 关键结论

### 调用链（AstrBot）

```text
IM → AstrBot → http://127.0.0.1:18791/v1/chat/completions
            → node streaming-proxy.mjs
            → spawn agent -p --output-format stream-json --stream-partial-output
                         --trust --approve-mcps --force
            → stdin = 最后一条 role=user 文本
```

ECS 上由 `cursor-proxy.service` 常驻；`WorkingDirectory=/opt/AstrBot/cursor-proxy`，`CURSOR_WORKSPACE_DIR=/opt/AstrBot`。

### 可执行文件

| 平台 | Agent CLI |
|------|-----------|
| Windows | `%LOCALAPPDATA%\cursor-agent\agent.cmd` |
| Linux | `~/.local/bin/agent` |

安装：Windows `irm 'https://cursor.com/install?win32=true' | iex`；Linux `curl https://cursor.com/install -fsS | bash`。然后 `agent login`。

**禁止**把 `CURSOR_PATH` 指到 `cursor.exe`。

### HTTP

| 项 | 值 |
|----|-----|
| 绑定 | `127.0.0.1` only |
| AstrBot 端口 | **18791**（`CURSOR_PROXY_STANDALONE=1`） |
| OpenClaw 端口 | 18790 |
| Completions | `POST /v1/chat/completions`（`stream` true/false） |
| Models | `GET /v1/models` |
| Health | `GET /v1/health` → `cursor: true` 表示找到了 CLI |
| 模型 id | 裸 `auto` / `composer-2.5`；客户端须剥掉 `cursor-local/` |
| 会话 | 头 `X-Session-Id` → `--resume`；空结果会清 session 重试 |

可选 `CURSOR_PROXY_API_KEY`：若设置，请求需 `Authorization: Bearer …`。AstrBot 占位 Key 只给 AstrBot 配置用，**真正鉴权 Cursor 的是** `CURSOR_API_KEY`（给 `agent` 进程）。

### Python 客户端优先级

`CursorClient.chat`（`ai/AstrBot/cursor-proxy/cursor_client.py`）：

1. `mode=proxy`：只打 proxy  
2. `mode=cloud`：只打 Cloud REST  
3. `mode=auto`：proxy → 模型不可用则改 `auto` 再试 → proxy 不可用再 cloud  

自测：`python cursor_client.py`（先 health，再发一句 prompt）。

### 启动

```powershell
cd C:\Users\xwy12\Desktop\my-project\ai\AstrBot\cursor-proxy
.\start-cursor-proxy.ps1
Invoke-RestMethod http://127.0.0.1:18791/v1/health
```

```bash
# ECS
systemctl enable --now cursor-proxy
curl -sS http://127.0.0.1:18791/v1/health
```

启动脚本会：设 `CURSOR_PROXY_STANDALONE=1`、`CURSOR_PROXY_PORT=18791`、从 `ai/.env` 或 `/opt/AstrBot/.env` 注入 `CURSOR_API_KEY`（已存在的环境变量不覆盖）。

## 证据与来源

- `ai/AstrBot/cursor-proxy/README.md`
- `ai/AstrBot/cursor-proxy/streaming-proxy.mjs`（spawn 参数、端点、standalone）
- `ai/AstrBot/cursor-proxy/start-cursor-proxy.sh` / `.ps1`
- `ai/cloudsurver/cursor-proxy.service`
- `ai/AstrBot/wiki/aliyun/provider-routing.md`（`api_base`、timeout 300、SiliconFlow fallback）

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · Cloud REST](02-cloud-rest.md)
- [03 · SDK 与陷阱](03-sdk-and-traps.md)
