# Wiki 变更日志

按时间倒序记录 ingest 与页面变更。

## 2026-08-31 · AstrBot 微信可回复图片

**来源**
- 用户：调整astrbot，我需要能回复我图片

**更新**
- 插件 `astrbot_plugin_sf_image`（Kolors 生图）+ `siliconflow_vl` 识图；本机与阿里云已加载
- 专题在 sibling：`ai/AstrBot/wiki/aliyun/sf-image.md`
- 出图请在**阿里云微信**测 `/画` 或「发张图」；本机微信仍关闭以免抢登录

## 2026-08-31 · cursor-proxy 转发 Persona system（女仆人设）

**来源**
- 用户：人设没生效，检查阿里云

**更新**
- 根因：`streaming-proxy.mjs` 只把最后一条 user 交给 `agent -p`，AstrBot 人格 system 被丢弃
- 已改为 `buildAgentPrompt` 拼接 system + 用户消息；阿里云 `cursor-proxy` 已重启

## 2026-08-31 · 本机 ↔ 阿里云同步记忆库与 getInfo 数据

**来源**
- 用户：同步本机和阿里云记忆库、getInfo 数据

**更新**
- 脚本：`ai/cloudsurver/_sync_memory_getinfo_aliyun.py`
- 本机 iii 曾占着 `:3111` 但 `/agentmemory/*` 全 404，Cursor MCP 已落到 `standalone.json`（56 条）；已重启 REST 并从该文件 + 阿里云导出 merge
- 对齐后两边 agentmemory **122** 条；getInfo TrendRadar `news/html/rss` 与 agents-radar `cache` 按文件更新时间做并集
- 仍是两套进程，不会自动实时双写；下次再跑同一脚本

## 2026-08-31 · getInfo 部署 agents-radar 并接入 AstrBot 推送

**来源**
- 用户：在 getInfo 部署开源 agents-radar，接入 AstrBot 推送最新动态

**更新**
- 本机 HTTP `:3355`（读已发布日报，不跑上游 LLM Actions）
- 插件 `astrbot_plugin_agents_radar`：`/radar_bind` 绑定并推送
- 专题 `wiki/agents-radar/`、根指南 `AGENTS-RADAR.md`
- 整仓 zip 因 SOCKS 超时未检出；服务不依赖 clone
- 阿里云：`getinfo-agents-radar` active；`:3355/health` 与 `/card` 已通（先上传本机 cache，避免 ECS 拉 GitHub 超时）；插件已加载，`/radar_bind` 可用

## 2026-08-31 · 阿里云 ECS 部署 getInfo

**来源**
- 用户：在阿里云部署 getInfo 并接入 AstrBot

**更新**
- ECS 2 vCPU / 3.5 GiB：不装 Firecrawl Compose；TrendRadar uv MCP + scrape shim
- 脚本：`ai/cloudsurver/_deploy_getinfo_aliyun.py`
- 核验：`trendradar: ready`；今日热榜 db；插件 `astrbot_plugin_getinfo` 已加载

## 2026-08-31 · AstrBot 查询走本机 getInfo

**来源**
- 用户：查看 getInfo 与 AstrBot；调用 AstrBot 查信息时也要能调信息获取项目

**更新**
- 插件：`ai/AstrBot/extras/astrbot_plugin_getinfo/`（HTTP TrendRadar / Firecrawl / Scrapling）
- 安装：`getInfo/scripts/install-astrbot-getinfo.ps1`；MCP 模板 `getInfo/astrbot-mcp.windows.json`
- 规则 `firecrawl-web-fetch.mdc` 增加 AstrBot 段
- 专题：`wiki/cursor-agent-api/04-getinfo-bridge.md`；AstrBot `wiki/aliyun/getinfo-plugin.md`

**要点**
- Cursor 主路径：工作区 MCP + `--approve-mcps`
- SiliconFlow 回退：插件 HTTP，不依赖 Cursor MCP
- 阿里云 ECS 默认没有 Windows getInfo；`127.0.0.1` 是云主机

## 2026-08-24 · 联网取数规则写明本机已部署 Scrapling

**来源**
- 用户：调用信息获取规则里面加上本地已经部署的 Scrapling

**更新**
- 全局规则 `firecrawl-web-fetch.mdc`：三件套表改为「本机部署 + 调用」；Scrapling 路径 `getInfo/scrapling/`、钉选 `0.4.15`、MCP 键 `scrapling` / `user-scrapling`
- `AGENTS.md` 查询优先级、`FIRECRAWL.md` / `TRENDRADAR.md`、wiki firecrawl/trendradar/scrapling 03 与总览、`wiki/index.md`、`web/app.js`

**要点**
- 路由仍是：热榜 TrendRadar → 普通页 Firecrawl → 反爬/失败才走本机 Scrapling（不要默认用浏览器抓普通文档站）

## 2026-08-24 · TrendRadar Cursor MCP 改 STDIO

**来源**
- 用户：修 TrendRadar MCP 接入（Cursor 工具发现失败）

**更新**
- 用户 `mcp.json`：`trendradar` 从 HTTP URL 改为 STDIO 包装脚本
- 新增 `getInfo/scripts/trendradar-mcp-stdio.py`、`trendradar-mcp-call.py`
- `TRENDRADAR.md`、`wiki/trendradar/02-local-deploy.md`、`firecrawl-web-fetch.mdc`

**要点**
- HTTP `:3333` 握手本身正常；Cursor 把 localhost Streamable-HTTP 当 OAuth，只露出 `mcp_auth`
- 上游 STDIO 会把启动横幅打到 stdout，包装脚本把 print 改到 stderr

## 2026-08-24 · 联网取数回复必须点名工具

**来源**
- 用户：调用 firecrawl / scrapling 等新增取数工具时，回复里要写明用了哪些工具

**更新**
- 全局规则 `firecrawl-web-fetch.mdc`：新增「回复必须点名工具」
- Wiki：`wiki/firecrawl/03-auto-rule.md`、`wiki/scrapling/03-auto-rule.md`、`wiki/trendradar/03-auto-rule.md`

**要点**
- 用了 getInfo 工具或回退 WebFetch/WebSearch 时，在回复中写出服务名 + MCP/脚本名，不要只给结论

## 2026-08-24 · Scrapling 本机部署（getInfo）+ 联网取数补反爬通道

**来源**
- 用户：在 `cursorEnv/getInfo` 部署 Scrapling 到本地

**新增 / 更新**
- 部署：`getInfo/scrapling/`（uv 钉 `scrapling[all]==0.4.15`；`.venv` gitignore）
- 脚本：`getInfo/scripts/start-scrapling.ps1`、`stop-scrapling.ps1`、`scrapling-scrape.ps1`
- 根指南：`SCRAPLING.md`
- 全局规则：`firecrawl-web-fetch.mdc`（Firecrawl 失败 / 反爬走 Scrapling）
- Wiki：`wiki/scrapling/00`–`03`、`raw/scrapling/research-notes.md`
- `README.md`、`AGENTS.md`、`wiki/index.md`、manifest、`web/app.js`、用户 `mcp.json`

**要点**
- 本机已验证：`Fetcher.get(https://example.com)` → 200
- Cursor STDIO MCP：`getInfo/scrapling/.venv/Scripts/scrapling-mcp.exe`，键名 `scrapling`
- uv 装包用 HTTP 代理 `http://127.0.0.1:7897`；socks5 会 TLS eof；清华当时无 0.4.15

## 2026-08-24 · TrendRadar 本机部署（getInfo）+ 联网规则双通道

**来源**
- 用户：在 `cursorEnv/getInfo` 部署 TrendRadar；联网取数优先 Firecrawl + TrendRadar；列为 cursorEnv 必选

**新增 / 更新**
- 部署：`getInfo/TrendRadar/`（gitignore）+ `getInfo/scripts/start-trendradar.ps1`
- 根指南：`TRENDRADAR.md`
- 全局规则：`firecrawl-web-fetch.mdc` 改为热榜 TrendRadar / 正文 Firecrawl
- Wiki：`wiki/trendradar/00`–`03`、`raw/trendradar/research-notes.md`
- `README.md`、`AGENTS.md`、`wiki/index.md`、manifest `necessary_only`、`web/app.js`、用户 `mcp.json` 键 `trendradar`

**要点**
- MCP `http://127.0.0.1:3333/mcp`（uv HTTP；Docker Hub 镜像站对 `wantcat/trendradar` 曾 403）
- 与 Firecrawl `:3002` 并列，同为最小环境必选项

## 2026-08-24 · Firecrawl 本机部署（getInfo）+ 联网取数规则

**来源**
- 用户：在 `cursorEnv/getInfo` 部署 Firecrawl；要上网取信息时优先用 Firecrawl；列为 cursorEnv 必选安装

**新增 / 更新**
- 部署：`getInfo/`（脚本、`env.example`；源码检出 gitignore）
- 根指南：`FIRECRAWL.md`
- 全局规则：`firecrawl-web-fetch.mdc`（`alwaysApply`）
- Wiki：`wiki/firecrawl/00`–`03`、`raw/firecrawl/research-notes.md`
- `README.md`、`AGENTS.md`、`wiki/index.md`、manifest、`web/app.js`、用户 `mcp.json`

**要点**
- API `http://127.0.0.1:3002`，钉选上游 `v2.11.162`，评估配置无鉴权
- MCP `firecrawl-mcp@3.23.7` + `FIRECRAWL_API_URL`，不填 Cloud Key
- 仅本机栈失败时才回退 WebFetch/WebSearch
- 2026-08-24 本机验证：readiness ok；scrape `https://example.com` 成功（GHCR 镜像 + ECR RabbitMQ；跳过 FoundationDB）

## 2026-08-17 · my-project 知识库总览 + 双写规则

**来源**
- 用户：把 my-project 各项目的 llm wiki / memory / graphify 统一到 my-project 根目录，项目内文件保留，后续两边同时更新，并写入 Cursor 默认规则

**新增 / 更新**
- 总览目录：`C:\Users\xwy12\Desktop\my-project\knowledge-hub\`（`sync.ps1` / `INDEX.md` / `projects/`）
- 全局规则：`knowledge-hub-dual-update.mdc`（`alwaysApply`）
- `wiki/knowledge-hub/00-overview.md`、`wiki/index.md`、`AGENTS.md`、`README.md`、`scripts/sync-knowledge-hub.ps1`

**要点**
- wiki / raw / schema / AGENTS 等为副本；`graphify-out` 为目录联接
- agentmemory blob 不镜像（本机 `:3111`）
- 改知识库后跑 `knowledge-hub/sync.ps1 -Project <名>`

## 2026-08-14 · Cursor Agent API 调用方式入库

**来源**
- 用户：检查 cursorEnv 是否已有 Cursor Agent API 文档/memory/wiki；若无则参考 `ai` 仓 AstrBot 调用方式整理后 push
- sibling：`ai/AstrBot/cursor-proxy/`、`ai/cursor_api.py`、`ai/AstrBot/wiki/aliyun/provider-routing.md`

**新增 / 更新**
- `CURSOR-AGENT-API.md`
- `wiki/cursor-agent-api/00`–`03`
- `README.md`、`AGENTS.md`、`wiki/index.md`、manifest、`web/app.js`、`GRAPHIFY.md`

**要点**
- 本仓此前无此专题（grep / graphify / memory 均无独立文档）
- AstrBot 主路径：standalone proxy `:18791` → `agent -p --trust --approve-mcps`；Cloud REST 为回退
- 勿把 `cursor.exe` 当成 Agent CLI；Cloud 鉴权是 Basic `key:` 不是 Bearer
- 密钥与 ECS 登录信息不写入本公开仓

## 2026-08-14 · 长篇小说连续性脚手架上线

**来源**
- 用户：继续落地小说仓 wiki 模板 + 记忆该记/不该记；上线后 push
- `raw/novel-writing/research-notes.md`

**新增 / 更新**
- Skill：`skills/novel-continuity/`（含 templates + 项目规则）
- 全局规则：`novel-wiki-bootstrap.mdc`（触发词 `构建小说wiki`）
- `NOVEL-WRITING.md`、`wiki/novel-writing/00`–`02`
- `README.md`、`AGENTS.md`、`wiki/index.md`、manifest、`web/`

**要点**
- Canon = `wiki/novel/` + `manuscript/`；agentmemory 只记铁律
- 小说须独立工作区，避免与代码记忆混搜

## 2026-08-14 · 介绍文档对齐 + 公开仓库前去掉记忆 blob

**来源**
- 用户：检查 README / wiki / graphify / memory 是否落后；更新后 push，并把 GitHub 仓库改为 public

**新增 / 更新**
- `README.md`：四层入口（部署文档 / wiki / graphify / agentmemory），补 `AGENTMEMORY.md` 与静态页
- `cursor-env-manifest.json`：登记 agentmemory；`last_updated` → 2026-08-14
- `GRAPHIFY.md`：cursorEnv 图谱规模与 gitignore 说明
- `AGENTMEMORY.md`、`AGENTS.md`、`NOTION-MCP.md`
- `wiki/index.md`、`wiki/agentmemory/00`–`04`、`wiki/notion-mcp/00`/`05`
- `web/index.html`、`web/app.js`、`web/rules.js`（核心规则与工具书架）
- `.gitignore`：不再跟踪 `data/state_store.db/`（个人记忆不公开）

**要点**
- 介绍文档此前仍停在 Notion MCP（2026-07-26），未写 agentmemory 自动规则与 Notion 同步
- 增量 Notion sync 本机可读页 25（checkpoint 跳过未改页）
- Graphify 产物与记忆 blob 均不入库；克隆后需本地 `graphify update .`（文档语义提取需 API Key）
- 2026-08-14 本机 `graphify update .`：4770 节点 · 4997 边 · 299 社区

## 2026-08-13 · Notion 全量写入 agentmemory + 自动同步 skill

**来源**
- 用户：确认记忆文件；把可读 Notion 内容写入记忆；新建 skill，任何项目在 Notion 更新时自动同步

**新增 / 更新**
- 全量 ingest：24 页，`failed=0` → `data/state_store.db/mem%3Amemories.bin`
- Skill：`skills/notion-agentmemory-sync/` → `~\.cursor\skills` 与 `~\.agents\skills`
- 全局规则：`notion-agentmemory-sync.mdc`（`alwaysApply`）
- `wiki/agentmemory/04-notion-sync.md`、`02`/`03`/`index`/`log`

**要点**
- 记忆主文件是 iii 的 `mem:memories.bin`，不是单独 markdown
- 仅同步已分享给 `xwy-notion` 的页面；增量靠 checkpoint
- Python 调 Notion 须直连，不可走本机 SOCKS

## 2026-08-13 · 阿里云 AstrBot 部署独立 agentmemory

**来源**
- 用户：同步阿里云信息到 memory；检查后直接在 ECS 部署，供手机端自动 recall/save

**更新**
- `wiki/agentmemory/03-auto-rule.md`：注明 Aliyun 为独立 store
- 实际部署与详页在 `ai/AstrBot/wiki/aliyun/agentmemory.md`

**要点**
- ECS glibc 2.32 → 必须 musl iii；GitHub 从 ECS 不通
- Cursor CLI MCP id 为 `agentmemory`（无 `user-` 前缀）

## 2026-08-13 · agentmemory 全局自动调用规则

**来源**
- 用户：新增 Cursor rules，任何项目自动调用 agentmemory，无需手动调用；随后更新 memory / wiki / graphify 并 push

**新增 / 更新**
- 全局规则：`%USERPROFILE%\.cursor\rules\agentmemory-auto.mdc`（`alwaysApply: true`）
- 中枢副本：`cursorEnv/.cursor/rules/agentmemory-auto.mdc`
- 备份：`cursor-rules/latest/rules/agentmemory-auto.mdc`、`agentmemory-auto--global.mdc`
- `wiki/agentmemory/03-auto-rule.md`（新建）
- `wiki/agentmemory/00-overview.md`、`01-usage.md`、`02-local-deploy.md`
- `wiki/index.md`、`AGENTMEMORY.md`、`AGENTS.md`

**要点**
- Agent 会话开场必须 `memory_recall`；有可复用结论时 `memory_save`
- MCP 不可用时静默跳过，不阻断任务；禁止写入密钥

## 2026-08-12 · agentmemory 部署 + 使用指引（wiki + AiRec）

**来源**
- 用户：调研 agentmemory；myproject 无同类则部署；补充详细使用指引并同步 wiki / Notion AiRec
- 本机实测：CLI 0.9.28、iii 0.11.2、livez/health、remember/smart-search、Cursor MCP `agentmemory`

**新增 / 更新**
- `AGENTMEMORY.md`（新建）
- `wiki/agentmemory/00-overview.md`、`01-usage.md`、`02-local-deploy.md`
- `raw/agentmemory/deploy-notes-2026-08-12.md`
- `scripts/start-agentmemory.ps1`（此前会话已建）
- `wiki/index.md`、`AGENTS.md`
- Notion AiRec 子页：
  - Hub https://app.notion.com/p/cursorEnv-agentmemory-Wiki-3ba54d8e86f6815bb65be3daa70ee776
  - 用法 https://app.notion.com/p/01-agentmemory-3ba54d8e86f68160959bf1fa7c6abbc3
  - 部署 https://app.notion.com/p/02-agentmemory-3ba54d8e86f681f1abf6f8f97e716c07

**要点**
- myproject 原先无记忆服务；agency-agents mcp-memory 仅为 Prompt 模板
- Windows：手动 `iii.exe`；MCP 手写 `mcp.json`（`AGENTMEMORY_TOOLS=core`）
- 默认 zero-LLM / BM25-only

## 2026-08-12 · Notion 环境快照 wiki + AiRec 同步

**来源**
- 用户：在 cursorEnv 与 Notion AiRec 同步新建 wiki，细述 Notion 连接方式与环境
- 会话实测：插件 needsAuth；`user-notion-token` ready；`secret_`/`xwy-notion`；AiRec 分享后 REST 建页

**新增 / 更新**
- `wiki/notion-mcp/05-environment-and-ops.md`（新建）
- `wiki/notion-mcp/00`–`04`、`wiki/index.md`、`NOTION-MCP.md`（纠正 stdio 配置与建页决策序）
- Notion AiRec 子页：
  - Hub https://app.notion.com/p/cursorEnv-Notion-Wiki-3ba54d8e86f68153a06beb74df7b24bc
  - 详 https://app.notion.com/p/05-3ba54d8e86f6818492d8df86ba69c240
  - 摘要 https://app.notion.com/p/3ba54d8e86f681448625db69d5779e7e

**要点**
- 三条通道：stdio PAT MCP → 插件 OAuth → Fate bridge（REST/MCP）
- Internal integration 不可工作区根建页；父锚 AiRec `3a954d8e-86f6-81ac-808c-fa1bb6a8422e`

## 2026-08-12 · Notion MCP Token 兜底（PAT + 自动切换）

**来源**
- 用户需求：插件 OAuth 常需重新授权；MCP 失败时自动切 token
- Notion 托管 MCP 支持 PAT Bearer；Cursor `mcp.json` 支持 `headers` + `${env:VAR}`

**新增 / 更新**
- `wiki/notion-mcp/04-token-fallback.md`
- `wiki/notion-mcp/00-overview.md`、`01-auth-and-config.md`、`02-feishu-bridge.md`、`03-bridge-create-page.md`
- `NOTION-MCP.md`、`skills/notion-mcp/SKILL.md`、`AGENTS.md`、`wiki/index.md`
- Fate：`feishuBot/notion_bridge.py` → `resolve_notion_access_token` / `refresh_notion_access_token`
- 用户 MCP：`~\.cursor\mcp.json` 增加 `notion-token`

**要点**
- Agent 顺序：插件 → `user-notion-token` → bridge resolve → 才提示 OAuth/补 PAT
- Token 只进用户环境变量 `NOTION_TOKEN`，不进仓库；辅助脚本 `scripts/set-notion-token.ps1`
- 本机 2026-08 实测：`state.vscdb` 仅剩 client_information，无 `mcp_tokens` → 必须补 PAT

## 2026-07-29 · 批量为 my-project 子项目补齐 LLM wiki + graphify

**来源**
- 用户请求：为缺少独立 LLM wiki/graphify 的项目补充
- 脚本：`scripts/bootstrap-llm-wiki-graphify.ps1`

**覆盖**
- 顶层全部 18 个子目录现均有 `AGENTS.md` + wiki（或 `llm-wiki/`）+ `raw/` + `schema/` + `graphify-out/graph.json`
- 例外：`vibe-trading` 的 `wiki/` 已是 HTML 文档站，LLM wiki 放在 `llm-wiki/`
- 例外：`LIB` 无可提取代码，写入空 `graph.json` stub

**大体量图谱（节点数）**
- Quant-Research ~85k · Fate ~76k · github ~63k · vibe-trading ~23k · zjuilearn / ai 亦已有图谱

## 2026-07-27 · Notion bridge 直连建页（needsAuth 回退）

**来源**
- AstrBot Agent 会话：插件仍 `needsAuth`，refresh OAuth 后 `_mcp_call` 成功 `notion-create-pages`
- `raw/notion-mcp/bridge-create-page-2026-07-27.md`

**新增 / 更新**
- `wiki/notion-mcp/03-bridge-create-page.md`
- `wiki/index.md`、`NOTION-MCP.md`、`skills/notion-mcp/SKILL.md`
- 镜像：`ai/AstrBot/wiki/notion-mcp/01-bridge-create-page-when-needsauth.md`

**要点**
- 写页前常需 `POST https://mcp.notion.com/token` refresh
- 参数用 `pages[].properties.title`，非顶层 `title`
- `notion_bridge` 默认仅 search/fetch；写操作需 `_mcp_call`

## 2026-07-26 · Notion MCP 连接知识库与 Skill 补齐

**来源**
- 本机验证：Cursor 插件 `notion-workspace` → `plugin-notion-workspace-notion`
- `raw/notion-mcp/research-notes.md`
- Fate：`feishuBot/notion_bridge.py`、`wiki/12-*.md`、`wiki/13-*.md`

**新增 / 更新**
- `NOTION-MCP.md`
- `wiki/notion-mcp/00-overview.md`、`01-auth-and-config.md`、`02-feishu-bridge.md`
- `skills/notion-mcp/SKILL.md`（同步至 `~\.cursor\skills` 与 `~\.agents\skills`）
- `wiki/index.md`、`wiki/log.md`
- `cursor-env-manifest.json`、`README.md`、`AGENTS.md`

**部署确认**
- 原先 cursorEnv 无独立 Notion MCP wiki/skill；本次补齐
- IDE 授权走 `mcp_auth`；飞书路径走 Fate bridge（CLI 不共享 IDE OAuth）

## 2026-07-15 · Serenity Bottleneck Hunter（mrjie7205）入库并全局部署

**来源**
- 上游：Mrjie7205/serenity-bottleneck-hunter
- `raw/serenity-bottleneck-hunter/research-notes.md`
- 本机：CLI → clone → 完整复制（35 文件）

**新增 / 更新**
- `SERENITY-BOTTLENECK-HUNTER.md`
- `wiki/serenity-bottleneck-hunter/00-overview.md`、`01-usage.md`
- `wiki/index.md`、`wiki/log.md`
- `cursor-env-manifest.json`、`README.md`、`AGENTS.md`

**部署确认**
- 全局技能：`serenity-bottleneck-hunter`（含 reference/scripts/tracking/agents）
- 整仓：`C:\Users\xwy12\Desktop\my-project\github\serenity-bottleneck-hunter`
- CLI 曾只装 SKILL.md；以手动完整复制为准
- 与 `serenity-skill`、`bottleneck-hunter` 目录不冲突

## 2026-07-15 · Bottleneck Hunter 调研入库并全局部署

**来源**
- 上游：xbtlin/ai-berkshire · `skills/bottleneck-hunter.md`
- `raw/bottleneck-hunter/research-notes.md`
- 本机：`npx skills add … --skill bottleneck-hunter -g` + clone 整仓

**新增 / 更新**
- `BOTTLENECK-HUNTER.md`
- `wiki/bottleneck-hunter/00-overview.md`、`01-usage.md`
- `wiki/index.md`、`wiki/log.md`
- `cursor-env-manifest.json`、`README.md`、`AGENTS.md`

**部署确认**
- 1 个全局技能：`bottleneck-hunter`（SKILL.md + LICENSE + RUNTIME.md）
- 整仓：`C:\Users\xwy12\Desktop\my-project\github\ai-berkshire`（含 `tools/`）
- clone 需 `http.sslBackend=openssl` + HTTP 代理
- 与 `serenity-skill` 目录不冲突

## 2026-07-15 · Serenity Skill 调研入库并全局部署

**来源**
- 上游：muxuuu/serenity-skill README / SKILL.md
- `raw/serenity/research-notes.md`
- 本机：clone → 完整复制到 `~\.agents\skills\serenity-skill` + `validate_skill.py`

**新增 / 更新**
- `SERENITY.md`
- `wiki/serenity/00-overview.md`、`01-usage.md`
- `wiki/index.md`、`wiki/log.md`
- `cursor-env-manifest.json`、`README.md`、`AGENTS.md`

**部署确认**
- 1 个全局技能：`serenity-skill`（含 references/assets/scripts，19 文件）
- 整仓：`C:\Users\xwy12\Desktop\my-project\github\serenity-skill`
- CLI `--copy` 本机曾只装 SKILL.md；以手动完整复制为准
- `-g` 同步：全部 Cursor 工作区共用

## 2026-07-15 · UZI Skill 调研入库并全局部署

**来源**
- 上游：wbh604/UZI-Skill README / AGENTS.md
- `raw/uzi/research-notes.md`
- 本机：clone → `npx skills add <local> -g -a cursor --copy -y --full-depth` + pip

**新增 / 更新**
- `UZI.md`
- `wiki/uzi/00-overview.md`、`01-usage.md`
- `wiki/index.md`、`wiki/log.md`
- `cursor-env-manifest.json`、`README.md`

**部署确认**
- 5 个全局技能：`uzi` / `deep-analysis` / `investor-panel` / `lhb-analyzer` / `trap-detector`
- 运行时：`C:\Users\xwy12\Desktop\my-project\github\UZI-Skill`
- `-g` 同步：headroom 列出的全部 Cursor 子项目共用，无需逐仓安装

## 2026-07-14 · Caveman 调研入库并本地部署

**来源**
- 上游：JuliusBrussee/caveman README
- `raw/caveman/research-notes.md`
- 本机安装：`npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y`

**新增 / 更新**
- `CAVEMAN.md`
- `wiki/caveman/00-overview.md`、`01-usage.md`
- `wiki/index.md`、`wiki/headroom/07-comparison.md`（纠正旧「会话摘要」误写）
- `cursor-env-manifest.json`、`README.md`

**部署确认**
- 安装前无 `cursorEnv/caveman/`、无同名 Cursor rules
- 装入 `~\.agents\skills\`：7 个技能（含 cavecrew）；不占 Headroom `:8787`

**图谱**
- `graphify update .`
- 查询：`graphify query "Caveman"`

## 2026-07-14 · Ponytail 调研入库并本地部署

**来源**
- 上游：DietrichGebert/ponytail README
- `raw/ponytail/research-notes.md`
- 本机安装：`npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y`

**新增 / 更新**
- `PONYTAIL.md`
- `wiki/ponytail/00-overview.md`、`01-usage.md`
- `wiki/index.md`、`wiki/headroom/07-comparison.md`
- `cursor-env-manifest.json`、`README.md`

**部署确认**
- 安装前无 `cursorEnv/ponytail/`、无同名 Cursor rules
- 装入 `~\.agents\skills\`：6 个技能；不占 Headroom `:8787`；未写入项目 `.cursor/rules/`

**图谱**
- `graphify update .`
- 查询：`graphify query "Ponytail"`

## 2026-07-03 · Headroom 配置入库（知识图谱首轮）

**来源**
- `HEADROOM.md`
- `headroom-projects.json` / `headroom-projects.resolved.json`
- `scripts/headroom-*.ps1`（5 个脚本）
- 会话调研：BYOK 要求、16 子项目映射、verify 脚本结论

**新增**
- `AGENTS.md`、`schema/page-template.md`
- `wiki/index.md`
- `wiki/headroom/00-overview.md` … `07-comparison.md`（8 页）
- `raw/headroom/HEADROOM-source.md`

**图谱**
- `graphify extract .` + `cluster-only` → **71 节点 · 68 边 · 21 社区**
- 查询：`graphify query "Headroom Cursor BYOK"`、`graphify query "Headroom 子项目 Base URL"`

**要点**
- Cursor 订阅模型不走 `127.0.0.1:8787`；LLM 压缩需 BYOK。
- 单代理 + `/p/{project}` 路由；切换子项目需 `headroom-switch-cursor-project.ps1`。
- 持久 Windows 服务未安装；使用 `headroom-start-proxy.ps1`。

**待办**
- 配置 BYOK 后复跑 `headroom-verify-cursor.ps1` 确认 `api_requests > 0`
- 语义提取（需 API Key）：`graphify extract . --backend openai --token-budget 20000`
