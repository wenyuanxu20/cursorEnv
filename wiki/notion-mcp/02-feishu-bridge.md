# Notion MCP · 02 飞书桥接（Fate）

## Definition

**飞书 Notion 桥接**指 Fate 项目中 `feishuBot/notion_bridge.py`：在飞书消息走 `cursor-agent` / 本地 proxy 时，因 CLI **不共享** IDE MCP OAuth，由桥接层解密本机 Cursor 中的 Notion token，直连 `https://mcp.notion.com/mcp`，把检索结果注入 Cursor 提示。

## Actionable conclusions

| 场景 | 谁负责 Notion |
|------|----------------|
| Cursor IDE Agent | 插件 OAuth 或用户 MCP `user-notion-token`（PAT） |
| 飞书 bot → Cursor | Fate `resolve_notion_access_token` 预取 + 注入 prompt |
| 重新授权后 bot 仍旧 | 优先设 `NOTION_TOKEN`；或重启 `python -m feishuBot stream` |

| 约束 | 处理 |
|------|------|
| Cloudflare 403 | 请求须带浏览器 User-Agent |
| 密钥解密 | Windows DPAPI + AES-GCM（与 Chromium 一致） |
| 触发词 | 账号/密码/notion/交大等（见 Fate 实现） |

## Evidence / sources

| 来源 | 路径 |
|------|------|
| 桥接实现 | `C:\Users\xwy12\Desktop\my-project\Fate\feishuBot\notion_bridge.py` |
| Fate wiki | `Fate/wiki/13-feishu-notion-bridge.md`、`Fate/wiki/12-feishu-cursor-bot.md` |
| 原始笔记 | `raw/feishu-cursor-notion-integration.md`（Fate） |

## Related pages

- [[00-overview]]
- [[01-auth-and-config]]
- [[03-bridge-create-page]]（同一 bridge 模块；写页面 / refresh token）
- [[04-token-fallback]]（PAT + 自动切换）
- Fate：`wiki/13-feishu-notion-bridge.md`（Fate 仓）
