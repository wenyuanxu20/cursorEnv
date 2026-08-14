# 03 · Cursor BYOK 与 Headroom 代理

## 定义

Headroom **代理层**只能拦截经 Cursor **自带 API Key（BYOK）** 发出的 LLM 请求。Cursor 订阅模型（Auto / Composer）走 `api2.cursor.sh` / `api5.cursor.sh`，**不经过**本地 `127.0.0.1:8787`。

## 关键结论

### 本机已验证现状

| 设置项 | 典型值 | 含义 |
|--------|--------|------|
| `openAIBaseUrl` | `http://127.0.0.1:8787/p/cursorEnv/v1` | Base URL 已指向 Headroom ✅ |
| `useOpenAIKey` | `false` | 未启用 BYOK ❌ → LLM 不走代理 |
| `agentBackendPreference` | `cursor-agent` | 订阅路由 |
| `/stats` `api_requests` | `0` | 无 LLM 流量经代理 |

### 路径 A：OpenAI BYOK（推荐）

| 步骤 | 操作 |
|------|------|
| 1 | `.\scripts\headroom-start-proxy.ps1 -Memory` |
| 2 | `.\scripts\headroom-switch-cursor-project.ps1 <项目id>` |
| 3 | Cursor → Settings → Models → OpenAI |
| 4 | 开启 **Use OpenAI API Key**，填入 Key |
| 5 | **Override OpenAI Base URL** = `http://127.0.0.1:8787/p/<项目id>/v1` |
| 6 | 模型选 **OpenAI BYOK**（如 `gpt-4o`），**勿选** Auto / Composer |
| 7 | 新对话发测试消息 |
| 8 | `.\scripts\headroom-verify-cursor.ps1` → `api_requests > 0` |

### 路径 B：Anthropic BYOK

| 项 | 值 |
|----|-----|
| API Key | `sk-ant-...` |
| Override Base URL | `http://127.0.0.1:8787/p/<项目id>`（**无** `/v1`） |
| 模型 | Claude BYOK，非 Cursor 托管 Claude |

### 路径 C：继续 Cursor 订阅

- 代理层 **无法** 压缩 `api2/api5.cursor.sh` 流量
- 仍可享受 **RTK**（`.cursorrules` 内 shell 输出压缩）
- `headroom savings` / Dashboard **不显示** LLM 压缩数据

### 链式上游（例：z.ai GLM）

```powershell
$env:OPENAI_TARGET_API_URL = "https://api.z.ai/api/coding/paas/v4"
.\scripts\headroom-start-proxy.ps1 -Memory
```

Cursor Base URL 仍填 `http://127.0.0.1:8787/p/<项目id>/v1`，由 Headroom 转发。

### 生效判定（`/stats`）

- `api_requests > 0`
- `by_path` 含 `/v1/chat/completions` 或 `/v1/messages`
- `tokens.saved > 0`

### 验证脚本读取的 Cursor 状态

数据源：`%APPDATA%\Cursor\User\globalStorage\state.vscdb`  
键：`openAIBaseUrl`, `useOpenAIKey`, `anthropicBaseUrl`, `agentBackendPreference`

## 证据与来源

- `HEADROOM.md` §六点五、§六
- `scripts/headroom-verify-cursor.ps1`

## 相关页面

- [02 · 日常使用](02-daily-usage.md)
- [06 · 排障与验证](06-troubleshooting.md)
- [00 · 总览](00-overview.md)
- 程序化调用 Agent（非 IDE BYOK）：[../cursor-agent-api/00-overview.md](../cursor-agent-api/00-overview.md)
