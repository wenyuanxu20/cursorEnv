# getInfo — 本机联网取数

本目录部署 **Firecrawl**（网页正文）、**TrendRadar**（多平台热榜）与 **Scrapling**（反爬 / Firecrawl 失败时的自适应抓取），供 Cursor Agent 在需要从网络取信息时优先调用。

| 文件 | 作用 |
|------|------|
| [FIRECRAWL.md](../FIRECRAWL.md) | Firecrawl 自托管 API（根目录，cursorEnv **必选**） |
| [TRENDRADAR.md](../TRENDRADAR.md) | TrendRadar 热榜 + MCP（根目录，cursorEnv **必选**） |
| [SCRAPLING.md](../SCRAPLING.md) | Scrapling uv 运行时 + 官方 MCP（根目录，cursorEnv **必选**） |
| `scripts/start-firecrawl.ps1` | 克隆/启动 Firecrawl Compose、等待健康检查 |
| `scripts/stop-firecrawl.ps1` | Firecrawl `docker compose down` |
| `scripts/firecrawl-scrape.ps1` | HTTP 冒烟：`POST /v2/scrape` |
| `scripts/start-trendradar.ps1` | 克隆/启动 TrendRadar（Docker，失败则 uv） |
| `scripts/stop-trendradar.ps1` | 停止 TrendRadar 容器或 uv MCP |
| `scripts/start-scrapling.ps1` | uv 安装钉选 Scrapling、浏览器、HTTP 冒烟 |
| `scripts/stop-scrapling.ps1` | 停止可选 HTTP MCP `:3344` |
| `scripts/scrapling-scrape.ps1` | HTTP/dynamic/stealthy Fetcher 冒烟 |
| `env.example` | Firecrawl Compose `.env` 模板 |
| `firecrawl/` | Firecrawl 上游检出（`v2.11.162`，**不入库**） |
| `TrendRadar/` | TrendRadar 上游检出（**不入库**） |
| `scrapling/` | uv 项目（`pyproject.toml` 入库；`.venv/` **不入库**） |

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\start-firecrawl.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\start-trendradar.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\start-scrapling.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\firecrawl-scrape.ps1 -Url https://example.com
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\scrapling-scrape.ps1 -Url https://example.com
```

调用规则：全局 `firecrawl-web-fetch.mdc`（`alwaysApply`）。Wiki：`wiki/firecrawl/`、`wiki/trendradar/`、`wiki/scrapling/`。
