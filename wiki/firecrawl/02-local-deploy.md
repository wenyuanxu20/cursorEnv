# Firecrawl · 02 本机部署

## 定义

Windows 上在 `cursorEnv/getInfo` 用 Docker Compose 跑官方自托管栈，并接到 Cursor MCP。

## 关键结论

### 布局

| 组件 | 路径 / 值 |
|------|-----------|
| 部署根 | `cursorEnv/getInfo/` |
| 上游检出 | `getInfo/firecrawl/`（gitignore） |
| 钉选版本 | `v2.11.162` |
| env 模板 | `getInfo/env.example` → 运行时 `getInfo/firecrawl/.env` |
| 启动 | `getInfo/scripts/start-firecrawl.ps1` 或 `scripts/start-firecrawl.ps1` |
| 停止 | `getInfo/scripts/stop-firecrawl.ps1` |
| 主机端口 | `3002` |
| Compose 服务 | api、playwright-service、redis、rabbitmq、nuq-postgres（及可选 FoundationDB） |

### 复现步骤

```powershell
# Docker Desktop 必须已启动
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\start-firecrawl.ps1
curl.exe -fsS http://127.0.0.1:3002/v0/health/readiness
powershell -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\getInfo\scripts\firecrawl-scrape.ps1 -Url https://example.com
```

### 本机已验证（2026-08-24）

| 项 | 值 |
|------|-----------|
| 健康检查 | `GET /v0/health/readiness` → `{"status":"ok"}` |
| 冒烟 scrape | `https://example.com` → `success: true`，`statusCode: 200`，Markdown |
| API 镜像 | `ghcr.io/firecrawl/firecrawl:latest`（本机经 `ghcr.nju.edu.cn` 拉取后 tag） |
| Playwright | `ghcr.io/firecrawl/playwright-service:latest` |
| Postgres | `ghcr.io/firecrawl/nuq-postgres:latest` |
| Redis | 已有 `redis:7-alpine` |
| RabbitMQ | `public.ecr.aws/docker/library/rabbitmq:3-alpine`（Docker Hub 镜像站对 `foundationdb`/`rabbitmq:3-management` 失败或极慢） |
| API 内存 | overlay `mem_limit: 6G`；2G 时进程 137 OOM |
| 未启动 | FoundationDB（官方默认会拉，本机 daoCloud 403） |

脚本会：确认 Docker → 按需 clone 钉选 tag → 生成 `.env` → 复制 `getInfo/docker-compose.override.yaml` → 启动 `api` / `playwright-service` / `redis` / `rabbitmq` / `nuq-postgres`。首次拉 GHCR 镜像可能需数分钟。

### MCP（用户级，全局）

写入 `%USERPROFILE%\.cursor\mcp.json`：

```json
"firecrawl": {
  "command": "npx",
  "args": ["-y", "firecrawl-mcp@3.23.7"],
  "env": {
    "FIRECRAWL_API_URL": "http://127.0.0.1:3002"
  }
}
```

不要填 Cloud API Key。改完后重载 MCP。

### 资源

官方 Compose 对 api / playwright 有较高 CPU/内存上限。本机 overlay 把 API 限制为 6G。首次拉 GHCR 镜像约 2.5GB，可能数分钟。

### 安全

评估配置关闭 API 鉴权，只应监听本机。不要把 `3002` 做端口映射到公网。`.env` 与源码检出不进 Git。

## 证据与来源

- 上游：https://docs.firecrawl.dev/contributing/self-host
- MCP：https://docs.firecrawl.dev/mcp-server/local
- 本仓：`FIRECRAWL.md`、`getInfo/scripts/start-firecrawl.ps1`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [03 · 自动调用规则](03-auto-rule.md)
