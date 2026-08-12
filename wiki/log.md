# Wiki 变更日志

按时间倒序记录 ingest 与页面变更。

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
