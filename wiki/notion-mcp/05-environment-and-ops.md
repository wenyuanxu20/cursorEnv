# Notion MCP · 05 本机环境与运维快照（cursorEnv）

## Definition

本页是 **cursorEnv 项目**在本机（Windows）上的 Notion 连接方式、凭据层级、MCP server 分工与实操边界的 **verified 快照**。与 [[00-overview]] 的概念总览互补：本页偏「现在机器上到底怎么连、什么能写、什么会失败」。

快照日期：**2026-08-12**。

## Actionable conclusions

### 三条连接通道（按推荐顺序）

| 优先级 | 通道 | 运行时 server id | 传输 | Token 形态 | 本机状态（2026-08-12） |
|--------|------|------------------|------|------------|------------------------|
| 1（稳） | 用户 MCP `notion-token` | `user-notion-token` | stdio：`npx -y @notionhq/notion-mcp-server` | 用户环境变量 `NOTION_TOKEN`（本机为 `secret_` internal integration） | **ready**，暴露 `API-*` REST 工具集 |
| 2（可选） | 插件 Notion Workspace | `plugin-notion-workspace-notion` | HTTP：`https://mcp.notion.com/mcp` | OAuth（`mcp_auth` → browser） | **needsAuth**；`state.vscdb` 常无可用 `mcp_tokens` |
| 3（CLI/飞书/脚本） | Fate `notion_bridge.py` | （无 MCP server） | 直连 MCP 或 **REST `api.notion.com`** | `resolve_notion_access_token()`：env → OAuth refresh → cached access | PAT/`secret_` 时走 REST；托管 MCP 对 `secret_` 返回 401 |

### Agent 决策顺序（强制）

1. `GetMcpTools(plugin-notion-workspace-notion)` → 若有业务工具则用插件。
2. 若仅 `mcp_auth` / `needsAuth` → **不要**循环 OAuth；查 `user-notion-token`。
3. `user-notion-token` ready → 用 `API-post-search` / `API-post-page` / `API-update-page-markdown` 等。
4. 两路 MCP 都不可用 → Fate `resolve_notion_access_token` + `_notion_rest` / `_mcp_call`。
5. 仍失败 → `scripts/set-notion-token.ps1` 或一次 `mcp_auth`。

### 关键能力边界（本机实测）

| 操作 | `user-notion-token` / REST + `secret_` | 插件 OAuth 托管 MCP | 说明 |
|------|----------------------------------------|---------------------|------|
| 搜索已分享页面 | ✅（分享后） | ✅（OAuth 有效时） | 未 Share 时 search=0 / 404 |
| 在已分享父页下建子页 | ✅ | ✅ | 2026-08-12 在 AiRec 下建页成功 |
| 工作区根目录建私有页 | ❌ | ✅（用户 OAuth） | Internal integration 报 validation_error |
| 托管 `mcp.notion.com` + `secret_` Bearer | ❌ 401 `invalid_token` | N/A | 故 PAT 路径用 **stdio** 官方 server，不是托管 URL + header |
| Cloudflare 拦 Python UA | — | — | bridge 必须浏览器 UA |

### Integration / 页面锚点

| 项 | 值 |
|----|-----|
| Integration 显示名 | `xwy-notion` |
| Token 前缀 | `secret_`（len=50，用户级环境变量） |
| Bot `/v1/users/me` | `type=bot`，`owner.workspace=true` |
| 常用父页 AiRec | `https://www.notion.so/AiRec-3a954d8e86f681ac808cfa1bb6a8422e` |
| AiRec page_id | `3a954d8e-86f6-81ac-808c-fa1bb6a8422e` |
| 示例子页（仓库盘点） | `https://app.notion.com/p/my-project-GitHub-2026-08-12-3ba54d8e86f68146b4f0d24690bdc228` |

**Share 规则：** 目标页 → Share / Connections → 邀请 **`xwy-notion`**。未分享则 GET page 404：`object_not_found` + `shared with your integration "xwy-notion"`。

---

## 本机路径与配置清单

### 仓库内（cursorEnv）

| 路径 | 用途 |
|------|------|
| `NOTION-MCP.md` | 根指南（连接 / 排障 / Skill 安装） |
| `wiki/notion-mcp/00`–`05` | LLM wiki 主题页 |
| `skills/notion-mcp/SKILL.md` | Agent Skill 源（同步到 `~\.cursor\skills` 与 `~\.agents\skills`） |
| `scripts/set-notion-token.ps1` | 设置用户级 `NOTION_TOKEN`（不落盘、不打印全文） |
| `raw/notion-mcp/` | 调研与会话原始记录 |
| `data/temp/` | 一次性 bridge/建页脚本；用完删除 |
| `AGENTS.md` | 查询优先级含 Notion MCP 术语 |

### 用户级 Cursor

| 路径 | 用途 |
|------|------|
| `%USERPROFILE%\.cursor\mcp.json` | 用户 MCP：`openclaw-gateway` + **`notion-token`** |
| `%USERPROFILE%\.cursor\plugins\cache\cursor-public\notion-workspace\cf1324609edba6d617164f1dec138aeb43f26735\mcp.json` | 插件 HTTP MCP 定义（OAuth） |
| `%USERPROFILE%\.cursor\skills\notion-mcp\` | Skill 安装副本 |
| `%USERPROFILE%\.agents\skills\notion-mcp\` | Skill 安装副本 |

### OAuth / 密钥材料（勿提交、勿在聊天贴全文）

| 路径 / 键 | 用途 |
|-----------|------|
| `%APPDATA%\Cursor\User\globalStorage\state.vscdb` | `mcpOAuth.secret.*` / 迁移后 `secret://{extensionId:anysphere.cursor-mcp,...}` |
| `%APPDATA%\Cursor\Local State` | `os_crypt.encrypted_key`（DPAPI → AES-GCM） |
| 用户环境变量 `NOTION_TOKEN` | Internal integration / PAT |
| 可选 `NOTION_MCP_ACCESS_TOKEN` | 手工 OAuth access（bridge 可读） |

### 用户 `mcp.json` 本机实际片段（stdio，非托管 URL）

```json
"notion-token": {
  "command": "npx",
  "args": ["-y", "@notionhq/notion-mcp-server"],
  "env": {
    "NOTION_TOKEN": "${env:NOTION_TOKEN}"
  }
}
```

运行时 id：`user-notion-token`（Cursor 给用户 MCP key 加 `user-` 前缀）。

### 插件 MCP 定义（HTTP OAuth）

```json
"notion": {
  "url": "https://mcp.notion.com/mcp"
}
```

运行时 id：`plugin-notion-workspace-notion`。

---

## `user-notion-token` 常用工具（stdio REST 包装）

| 工具 | 用途 |
|------|------|
| `API-get-self` | 校验 bot / integration |
| `API-post-search` | 按标题搜索（仅已分享范围） |
| `API-retrieve-a-page` / `API-retrieve-page-markdown` | 读页面 |
| `API-post-page` | 建子页（需 `parent.page_id` 或 database） |
| `API-patch-block-children` | 追加 blocks |
| `API-update-page-markdown` | `replace_content` / `update_content` 写 Markdown |
| `API-patch-page` | 改属性 |

插件侧（OAuth 可用时）常见：`notion-search`、`notion-fetch`、`notion-create-pages` 等（schema 以当次 `GetMcpTools` 为准）。

---

## Fate bridge 行为摘要

实现：`C:\Users\xwy12\Desktop\my-project\Fate\feishuBot\notion_bridge.py`

| 函数 | 行为 |
|------|------|
| `resolve_notion_access_token` | env PAT →（可选）OAuth refresh → cached access |
| `refresh_notion_access_token` | `POST https://mcp.notion.com/token` + client_id |
| `_mcp_call` | 托管 MCP JSON-RPC；浏览器 UA |
| `_notion_rest` | `https://api.notion.com` + `Notion-Version: 2022-06-28` |
| `search_and_fetch` | 先 MCP；401 则 refresh；再失败则 REST |

飞书路径：`python -m feishuBot stream`（Fate 根目录）。CLI **不共享** IDE MCP 会话。

---

## 排障速查

| 现象 | 处理 |
|------|------|
| 插件 `needsAuth` / OAuth 超时 | 改用 `user-notion-token`；勿循环 `mcp_auth` |
| `user-notion-token` 未出现 / 红点 | 确认用户级 `NOTION_TOKEN` → **重启 Cursor** |
| search 空 / page 404 | 页面 Share 给 `xwy-notion` |
| 想建在「工作区根」 | Internal integration 不行 → 用已分享父页（如 AiRec），或完成用户 OAuth 插件 |
| 托管 MCP 401 + `secret_` | 预期；改 stdio server 或 REST |
| Cloudflare 403 | bridge 加浏览器 User-Agent |
| 飞书仍读不到 | 给 bot 进程设 `NOTION_TOKEN` 并重启 stream |

---

## 设置 / 轮换 Token（不落库）

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\set-notion-token.ps1
# 然后完全退出并重启 Cursor
```

Skill 同步：

```powershell
$src = "C:\Users\xwy12\Desktop\my-project\cursorEnv\skills\notion-mcp"
foreach ($d in @(
  "$env:USERPROFILE\.cursor\skills\notion-mcp",
  "$env:USERPROFILE\.agents\skills\notion-mcp"
)) {
  New-Item -ItemType Directory -Force -Path $d | Out-Null
  Copy-Item -Recurse -Force "$src\*" $d
}
```

---

## Evidence / sources

| 声明 | 类型 | 来源 |
|------|------|------|
| `user-notion-token` ready + `API-*` | verified | 2026-08-12 Cursor Agent `GetMcpTools` |
| 插件 needsAuth、无可用 mcp_tokens | verified | 同日会话；`state.vscdb` 检查 |
| `secret_` → 托管 MCP 401 | verified | bridge `_mcp_call` |
| `secret_` → REST `/v1/users/me` = xwy-notion | verified | `_notion_rest` |
| 工作区根建页 validation_error | verified | `POST /v1/pages` parent.workspace |
| AiRec 分享后建子页成功 | verified | 仓库盘点页 URL 见上表 |
| mcp.json 为 stdio 非托管 header | verified | `%USERPROFILE%\.cursor\mcp.json` |
| 插件 cache hash | verified | `…\notion-workspace\cf1324609edba6d617164f1dec138aeb43f26735\` |

## Related pages

- [[00-overview]] · [[01-auth-and-config]] · [[02-feishu-bridge]] · [[03-bridge-create-page]] · [[04-token-fallback]]
- 根文档：`NOTION-MCP.md`
- Notion 镜像：
  - Hub：https://app.notion.com/p/cursorEnv-Notion-Wiki-3ba54d8e86f68153a06beb74df7b24bc
  - 详页：https://app.notion.com/p/05-3ba54d8e86f6818492d8df86ba69c240
