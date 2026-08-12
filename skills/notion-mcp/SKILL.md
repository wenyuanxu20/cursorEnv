---
name: notion-mcp
description: >-
  Connect, re-authorize, and troubleshoot Notion MCP in Cursor
  (plugin-notion-workspace-notion + notion-token PAT fallback). Use when the
  user mentions Notion MCP, needsAuth, mcp_auth, Notion OAuth, NOTION_TOKEN,
  or Feishu bot Notion bridge.
---

# Notion MCP

## When to use

- User says Notion MCP is disconnected / `needsAuth` / only `mcp_auth` available
- User asks to authorize or re-auth Notion in Cursor
- User asks how IDE Notion differs from Fate Feishu `notion_bridge`
- User asks where OAuth / mcp.json / plugin / PAT config lives on this machine
- User needs to **create Notion pages** while MCP still shows `needsAuth` after auth

## Canonical docs (this machine)

| Doc | Path |
|-----|------|
| Hub | `C:\Users\xwy12\Desktop\my-project\cursorEnv\NOTION-MCP.md` |
| Wiki | `C:\Users\xwy12\Desktop\my-project\cursorEnv\wiki\notion-mcp\` |
| Token fallback | `…\wiki\notion-mcp\04-token-fallback.md` |
| Env snapshot | `…\wiki\notion-mcp\05-environment-and-ops.md` |
| Fate bridge | `C:\Users\xwy12\Desktop\my-project\Fate\feishuBot\notion_bridge.py` |
| Fate wiki | `C:\Users\xwy12\Desktop\my-project\Fate\wiki\13-feishu-notion-bridge.md` |

## Auth failover (mandatory order)

When any Notion tool is needed:

1. `GetMcpTools(server="plugin-notion-workspace-notion")` — if business tools exist → use plugin.
2. If only `mcp_auth` / `needsAuth` → **do not** loop OAuth prompts. Check PAT MCP.
3. `GetMcpTools(server="user-notion-token")` — Cursor prefixes user `mcp.json` keys with `user-`.
   If business tools exist → use PAT MCP (`API-post-search`, `API-post-page`, `API-update-page-markdown`, etc.).
4. If both MCP paths fail → Fate bridge:
   - `resolve_notion_access_token()` then `_notion_rest` (for `secret_`) or `_mcp_call` (OAuth access)
   - Env: `NOTION_TOKEN` / `NOTION_MCP_ACCESS_TOKEN`, else OAuth refresh from `state.vscdb`
5. Only if no PAT and refresh fails → ask user to run `scripts/set-notion-token.ps1` or one `mcp_auth`.
6. Parent pages must be shared with integration (this machine: `xwy-notion`); preferred hub: AiRec.

## IDE connect / re-auth (optional primary)

1. Confirm MCP server id: `plugin-notion-workspace-notion` (from Notion Workspace plugin).
2. Call `mcp_auth` on that server with empty arguments.
3. Complete browser OAuth.
4. Smoke test: `notion-search` with a short `query` (e.g. `test`).

## PAT backup MCP (preferred when OAuth flaky)

| Item | Value |
|------|--------|
| mcp.json key | `notion-token` |
| Runtime server id | `user-notion-token` |
| Config | `%USERPROFILE%\.cursor\mcp.json` → stdio `@notionhq/notion-mcp-server` |
| Env | User-level `NOTION_TOKEN` (never commit) |
| Helper | `cursorEnv/scripts/set-notion-token.ps1` |
| Note | Hosted `mcp.notion.com` rejects internal integration `secret_` bots; use stdio server |

Setup once: create Internal Integration (or PAT) → set `NOTION_TOKEN` → **share pages** with the integration → **restart Cursor**.

## Key facts (verified)

- Endpoint: `https://mcp.notion.com/mcp`
- Plugin mcp.json under: `%USERPROFILE%\.cursor\plugins\cache\cursor-public\notion-workspace\<hash>\mcp.json`
- OAuth ciphertext: `%APPDATA%\Cursor\User\globalStorage\state.vscdb` (`mcpOAuth.secret.*`)
- Decrypt key material: `%APPDATA%\Cursor\Local State` → `os_crypt.encrypted_key`
- `cursor-agent` / Feishu path does **not** share IDE MCP session → Fate bridge
- Hosted MCP accepts PAT Bearer (upstream Notion docs)

## Bridge fallback: create pages when MCP is needsAuth

If both plugin and `user-notion-token` are unavailable:

1. Read canonical wiki: `cursorEnv/wiki/notion-mcp/03-bridge-create-page.md` and `04-token-fallback.md`
2. Prefer `resolve_notion_access_token()` (PAT → refresh → cached access)
3. Call via Fate bridge: `_mcp_call(access, "tools/call", {name: "notion-create-pages", arguments})`
4. Workspace root args: `pages[].properties.title` + `pages[].content` (not top-level `title`)
5. Put one-off scripts under project `data/temp/`; delete after use

Do **not** fall back to writing markdown in the app repo root.

## Feishu / Fate path

If the issue is Feishu bot cannot see Notion after IDE re-auth:

1. Prefer `NOTION_TOKEN` set for the bot process; else refresh via bridge.
2. Restart Fate bot: `python -m feishuBot stream` from Fate root.
3. Ensure bridge uses browser User-Agent (Cloudflare blocks default Python UA).

## Response style

- Prefer checklist + table over long prose.
- Separate **verified** (paths/tools that work on this machine) from **inference**.
- Point to `NOTION-MCP.md` for full migration notes.
- Never echo full PAT / access tokens in chat.
