# Notion MCP · 04 Token 兜底（PAT + 自动切换）

## Definition

当插件 OAuth（`plugin-notion-workspace-notion` / `mcp_auth`）频繁失效或会话仅暴露 `needsAuth` 时，使用 **Notion Personal Access Token（PAT）** 作为 Bearer，通过用户级 MCP server `notion-token` 或 Fate `notion_bridge.resolve_notion_access_token()` 直连同一托管端点 `https://mcp.notion.com/mcp`，避免反复浏览器授权。

## Actionable conclusions

### Agent 决策顺序（强制）

| 步 | 条件 | 动作 |
|----|------|------|
| 1 | 插件业务工具可用 | `CallMcpTool` → `plugin-notion-workspace-notion` |
| 2 | 仅 `mcp_auth` / `needsAuth` | **不要**反复要求用户 OAuth；改查 `user-notion-token` |
| 3 | `user-notion-token` 工具可用 | 用其 `notion-search` / create 等 |
| 4 | 两路 MCP 都不可用 | Fate `resolve_notion_access_token` + `_mcp_call` |
| 5 | 无 `NOTION_TOKEN` 且 refresh 失败 | 再提示补 PAT 或一次性 `mcp_auth` |

### 本机配置（PAT 备用 MCP）

| 项 | 值 |
|----|-----|
| 用户 MCP | `%USERPROFILE%\.cursor\mcp.json` → key `notion-token` |
| 运行时 server id | `user-notion-token`（Cursor 给用户 MCP 加 `user-` 前缀） |
| 传输 | **stdio** `npx -y @notionhq/notion-mcp-server` + env `NOTION_TOKEN` |
| 环境变量 | Windows **用户**级 `NOTION_TOKEN`（`ntn_…` 或 legacy `secret_…`） |
| 为何不用托管 URL | 托管 `mcp.notion.com` **拒收** internal integration（`secret_` bot）；仅接受 OAuth / 专用 PAT |
| 辅助脚本 | `scripts/set-notion-token.ps1` |
| 内容可见性 | Integration 须在 Notion 里被 **Share** 到目标页面/数据库，否则 search 为空 |

设置 PAT（一次性）：

1. Notion → Settings → Connections / Developers → 创建 Personal Access Token（需 **Notion API** capability）
2. 运行（交互粘贴，不落盘）：

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\set-notion-token.ps1
```

3. **重启 Cursor**（子进程才能读到新用户环境变量）
4. Settings → MCP 确认 `user-notion-token` 可用（非红点 / 非仅 mcp_auth）

### Bridge resolve 优先级

| 优先级 | 来源 |
|--------|------|
| 1 | `NOTION_TOKEN` 或 `NOTION_MCP_ACCESS_TOKEN` |
| 2 | 解密 `mcp_tokens` + `mcp_client_information` → `POST https://mcp.notion.com/token` refresh |
| 3 | 解密后的明文 `access_token`（可能已过期） |

`search_and_fetch` 遇 401 会再 refresh 一次后重试。

## Evidence / sources

| 声明 | 类型 | 来源 |
|------|------|------|
| 托管 MCP 支持 PAT Bearer | upstream | Notion docs：Connect to Notion MCP FAQ |
| Cursor `headers` + `${env:VAR}` | upstream | Cursor MCP 文档 |
| 本机 `mcp.json` 含 stdio `notion-token` | verified | `%USERPROFILE%\.cursor\mcp.json`（2026-08-12） |
| `user-notion-token` ready + `API-*` | verified | 2026-08-12 Agent 会话 |
| `secret_` 托管 MCP 401 / REST 可用 | verified | 同日 bridge 探测 |
| `resolve_notion_access_token` | verified | `Fate/feishuBot/notion_bridge.py` |

## Related pages

- [[00-overview]]
- [[01-auth-and-config]]
- [[02-feishu-bridge]]
- [[03-bridge-create-page]]
- [[05-environment-and-ops]]
- 根文档：`NOTION-MCP.md`
