# Wiki 变更日志

按时间倒序记录 ingest 与页面变更。

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
