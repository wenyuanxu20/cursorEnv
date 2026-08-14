# Notion MCP · 00 总览

## Definition

**Notion MCP** 是 Cursor 通过官方 Notion Workspace 插件接入的 Model Context Protocol 服务，使 Agent 能搜索、读取与（按权限）写入 Notion 工作区。本主题记录本机连接方式、授权位置，以及与 Fate 飞书 bot 桥接的分工。

## Actionable conclusions

| 结论 | 说明 |
|------|------|
| IDE 主路径：插件 OAuth | server id：`plugin-notion-workspace-notion` |
| IDE 兜底：PAT MCP | 用户 `mcp.json` → `notion-token`（运行时 `user-notion-token`）+ env `NOTION_TOKEN` |
| `needsAuth` 时自动切换 | 插件 → `user-notion-token` → bridge `resolve_notion_access_token`（见 [[04-token-fallback]]） |
| CLI / 飞书不共享 IDE 会话 | Fate bridge：PAT → OAuth refresh → access |
| 知识入口 | 根文档 `NOTION-MCP.md` + Skill `notion-mcp` |
| Notion → 记忆 | Skill `notion-agentmemory-sync`：已分享页面增量写入 agentmemory（见 [[../agentmemory/04-notion-sync]]） |
| 环境快照 | [[05-environment-and-ops]]（路径 / 能力边界 / AiRec 锚点，2026-08-12） |
| PAT 传输 | **stdio** `@notionhq/notion-mcp-server`（非托管 URL + Bearer header） |

## Evidence / sources

| 来源 | 路径 |
|------|------|
| 调研笔记 | `raw/notion-mcp/research-notes.md` |
| 根指南 | `NOTION-MCP.md` |
| 环境快照 | `wiki/notion-mcp/05-environment-and-ops.md` |
| 插件 MCP 定义（本机） | `%USERPROFILE%\.cursor\plugins\cache\cursor-public\notion-workspace\cf1324609edba6d617164f1dec138aeb43f26735\mcp.json` |
| Fate 桥接 | `C:\Users\xwy12\Desktop\my-project\Fate\feishuBot\notion_bridge.py` |

## Related pages

- [[01-auth-and-config]]
- [[02-feishu-bridge]]
- [[03-bridge-create-page]]
- [[04-token-fallback]]
- [[05-environment-and-ops]]
- [agentmemory · Notion 同步](../agentmemory/04-notion-sync.md)
- 目录：`wiki/index.md`
