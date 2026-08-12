# Notion MCP · 01 授权与配置

## Definition

本页说明 Cursor IDE 侧 Notion MCP 的配置来源、OAuth 存放位置，以及重新授权与冒烟验证步骤。

## Actionable conclusions

| 步骤 | 动作 |
|------|------|
| 1（推荐） | 设用户环境变量 `NOTION_TOKEN`（PAT）并重启 Cursor |
| 2 | 确认 `~\.cursor\mcp.json` 含 `notion-token`；运行时 id 为 `user-notion-token` |
| 3 | 插件路径可选：对 `plugin-notion-workspace-notion` 调用 `mcp_auth` |
| 4 | 冒烟：优先 `user-notion-token` / `notion-search`；插件可用时也可用插件 |

| 配置面 | Notion 条目 | 说明 |
|--------|-------------|------|
| `~\.cursor\mcp.json` | `notion-token` + openclaw | **stdio** `npx -y @notionhq/notion-mcp-server`；env `${env:NOTION_TOKEN}` |
| 插件 `mcp.json` | 插件维护 | OAuth；`url`: `https://mcp.notion.com/mcp` |
| 用户环境变量 | `NOTION_TOKEN` | 本机为 `secret_` integration（bot：`xwy-notion`）；勿提交仓库 |
| `state.vscdb` | 系统写入 | `mcpOAuth.secret.*` / 迁移后 `secret://…cursor-mcp…` |
| `Local State` | 系统写入 | `os_crypt.encrypted_key`（解密用） |

### 写页面父锚点（integration）

| 页 | page_id | 说明 |
|----|---------|------|
| AiRec | `3a954d8e-86f6-81ac-808c-fa1bb6a8422e` | 已 Share 给 `xwy-notion` 后方可建子页 |

## Evidence / sources

| 声明 | 类型 | 来源 |
|------|------|------|
| 远端 MCP URL | verified | 插件 cache `mcp.json` |
| OAuth 存 Cursor storage | verified | `%APPDATA%\Cursor\User\globalStorage\state.vscdb` |
| 用户 mcp.json 为 stdio notion-token | verified | 本机 `~\.cursor\mcp.json`（2026-08-12） |
| Cloudflare 拦默认 Python UA | verified | Fate bridge 直连实测 |

## Related pages

- [[00-overview]]
- [[02-feishu-bridge]]
- [[04-token-fallback]]
- [[05-environment-and-ops]]
- 根文档：`NOTION-MCP.md`
