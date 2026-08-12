# Notion MCP · 调研与本机事实（2026-07-26）

## 结论（verified）

- cursorEnv 仓库内原先 **无** 独立 Notion MCP wiki / skill / 根文档。
- Cursor IDE 侧 Notion 能力来自官方插件 `cursor-public/notion-workspace`，MCP server id：`plugin-notion-workspace-notion`。
- 用户级 `~/.cursor/mcp.json` 当前主要登记 `openclaw-gateway`，**不**直接声明 Notion；Notion 由插件注入。
- 插件本地 mcp 定义示例：`%USERPROFILE%\.cursor\plugins\cache\cursor-public\notion-workspace\<hash>\mcp.json` → HTTP `https://mcp.notion.com/mcp`。
- 重新授权：对 server 调用 `mcp_auth`（空参数）；成功后 `notion-search` 等工具可用。
- OAuth 密文落在 `%APPDATA%\Cursor\User\globalStorage\state.vscdb`（`mcpOAuth.secret.*`），密钥材料在 `%APPDATA%\Cursor\Local State` → `os_crypt.encrypted_key`。
- CLI `cursor-agent` / Fate 飞书 bot **不共享** IDE MCP 会话；Fate 用 `feishuBot/notion_bridge.py` 解密同一 OAuth 后直连 MCP（需浏览器 UA，否则 Cloudflare 403）。
- **needsAuth 写页回退（2026-07-27）**：插件会话仍 `needsAuth` 时，refresh `mcp_tokens` → `_mcp_call(..., "notion-create-pages")`；参数 `pages[].properties.title` + `content`。详见 `wiki/notion-mcp/03-bridge-create-page.md`。
- **Token 兜底（2026-08-12）**：用户 `mcp.json` → `notion-token` + `NOTION_TOKEN` PAT；Fate `resolve_notion_access_token`（PAT → refresh → access）。详见 `wiki/notion-mcp/04-token-fallback.md`。

## 相关路径

| 路径 | 用途 |
|------|------|
| Fate `wiki/12-feishu-cursor-bot.md` / `13-feishu-notion-bridge.md` | 飞书 bot 侧桥接 |
| Fate `feishuBot/notion_bridge.py` | 预检索实现 |
| cursorEnv 本主题 | IDE 连接 / 重授权 / Skill |
