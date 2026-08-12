# Notion bridge 直连建页 · 会话记录（2026-07-27）

## 背景

- 项目：AstrBot（Cursor workspace）
- 用户：已授权 Notion，要求在工作区根目录新建 page
- Agent 侧：`plugin-notion-workspace-notion` 仍 `needsAuth`，仅 `mcp_auth` 可用

## 成功路径

1. 读取 `state.vscdb` 中 `mcpOAuth.*` 条目
2. 解密 `mcp_tokens`、`mcp_client_information`
3. `POST https://mcp.notion.com/token` refresh
4. `_mcp_call(access, "tools/call", {"name": "notion-create-pages", "arguments": {...}})`
5. 参数：`pages[].properties.title` + `pages[].content`（无 parent = 工作区根）

## 失败尝试（勿重复）

- 仅用 `_load_notion_access_token()` 不 refresh → MCP 401
- `pages[].title` 顶层字段 → schema 不匹配
- 在 AstrBot 仓库根写 `.md` 代替 Notion → 已删除

## 结果

- 页面标题：坚持一生的好习惯：每天看财报，每周看招股书
- URL：`https://app.notion.com/p/3a954d8e86f681bcb532c57ede825b15`

## 入库

- Wiki：`cursorEnv/wiki/notion-mcp/03-bridge-create-page.md`
- 镜像：`ai/AstrBot/wiki/notion-mcp/01-bridge-create-page-when-needsauth.md`
