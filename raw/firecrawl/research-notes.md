# Firecrawl 本机部署笔记（cursorEnv/getInfo）

日期：2026-08-24

## 上游（文档，非本机臆造）

- Self-host 指南钉选 **v2.11.162**，API `http://localhost:3002`，评估配置 `USE_DB_AUTHENTICATION=false`
  https://docs.firecrawl.dev/contributing/self-host
- SELF_HOST.md 指向同一文档与仓库根 `docker-compose.yaml`
  https://github.com/firecrawl/firecrawl/blob/main/SELF_HOST.md
- 本地 MCP：`npx -y firecrawl-mcp@3.23.7` + `FIRECRAWL_API_URL` 指向自托管；无鉴权时可省略 API Key
  https://docs.firecrawl.dev/mcp-server/local
- 开源自托管默认有 scrape/crawl/map；截图/Fire-engine/部分 Agent 能力走 Cloud

## 本仓决策

- 部署根：`cursorEnv/getInfo/`（用户指定）
- 源码检出 gitignore，由 `start-firecrawl.ps1` clone 钉选 tag
- cursorEnv **必选**（manifest `necessity=必要` + `necessary_only`）
- 全局 alwaysApply 规则：联网取数优先 Firecrawl
- 用户 MCP 全局接线，与 agentmemory 相同模式

## 争议 / 不确定

- 自托管 `search` 是否开箱可用取决于是否配置 SearXNG 等；规则里 search 失败则 WebSearch→scrape
- 官方 Compose 资源上限较高，低内存 Docker Desktop 可能起不来
