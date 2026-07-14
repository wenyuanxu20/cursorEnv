# Wiki 变更日志

按时间倒序记录 ingest 与页面变更。

## 2026-07-14 · Caveman / Ponytail 调研入库并本地部署

**来源**
- 上游：JuliusBrussee/caveman、DietrichGebert/ponytail README
- `raw/caveman-ponytail/research-notes.md`
- 本机安装：`npx skills@latest add … -g -a cursor --copy -y`

**新增 / 更新**
- `CAVEMAN-PONYTAIL.md`（部署与使用）
- `wiki/caveman-ponytail/00-overview.md`、`01-usage.md`
- `wiki/index.md`、`wiki/headroom/07-comparison.md`（纠正 Caveman 误写为「会话摘要」）
- `cursor-env-manifest.json`、`README.md`

**部署确认**
- 安装前无 `cursorEnv/caveman|ponytail`、无同名 Cursor rules
- 装入 `~\.agents\skills\`：Caveman 7 + Ponytail 6；与 Headroom `:8787`、mattpocock skills **无冲突**

**图谱**
- `graphify update .` → 约 **4117 节点 · 4200 边 · 247 社区**
- 查询：`graphify query "Caveman Ponytail Headroom skills"`

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
