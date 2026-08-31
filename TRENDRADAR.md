# TrendRadar · 本机热点聚合与 Cursor 调用指南

> 上游：[sansan0/TrendRadar](https://github.com/sansan0/TrendRadar)（本机检出 `8ee2602`）  
> 检出：`getInfo/TrendRadar/`（gitignore，脚本按需 clone）· 启动：`getInfo/scripts/start-trendradar.ps1`  
> MCP：`http://127.0.0.1:3333/mcp` · Web（Docker 时）：`http://127.0.0.1:8080`  
> 本主题为 cursorEnv **必选**安装项；与本机 Firecrawl / Scrapling 一起由全局规则 `firecrawl-web-fetch.mdc` 调用。

## 是什么

**TrendRadar** 聚合微博 / 知乎 / 抖音 / 头条 / 财联社等热榜，把结果落在本地 `output/`，再通过 **MCP** 给 Cursor Agent 查热点、搜关键词、看趋势。cursorEnv 把它放在 `getInfo/`，和本机 Firecrawl、本机 Scrapling 组成默认联网取数栈：

| 意图 | 工具 |
|------|------|
| 热榜 / 舆情 / 今日新闻 | TrendRadar |
| 具体 URL / 文档站 / 网页正文 | Firecrawl（`:3002`） |
| 反爬 / Cloudflare / Firecrawl 失败 | 本机 Scrapling（`getInfo/scrapling/`） |
| 热点条目要全文 | TrendRadar 给链接 → Firecrawl scrape；失败再 Scrapling |

不要把 TrendRadar 的 `read_article`（Jina）当成默认正文通道。反爬页走 [Scrapling](./SCRAPLING.md)。

## 本机约定

| 项 | 值 |
|----|-----|
| 检出目录 | `cursorEnv/getInfo/TrendRadar/`（gitignore） |
| 上游 | https://github.com/sansan0/TrendRadar |
| 本机提交 | `8ee2602`（2026-08-24 clone，`--depth 1`） |
| MCP HTTP | `http://127.0.0.1:3333/mcp`（脚本 / curl；Cursor 不要用 URL） |
| Cursor MCP | STDIO：`getInfo/scripts/trendradar-mcp-stdio.py`（键名 `trendradar`） |
| Web UI | `http://127.0.0.1:8080`（仅 Docker 路径） |
| 用户 MCP | `%USERPROFILE%\.cursor\mcp.json` → 键名 `trendradar` |
| 运行时 id | `user-trendradar` |
| 自动规则 | 全局 `firecrawl-web-fetch.mdc`（`alwaysApply`） |
| 启动 | `pwsh .\getInfo\scripts\start-trendradar.ps1` |

首选 **Docker Compose**（`wantcat/trendradar` + `wantcat/trendradar-mcp`）。本机 Docker Hub 镜像站若 403，脚本会落到 **uv**：`uv sync` 后起 HTTP MCP，并跑一次 `python -m trendradar` 抓今日热榜。Cursor 两种路径都连 `:3333`。

## 快速开始

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-trendradar.ps1
curl.exe -s -o NUL -w "%{http_code}" -H "Accept: application/json, text/event-stream" http://127.0.0.1:3333/mcp
```

停止：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\stop-trendradar.ps1
```

首次只有仓库自带的 `output/news/2025-12-2x.db` 样例。要今日数据：等启动脚本里的一次 crawl 结束，或在对话里让 Agent 调 `trigger_crawl`。

## Cursor MCP（本机）

Cursor 把 `url: http://127.0.0.1:3333/mcp` 当成远程 Streamable-HTTP，会走 OAuth 发现，工具列表只剩 `mcp_auth`。本机改用 **STDIO**：

```json
"trendradar": {
  "command": "C:\\Users\\xwy12\\Desktop\\my-project\\cursorEnv\\getInfo\\TrendRadar\\.venv\\Scripts\\python.exe",
  "args": [
    "C:\\Users\\xwy12\\Desktop\\my-project\\cursorEnv\\getInfo\\scripts\\trendradar-mcp-stdio.py"
  ],
  "env": {
    "PYTHONUTF8": "1",
    "PYTHONIOENCODING": "utf-8"
  }
}
```

上游 `run_server` 会把启动横幅打到 stdout，STDIO 协议会坏；包装脚本把 `print` 改到 stderr。HTTP `:3333` 仍给脚本用：`getInfo/scripts/trendradar-mcp-call.py`。

- 改 `mcp.json` 后重载 MCP（本会话的 `user-trendradar` 不会自动切过去）。
- 常用工具：`get_latest_news`、`search_news`、`get_trending_topics`、`trigger_crawl`、`resolve_date_range`。
- 无推送渠道时仍可本地抓取与查询；飞书/钉钉等 webhook 写在检出目录 `docker/.env`，**不要提交**。

## 新机器检查清单（必选）

1. 安装 uv（`%USERPROFILE%\.local\bin\uv.exe`）与 Docker Desktop（有镜像站时 Compose 更快）。
2. 运行 `getInfo/scripts/start-trendradar.ps1`。
3. 把上面的 `trendradar` 块写入 `%USERPROFILE%\.cursor\mcp.json`（与 `firecrawl` 并列）。
4. 复制规则到 `%USERPROFILE%\.cursor\rules\firecrawl-web-fetch.mdc`。
5. 对 `http://127.0.0.1:3333/mcp` 探活；必要时 `trigger_crawl`。

## 资源与限制

- MCP 分析的是 **本地已抓的热榜**，不是任意网页搜索。正文抓取走 Firecrawl。
- `getInfo/TrendRadar/` 与 `getInfo/logs/` 不入库。
- Windows 控制台默认 GBK 时，crawl 可能因 emoji 打印崩溃；启动脚本已设 `PYTHONUTF8=1`。

详页：`wiki/trendradar/`。
