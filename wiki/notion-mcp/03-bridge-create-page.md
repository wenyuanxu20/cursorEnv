# Notion MCP · 03 桥接直连创建页面（needsAuth 回退）

## Definition

当 Cursor Agent 会话中 Notion MCP 插件仍显示 **`needsAuth`**（即使用户刚完成 `mcp_auth`），可通过 Fate 的 `notion_bridge.py` 解密本机 Cursor OAuth、必要时 **refresh token**，再 **直连** `https://mcp.notion.com/mcp` 调用 `notion-create-pages` 写入页面。此路径不依赖插件 MCP 工具挂载，与飞书预检索共用同一套 token 解密与 HTTP 封装。

## Actionable conclusions

| 现象 | 首选 | 回退（本页） |
|------|------|----------------|
| `GetMcpTools` 仅 `mcp_auth` / `needsAuth` | 改用 `user-notion-token`（`API-post-page` 等） | bridge REST / OAuth refresh |
| `_load_notion_access_token()` 有 token 但托管 MCP 401 | — | `secret_` 改 `_notion_rest`；OAuth 则 refresh |
| 插件 `notion-create-pages` 不可用 | `user-notion-token` | `_mcp_call`（仅 OAuth access 有效时） |

### 决策顺序

1. 优先 `user-notion-token` → `API-post-page` / `API-update-page-markdown`（父页须已 Share 给 integration）。
2. 插件可用时再用 `mcp_auth` / `notion-create-pages`。
3. 两路 MCP 都不可用 → bridge：`resolve_notion_access_token`；`secret_` 走 `_notion_rest`，OAuth 再 `_mcp_call`。
4. OAuth 路径：解密 `mcp_tokens` + `mcp_client_information` → `POST https://mcp.notion.com/token` refresh。
5. 临时脚本放 `data/temp/`，完成后删除；**不要**在应用仓库根目录落笔记文件。
6. Internal integration **不能** `parent.workspace`；挂到已分享父页（如 AiRec）。

### OAuth 存储（2026-07 本机 verified）

| 键后缀（base64 解码后） | 内容 |
|-------------------------|------|
| `...:mcp_tokens` | `access_token`、`refresh_token` |
| `...:mcp_client_information` | `client_id`（refresh 必填） |
| `...:oauth_updated_at_ms` | 最近授权时间戳 |

表：`%APPDATA%\Cursor\User\globalStorage\state.vscdb`，前缀 `mcpOAuth.secret.*` / `mcpOAuth.*`。

### Token 刷新

```http
POST https://mcp.notion.com/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&refresh_token=<refresh>&client_id=<client_id>
```

Header 需浏览器式 `User-Agent`（与 `_mcp_call` 一致）。

### 工作区根目录建页（verified 参数）

`notion-create-pages` **不要**用顶层 `title` 字段；用 `properties.title`：

```json
{
  "pages": [{
    "properties": {"title": "页面标题"},
    "content": "Markdown 正文（标题已在 properties，正文无需重复 # 标题）"
  }]
}
```

- 工作区根：不传 `parent`（或勿设 `parent_id`）。
- 子页面：按 `GetMcpTools` / `tools/list` 返回的 `inputSchema` 传 `parent`。

### 最小 Python 调用链

```python
import sys
from pathlib import Path

sys.path.insert(0, r"C:\Users\xwy12\Desktop\my-project\Fate")
from feishuBot.notion_bridge import _mcp_call, _tool_result_text

# access = refresh 后的 token
args = {
    "pages": [{
        "properties": {"title": "示例标题"},
        "content": "## 小节\n\n正文。",
    }]
}
rpc = _mcp_call(access, "tools/call", {
    "name": "notion-create-pages",
    "arguments": args,
})
print(_tool_result_text(rpc))
```

Refresh 与解密逻辑见会话脚本模式：`decrypt_entry(mcp_tokens)` + `decrypt_entry(mcp_client_information)`（2026-07-27 AstrBot 会话）。

### 与 resolve / load 的差异

| 方法 | 行为 |
|------|------|
| `resolve_notion_access_token()` | PAT env → refresh → access（**推荐**） |
| `refresh_notion_access_token()` | 仅 OAuth refresh |
| `_load_notion_access_token()` | env 或密文 access；**不**强制 refresh |
| 本页写页流程 | 用 resolve；401 时 `search_and_fetch` 会再 refresh |

`notion_bridge.search_and_fetch` 仅 search/fetch；**不含** create。写页面需自行 `_mcp_call` 或临时脚本。详见 [[04-token-fallback]]。

## Evidence / sources

| 声明 | 类型 | 来源 |
|------|------|------|
| needsAuth 下 refresh + create 成功 | verified | 2026-07-27 AstrBot Agent 会话（工作区根页） |
| `properties.title`  schema | verified | 同会话 `tools/list` → `notion-create-pages` inputSchema |
| 顶层 `title` 无效 | verified | 同会话多次失败尝试 |
| Refresh 端点 | verified | `POST https://mcp.notion.com/token` + `client_id` |
| 桥接 HTTP/UA | verified | `Fate/feishuBot/notion_bridge.py` `_mcp_call` |

| 路径 | 用途 |
|------|------|
| `Fate/feishuBot/notion_bridge.py` | `_load_notion_access_token`、`_mcp_call`、`_decrypt_secret_blob` |
| `cursorEnv/NOTION-MCP.md` | IDE 授权总览 |
| `raw/notion-mcp/bridge-create-page-2026-07-27.md` | 会话原始记录 |

## Related pages

- [[00-overview]]
- [[01-auth-and-config]]
- [[02-feishu-bridge]]
- Fate：`wiki/13-feishu-notion-bridge.md`
