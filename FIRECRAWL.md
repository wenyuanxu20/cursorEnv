# Firecrawl · 本机自托管与 Cursor 调用指南

> 上游：[firecrawl/firecrawl](https://github.com/firecrawl/firecrawl) · 自托管文档：[Self-hosting](https://docs.firecrawl.dev/contributing/self-host)  
> 检出：`getInfo/firecrawl/`（钉 `v2.11.162`）· 启动：`getInfo/scripts/start-firecrawl.ps1`  
> API：`http://127.0.0.1:3002` · MCP：`firecrawl-mcp@3.23.7` → `FIRECRAWL_API_URL`  
> 本主题为 cursorEnv **必选**安装项；全局规则 `firecrawl-web-fetch.mdc` 要求：网页正文走本机 Firecrawl，热榜走 TrendRadar。

## 是什么

**Firecrawl** 把网页打成 Agent 可用的 Markdown / 结构化数据。cursorEnv 在 `getInfo/` 用官方 Docker Compose **自托管 API**（可信网络、关闭库表鉴权），Cursor 通过 **MCP** 或 HTTP 调用，不依赖 Firecrawl Cloud。

与 Cursor 内置 `WebFetch`/`WebSearch` 的分工：具体 URL / 文档站默认先 Firecrawl 抓页；热榜 / 舆情走 [TrendRadar](./TRENDRADAR.md)；反爬或 Firecrawl 失败走 [Scrapling](./SCRAPLING.md)。仅当本机栈不可用，或自托管没有 search 时，WebSearch 只负责发现 URL。

## 本机约定

| 项 | 值 |
|----|-----|
| 检出目录 | `cursorEnv/getInfo/firecrawl/`（gitignore，脚本按需 clone） |
| 上游钉选 | Firecrawl **v2.11.162** |
| API | `http://127.0.0.1:3002` |
| 健康检查 | `GET /v0/health/readiness` → `{"status":"ok"}` |
| 抓取 | `POST /v2/scrape`（`formats: ["markdown"]`） |
| 鉴权 | `USE_DB_AUTHENTICATION=false`（本机可信网络；**不要**端口暴露到公网） |
| MCP 包 | `firecrawl-mcp@3.23.7` |
| 用户 MCP | `%USERPROFILE%\.cursor\mcp.json` → 键名 `firecrawl` |
| 运行时 id | `user-firecrawl` |
| 自动规则 | 全局 `firecrawl-web-fetch.mdc`（`alwaysApply`） |
| 启动 | `powershell -NoProfile -ExecutionPolicy Bypass -File .\getInfo\scripts\start-firecrawl.ps1` |
| 本机验证 | 2026-08-24：`/v0/health/readiness` ok；`POST /v2/scrape` example.com 成功 |

开源自托管**不含** Cloud 的 Fire-engine / 截图 / Agent 浏览器等能力；核心 scrape / crawl / map 可用。LLM extract 需另配 `OPENAI_API_KEY` 等，默认不配。

## 快速开始

```powershell
# 1) Docker Desktop 已运行
docker info

# 2) 启动（首次拉镜像可能数分钟；之后走本机 overlay 镜像）
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-firecrawl.ps1

# 3) 冒烟
curl.exe -fsS http://127.0.0.1:3002/v0/health/readiness
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\firecrawl-scrape.ps1 -Url https://example.com
```

停止：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\stop-firecrawl.ps1
```

## Cursor MCP（本机）

```json
"firecrawl": {
  "command": "npx",
  "args": ["-y", "firecrawl-mcp@3.23.7"],
  "env": {
    "FIRECRAWL_API_URL": "http://127.0.0.1:3002"
  }
}
```

- 本地无鉴权时**不要**填 Cloud 的 `FIRECRAWL_API_KEY`，否则 MCP 可能打到云端。
- 改 `mcp.json` 后重启 Cursor 或重载 MCP。
- MCP 未加载时，Agent 仍可用 HTTP `/v2/scrape`（见 `firecrawl-scrape.ps1`）。

## 新机器检查清单（必选）

1. 安装并启动 Docker Desktop（Compose v2）。
2. 运行 `getInfo/scripts/start-firecrawl.ps1`。
3. 把上面的 `firecrawl` 块写入 `%USERPROFILE%\.cursor\mcp.json`。
4. 复制规则到 `%USERPROFILE%\.cursor\rules\firecrawl-web-fetch.mdc`（本仓 `.cursor/rules/` 已有副本）。
5. 健康检查 + 对 `https://example.com` 做一次 scrape。

## 资源与限制

Compose 默认为 API 预留较高 CPU/内存。本机 overlay 把 API 限制为 **6G**（2G 会 OOM 137）。Docker Desktop 内存建议 ≥ 16GB。首次从 GHCR 拉 `firecrawl` 镜像约 2.5GB。栈含 API、Playwright、Redis、RabbitMQ、PostgreSQL；不启动 FoundationDB。仅 API 映射到主机 `3002`。

`.env` 只存在检出目录，**不提交**。`getInfo/firecrawl/` 源码检出也不入库。

详页：`wiki/firecrawl/`。
