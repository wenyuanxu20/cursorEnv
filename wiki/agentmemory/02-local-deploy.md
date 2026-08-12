# agentmemory · 02 本机部署

## 定义

本页记录 **Windows 本机**（cursorEnv / my-project 环境）上 agentmemory 的安装路径、版本、端口、MCP 接线与复现步骤。区分「本机已验证」与「上游通用说明」。

## 关键结论

### 本机已验证清单（2026-08-12）

| 组件 | 路径 / 值 |
|------|-----------|
| Node | `v24.14.1`（满足 ≥20） |
| agentmemory CLI | `@agentmemory/agentmemory@0.9.28` → `%APPDATA%\npm\agentmemory.cmd` |
| MCP 包 | `@agentmemory/mcp@0.9.28` → `agentmemory-mcp` |
| iii 引擎 | `0.11.2` → `%USERPROFILE%\.local\bin\iii.exe`（副本：`%USERPROFILE%\.agentmemory\bin\iii.exe`） |
| 数据 / 配置 | `%USERPROFILE%\.agentmemory\`（可选 `.env`） |
| REST | `http://127.0.0.1:3111` |
| Viewer | `http://127.0.0.1:3113` |
| Streams | `ws://127.0.0.1:3112` |
| Engine | `ws://127.0.0.1:49134` |
| 启动脚本 | `cursorEnv\scripts\start-agentmemory.ps1` |
| Cursor MCP | `%USERPROFILE%\.cursor\mcp.json` 键名 `agentmemory` |
| User PATH | 已含 `.local\bin`、`.agentmemory\bin` |
| 运行模式 | Provider=`noop`，Embeddings=`bm25-only` |
| Flags | AUTO_COMPRESS / INJECT_CONTEXT / GRAPH_EXTRACTION / CONSOLIDATION 均为关 |

冒烟：`POST /remember` → HTTP 201；`POST /smart-search` → 命中 probe 记忆。

### 与 myproject 关系

| 检查项 | 结果 |
|--------|------|
| `Desktop\my-project` 下是否已有 agentmemory / mem0 仓库 | **无** |
| cursorEnv 内是否有同类服务 | **无**（仅有 agency-agents 的 mcp-memory **文档模板**） |
| 处置 | 在本机全局 npm + 本仓库脚本部署，不另开 Git 子仓 |

### 复现安装（Windows）

```powershell
# 1) 包（国内建议镜像）
$env:CI = "1"
npm install -g @agentmemory/agentmemory @agentmemory/mcp --registry=https://registry.npmmirror.com

# 2) iii 引擎（Windows 不自动解压）
# 下载: https://github.com/iii-hq/iii/releases/download/iii/v0.11.2/iii-x86_64-pc-windows-msvc.zip
# 解压 iii.exe → %USERPROFILE%\.local\bin\iii.exe

# 3) 启动
pwsh C:\Users\xwy12\Desktop\my-project\cursorEnv\scripts\start-agentmemory.ps1

# 4) 验证
curl.exe -fsS http://127.0.0.1:3111/agentmemory/livez
agentmemory status
```

### MCP 块（已写入用户 mcp.json）

```json
"agentmemory": {
  "command": "agentmemory-mcp",
  "args": [],
  "env": {
    "AGENTMEMORY_URL": "http://127.0.0.1:3111",
    "AGENTMEMORY_TOOLS": "core"
  }
}
```

改完后须 **重启 Cursor**。

### 端口与冲突

| 端口 | 用途 |
|------|------|
| 3111 | REST |
| 3112 | Streams |
| 3113 | Viewer |
| 49134 | iii engine |

占用时先停冲突进程，或调整上游配置（本机默认端口未改）。

### 备选部署路径

| 路径 | 说明 |
|------|------|
| Docker 引擎 | `docker pull iiidev/iii:0.11.2` + `AGENTMEMORY_USE_DOCKER=1` |
| 仅 MCP、无引擎 | `agentmemory mcp`（能力弱于完整引擎模式） |
| WSL2 | 上游推荐路径；本机 Ubuntu 存在但当时无 Node，故采用原生 Windows + 手动 iii |

### 排障速查

| 现象 | 原因 / 动作 |
|------|-------------|
| `Auto-install unavailable on win32` | 未放 `iii.exe` |
| npm `ECONNRESET` | 换 npmmirror；检查 SOCKS `127.0.0.1:7897` |
| MCP 工具极少 | 服务未起或 `AGENTMEMORY_URL` 错 |
| `connect` 失败 | Windows 不支持；手改 mcp.json |

## 证据与来源

- 会话部署记录：2026-08-12（安装、iii 下载、livez/health、remember/search）
- `AGENTMEMORY.md`、`scripts/start-agentmemory.ps1`
- 上游 `INSTALL_FOR_AGENTS.md`（Windows / WSL 说明）

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [[notion-mcp/05-environment-and-ops]]（同机其他 MCP 环境）
