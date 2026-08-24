# Scrapling · 02 本机部署

## 定义

Windows 上在 `cursorEnv/getInfo/scrapling` 用 uv 安装钉选的 Scrapling，下载浏览器，并接到 Cursor MCP。

## 关键结论

### 布局

| 组件 | 路径 / 值 |
|------|-----------|
| 部署根 | `cursorEnv/getInfo/` |
| uv 项目 | `getInfo/scrapling/pyproject.toml`、`uv.lock` |
| 钉选版本 | `scrapling[all]==0.4.15` |
| 解释器 | CPython 3.12（`.python-version`） |
| 虚拟环境 | `getInfo/scrapling/.venv/`（gitignore） |
| 启动 | `getInfo/scripts/start-scrapling.ps1` 或 `scripts/start-scrapling.ps1` |
| 停止 HTTP | `getInfo/scripts/stop-scrapling.ps1` |
| 冒烟 | `getInfo/scripts/scrapling-scrape.ps1` |
| STDIO MCP | `.venv/Scripts/scrapling-mcp.exe` |
| HTTP MCP | 可选 `127.0.0.1:3344` |

### 复现步骤

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-scrapling.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\scrapling-scrape.ps1 -Url https://example.com
```

脚本会：`uv sync`（Python 3.12，经 `http://127.0.0.1:7897` 访问 PyPI）→ `scrapling install` → HTTP Fetcher 冒烟。加 `-Http` 才起 Streamable HTTP MCP。

### MCP（用户级，全局）

写入 `%USERPROFILE%\.cursor\mcp.json`：

```json
"scrapling": {
  "command": "C:\\Users\\xwy12\\Desktop\\my-project\\cursorEnv\\getInfo\\scrapling\\.venv\\Scripts\\scrapling-mcp.exe"
}
```

改完后重载 MCP。不要用 `socks5://127.0.0.1:7897` 给 uv 装包。

### 本机已验证 / 上游推断

| 项 | 性质 |
|----|------|
| `0.4.15` 安装、`example.com` HTTP 200、`scrapling-mcp.exe` 存在 | 本机已验证（2026-08-24） |
| socks5 导致 uv TLS eof；清华无 0.4.15 | 本机已验证 |
| 官方 MCP 十三工具、HTTP 要 token 或 `--no-auth` | 上游 0.4.15 文档 |

### 安全

STDIO 只给 Cursor 拉起。HTTP 模式若用 `--no-auth`，只绑 `127.0.0.1`，不要端口映射到公网。

## 证据与来源

- 上游：https://scrapling.readthedocs.io/en/latest/ai/mcp-server.html
- 本仓：`SCRAPLING.md`、`getInfo/scripts/start-scrapling.ps1`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [03 · 自动调用规则](03-auto-rule.md)
