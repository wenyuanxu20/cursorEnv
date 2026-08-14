# Cursor Agent API · 02 Cloud Agents REST

## 定义

Cursor 托管的 **Cloud Agents HTTP API**：在云端 VM 上跑 Agent，可选克隆 GitHub 仓库、自动开 PR。AstrBot 的 `CursorClient` 在本地 proxy 不可用时走这条路径。官方文档：[Cloud Agent API endpoints](https://cursor.com/docs/cloud-agent/api/endpoints)。

## 关键结论

| 项 | 值 |
|----|-----|
| Base URL | `https://api.cursor.com`（`CURSOR_API_BASE_URL`） |
| 鉴权 | **HTTP Basic** `base64("{API_KEY}:")` —— Key 后必须有冒号，密码为空 |
| 不是 | `Authorization: Bearer`（那是 proxy 可选鉴权，不是 Cloud） |
| Key 来源 | [cursor.com/dashboard/integrations](https://cursor.com/dashboard/integrations) |
| Agent id | 云端 id 常以 `bc-` 开头；**不是** run id |

### 生命周期

1. `POST /v1/agents`，body 含 `prompt.text`，可选 `name`、`model.id`、`repos[{url, startingRef}]`、`autoCreatePR`
2. 响应里取 `agent.id` 与 `run.id`（或 `latestRunId`）
3. 追问：`POST /v1/agents/{id}/runs`；**409** 表示上一 run 未结束，sleep 后重试
4. 等待：轮询 `GET /v1/agents/{id}/runs/{run_id}` 或 SSE `.../stream`
5. 终态集合：`FINISHED` / `ERROR` / `CANCELLED` / `EXPIRED`

SSE 过期（HTTP 410）时改为轮询终态（`ai/cursor_api.py` 的 `consume_stream`）。

### 其它端点

| 方法 | 路径 |
|------|------|
| `GET` | `/v1/models` |
| `GET` | `/v1/agents`（`limit` / `cursor`） |
| `GET` | `/v1/agents/{id}` |
| `GET` | `/v1/agents/{id}/runs` |
| `DELETE` | `/v1/agents/{id}` |
| `POST` | `/v1/agents/{id}/archive` |
| `POST` | `/v1/agents/{id}/runs/{run_id}/cancel` |

### AstrBot 封装差异

`cursor_client.py` 的 cloud 创建 body 较简：`prompt` + `name: AstrBot Cursor` + 可选 `model` / `repos`。成功回复末尾会附 `https://cursor.com/agents/{agent_id}`。会话用内存 dict：`chat_id → agent_id`。

独立 CLI 菜单：`python ai/cursor_api.py`（需 `.env` 里已有 Key）。

## 证据与来源

- `ai/cursor_api.py`（Basic 鉴权、端点、SSE）
- `ai/AstrBot/cursor-proxy/cursor_client.py`（`_auth_header`、`_cloud_create` / `_cloud_followup` / `_cloud_wait_run`）
- 上游：https://cursor.com/docs/cloud-agent/api/endpoints

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 本地 proxy](01-local-cli-proxy.md)
- [03 · SDK 与陷阱](03-sdk-and-traps.md)
