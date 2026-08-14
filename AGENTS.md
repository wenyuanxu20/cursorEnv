# cursorEnv 知识库 Agent 规范

本仓库是 Cursor 开发环境配置中枢；知识库覆盖 **Graphify 图谱**、**Headroom Token 压缩**、**Agency Agents**、**Caveman / Ponytail / UZI / Serenity / Bottleneck Hunter / Serenity-Bottleneck-Hunter Skills**、**Notion MCP**、**agentmemory**、**Cloud Agent / AstrBot Cursor CLI**、**长篇小说连续性（novel-continuity）** 等工具链。

## 页面模板

每页至少包含：

1. **定义** — 该主题是什么
2. **关键结论** — 可执行要点（表格优先）
3. **证据与来源** — 指向 `raw/` 或仓库内文件路径
4. **相关页面** — wiki 双向链接

## 来源约束

- 配置类结论必须引用 `HEADROOM.md`、`headroom-projects.json` 或 `scripts/headroom-*.ps1`
- 区分「本机已验证事实」与「上游文档推断」

## 更新策略

1. 改 Headroom 脚本或 `headroom-projects.json` 后，同步更新 `wiki/headroom/` 相关页与 `wiki/log.md`
2. 改全局 skills（Caveman / Ponytail / UZI / Serenity / Bottleneck Hunter / Serenity-Bottleneck-Hunter / Notion MCP / Notion-agentmemory-sync / novel-continuity）部署后，同步 `wiki/{caveman,ponytail,uzi,serenity,bottleneck-hunter,serenity-bottleneck-hunter,notion-mcp,agentmemory,novel-writing}/` 与根目录对应 `*.md`
3. 改 agentmemory 版本、MCP、启动脚本或自动调用规则后，同步 `wiki/agentmemory/` 与根目录 `AGENTMEMORY.md`
4. 运行 `graphify update .` 刷新 `graphify-out/`（AST，无 API 成本）
5. 大量文档变更后运行 `graphify extract . --cluster-only` 全量重建

## 查询优先级

Agent 探索本仓库时：

1. `memory_recall`（全局规则 `agentmemory-auto.mdc`，会话开场自动；MCP：`user-agentmemory`）
2. `graphify query "<问题>"`（需 `graphify-out/graph.json`）
3. `wiki/index.md` → 主题页
4. 原始文件 `HEADROOM.md` / `GRAPHIFY.md` / `NOTION-MCP.md` / `AGENTMEMORY.md` / `CLOUD-AGENT.md` / `NOVEL-WRITING.md`

## 命名规范

- Headroom 主题页：`wiki/headroom/NN-*.md`（两位序号）
- Skill 主题页：`wiki/caveman/`、`wiki/ponytail/`、`wiki/uzi/`、`wiki/serenity/`、`wiki/bottleneck-hunter/`、`wiki/serenity-bottleneck-hunter/`、`wiki/notion-mcp/`、`wiki/novel-writing/`
- agentmemory 主题页：`wiki/agentmemory/NN-*.md`
- Cloud Agent 主题页：`wiki/cloud-agent/NN-*.md`
- 术语统一：Base URL、BYOK、RTK、path prefix `/p/{project}`、Notion 插件 MCP `plugin-notion-workspace-notion`、PAT 备用 MCP 配置键 `notion-token` / 运行时 id `user-notion-token`、环境变量 `NOTION_TOKEN`、agentmemory REST `:3111` / Viewer `:3113` / MCP 键 `agentmemory`、Skill `notion-agentmemory-sync`、Skill `novel-continuity`、触发词 `构建小说wiki`、Cursor CLI `agent`/`cursor-agent`、`CURSOR_API_KEY`、AstrBot ECS 独立 agentmemory store
- 介绍文档：仓库根 `README.md` 与 `cursor-env-manifest.json` 须覆盖当前工具链（含 agentmemory）；静态页 `web/index.html`
