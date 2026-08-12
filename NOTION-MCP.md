# Notion MCP 连接与授权指南

> 本机已验证（2026-07-26）：Cursor 插件 `notion-workspace` → MCP `plugin-notion-workspace-notion`  
> Token 兜底（2026-08-12）：用户 MCP `notion-token` + `NOTION_TOKEN` PAT；Fate `resolve_notion_access_token`  
> Fate 飞书桥接见：`my-project/Fate/wiki/13-feishu-notion-bridge.md`

本文档记录在 Windows + Cursor 环境下，如何连接、重新授权与排查 Notion MCP，并作为迁移/复现说明。cursorEnv 内配套 LLM wiki：`wiki/notion-mcp/`，Skill：`skills/notion-mcp/`（同步到 `~\.cursor\skills` 与 `~\.agents\skills`）。

---

## 一、定位说明

| 项 | 内容 |
|----|------|
| 能力 | 在 Cursor Agent 中搜索 / 读取 / 更新 Notion 工作区 |
| 主路径 | Cursor 官方插件 **Notion Workspace**（OAuth `mcp_auth`） |
| 兜底路径 | 用户 MCP `notion-token`（PAT Bearer）+ Fate bridge resolve |
| 插件 MCP server id | `plugin-notion-workspace-notion` |
| PAT MCP（mcp.json key） | `notion-token` |
| PAT MCP（运行时 id） | `user-notion-token` |
| 远端端点 | `https://mcp.notion.com/mcp`（HTTP MCP） |
| 鉴权 | OAuth（易过期）或 PAT（`NOTION_TOKEN`，更稳） |

与其它 MCP 的关系：

| 配置 | 作用 |
|------|------|
| `~\.cursor\mcp.json` | 用户 MCP：`openclaw-gateway` + **`notion-token`**（PAT） |
| 插件 cache `notion-workspace\...\mcp.json` | 插件声明 Notion HTTP MCP（OAuth） |
| Fate `feishuBot/notion_bridge.py` | `resolve_notion_access_token`：PAT → refresh → access |

---

## 二、本机路径快照（已验证）

| 检查项 | 路径 / 结果 |
|--------|-------------|
| 用户 MCP | `%USERPROFILE%\.cursor\mcp.json`（含 openclaw + `notion-token`） |
| 插件 MCP 定义 | `%USERPROFILE%\.cursor\plugins\cache\cursor-public\notion-workspace\<hash>\mcp.json` |
| OAuth 密文 | `%APPDATA%\Cursor\User\globalStorage\state.vscdb` → `mcpOAuth.secret.*` |
| AES 密钥材料 | `%APPDATA%\Cursor\Local State` → `os_crypt.encrypted_key` |
| PAT 环境变量 | 用户级 `NOTION_TOKEN`（勿提交） |
| cursorEnv wiki | `wiki/notion-mcp/` |
| Skill 源 | `cursorEnv/skills/notion-mcp/` |
| Skill 安装 | `%USERPROFILE%\.cursor\skills\notion-mcp\`、`%USERPROFILE%\.agents\skills\notion-mcp\` |

---

## 三、连接与重新授权

### 1. 安装 / 启用插件（可选主路径）

Cursor → Extensions / Plugins → 安装或启用 **Notion Workspace**（marketplace：`cursor-public/notion-workspace`）。

### 2. 推荐：配置 PAT 兜底（少重授权）

1. Notion → Settings → Developers / Connections → 创建 **Personal Access Token**（需 Notion API capability）
2. 设置用户环境变量（**不要**写入仓库）：

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\set-notion-token.ps1
```

3. 确认 `~\.cursor\mcp.json` 含（本机 verified：**stdio**，因托管 MCP 拒收 `secret_` bot）：

```json
"notion-token": {
  "command": "npx",
  "args": ["-y", "@notionhq/notion-mcp-server"],
  "env": {
    "NOTION_TOKEN": "${env:NOTION_TOKEN}"
  }
}
```

4. 在 Notion 把目标页 **Share → `xwy-notion`**（本机 integration 名）
5. **重启 Cursor** → Settings → MCP 确认 `user-notion-token` 为 ready
6. 冒烟：`CallMcpTool` → server=`user-notion-token` / `API-post-search` 或 `API-get-self`

### 3. 插件 OAuth（可选）

当工具列表仅有 `mcp_auth` 或 `serverStatus=needsAuth` 时，**优先改用 `user-notion-token`**；仅在无 PAT 且 bridge refresh 失败时再：

1. 调用 `mcp_auth`（server=`plugin-notion-workspace-notion`，无参数）
2. 浏览器完成 Notion OAuth
3. `notion-search` 冒烟

自然语言触发（装好 Skill 后）：

- 「重新授权 Notion MCP」
- 「Notion MCP 连不上 / needsAuth」
- 「切换 Notion token 兜底」

### 4. Agent 自动切换顺序

见 Skill / [04 · Token 兜底](wiki/notion-mcp/04-token-fallback.md)：插件 → `user-notion-token` → bridge resolve → 才提示用户。

---

## 四、常用工具（插件 / PAT MCP）

| 工具 | 用途 |
|------|------|
| `mcp_auth` | 插件 OAuth 登录 / 重新授权（PAT 路径不需要） |
| `notion-search` / `notion-fetch` / `notion-create-pages` | 插件 OAuth 路径（可用时） |
| `API-post-search` / `API-post-page` / `API-update-page-markdown` 等 | PAT 路径 `user-notion-token`（stdio REST 包装） |

完整 schema 以当前会话 `GetMcpTools` 为准（分别查两个 server id）。环境快照见 [wiki/notion-mcp/05-environment-and-ops.md](wiki/notion-mcp/05-environment-and-ops.md)。

---

## 五、needsAuth 回退：bridge 直连

插件与 `user-notion-token` 均不可用时，用 Fate bridge 直连 MCP。详见 [03](wiki/notion-mcp/03-bridge-create-page.md) / [04](wiki/notion-mcp/04-token-fallback.md)。

| 步骤 | 动作 |
|------|------|
| 1 | `resolve_notion_access_token()`（PAT → refresh → access） |
| 2 | 必要时 `POST https://mcp.notion.com/token` |
| 3 | `_mcp_call(access, "tools/call", {name: "notion-create-pages", arguments})` |
| 4 | 工作区根：`pages[].properties.title` + `pages[].content`（勿用顶层 `title`） |

实现入口：`Fate/feishuBot/notion_bridge.py`。`search_and_fetch` 已走 resolve；写操作仍需 `_mcp_call`。

---

## 六、排障

| 现象 | 处理 |
|------|------|
| 插件 `needsAuth` / 只有 `mcp_auth` | **先用 `user-notion-token`**；无 PAT 再 OAuth 或 bridge |
| `user-notion-token` 红点 / 仅 mcp_auth | 检查用户级 `NOTION_TOKEN` 是否设置并已重启 Cursor |
| 授权成功但飞书 bot 仍失败 | 为 bot 进程设 `NOTION_TOKEN`，或重启 `python -m feishuBot stream` |
| 直连 `mcp.notion.com` 返回 Cloudflare 403 | 必须用浏览器式 User-Agent（见 Fate `notion_bridge.py`） |
| cursor-agent 报 Notion 未认证 | **预期行为**：CLI 不共享 IDE OAuth；飞书路径走 bridge |

---

## 七、与 Fate 飞书 bot

| 场景 | 路径 |
|------|------|
| Cursor IDE 聊 Notion | 插件 MCP 或 `user-notion-token` |
| 飞书 → Cursor → Notion | Fate `notion_bridge.resolve_notion_access_token` |

重启飞书 bot（刷新 token 读取）：

```powershell
# 停掉旧进程后
cd C:\Users\xwy12\Desktop\my-project\Fate
python -m feishuBot stream
```

---

## 八、Skill 安装（本仓库）

源目录：`cursorEnv/skills/notion-mcp/`

```powershell
$src = "C:\Users\xwy12\Desktop\my-project\cursorEnv\skills\notion-mcp"
$dests = @(
  "$env:USERPROFILE\.cursor\skills\notion-mcp",
  "$env:USERPROFILE\.agents\skills\notion-mcp"
)
foreach ($d in $dests) {
  New-Item -ItemType Directory -Force -Path $d | Out-Null
  Copy-Item -Recurse -Force "$src\*" $d
}
```

---

## 相关页面

- Wiki：[00 · 总览](wiki/notion-mcp/00-overview.md) · [01 · 授权与配置](wiki/notion-mcp/01-auth-and-config.md) · [02 · 飞书桥接](wiki/notion-mcp/02-feishu-bridge.md) · [03 · 桥接直连建页](wiki/notion-mcp/03-bridge-create-page.md) · [04 · Token 兜底](wiki/notion-mcp/04-token-fallback.md) · [05 · 环境与运维](wiki/notion-mcp/05-environment-and-ops.md)
- Fate：[12 · 飞书×Cursor×Notion](../Fate/wiki/12-feishu-cursor-bot.md)（相对 monorepo 布局；绝对路径见 wiki）
- 原始笔记：`raw/notion-mcp/research-notes.md`
