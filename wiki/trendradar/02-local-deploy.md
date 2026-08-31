# TrendRadar · 02 本机部署

## 定义

Windows 上在 `cursorEnv/getInfo` 部署 TrendRadar 爬虫 + MCP，并接到 Cursor。

## 关键结论

### 布局

| 组件 | 路径 / 值 |
|------|-----------|
| 部署根 | `cursorEnv/getInfo/` |
| 上游检出 | `getInfo/TrendRadar/`（gitignore） |
| 本机 clone | `8ee2602`，`git clone --depth 1` |
| 启动 | `getInfo/scripts/start-trendradar.ps1` 或 `scripts/start-trendradar.ps1` |
| 停止 | `getInfo/scripts/stop-trendradar.ps1` |
| MCP | `127.0.0.1:3333` |
| Docker 镜像 | `wantcat/trendradar`、`wantcat/trendradar-mcp` |
| uv 回退 | `uv sync` + HTTP MCP；一次 `uv run python -m trendradar` |

### 复现步骤

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-trendradar.ps1
curl.exe -s -o NUL -w "%{http_code}" -H "Accept: application/json, text/event-stream" http://127.0.0.1:3333/mcp
```

脚本会：按需 clone → 尝试 `docker compose pull/up` → 失败则 `uv sync`、后台起 HTTP MCP、再跑一次热榜。

### MCP（用户级，全局）

Cursor **不要**填 HTTP `url`（会触发 OAuth，只剩 `mcp_auth`）。写入 STDIO：

```json
"trendradar": {
  "command": "C:\\Users\\xwy12\\Desktop\\my-project\\cursorEnv\\getInfo\\TrendRadar\\.venv\\Scripts\\python.exe",
  "args": [
    "C:\\Users\\xwy12\\Desktop\\my-project\\cursorEnv\\getInfo\\scripts\\trendradar-mcp-stdio.py"
  ],
  "env": { "PYTHONUTF8": "1", "PYTHONIOENCODING": "utf-8" }
}
```

改完后重载 MCP。HTTP `:3333` 仍由 `start-trendradar.ps1` 拉起，给 `trendradar-mcp-call.py` 用。

### 本机已验证 / 上游推断

| 项 | 性质 |
|----|------|
| clone `8ee2602`、端口 3333、uv 回退因 daocloud 403、一次 crawl 255 条（2026-08-24） | 本机已验证 |
| Docker 双容器为上游推荐路径 | 上游文档；本机 Hub 镜像站曾 403 |

### 安全

MCP 只绑 `127.0.0.1`。Webhook / AI Key 只放检出内 `docker/.env`，不进 Git。

## 证据与来源

- 上游：https://github.com/sansan0/TrendRadar
- 本仓：`TRENDRADAR.md`、`getInfo/scripts/start-trendradar.ps1`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [03 · 自动调用规则](03-auto-rule.md)
