# cursorEnv 知识库 Agent 规范

本仓库是 Cursor 开发环境配置中枢；知识库覆盖 **Graphify 图谱**、**Headroom Token 压缩**、**Agency Agents**、**Caveman / Ponytail / UZI / Serenity / Bottleneck Hunter / Serenity-Bottleneck-Hunter Skills**、**Notion MCP**、**agentmemory**、**Firecrawl + TrendRadar + Scrapling + agents-radar 本机联网取数（getInfo）**、**System Informer（Windows 进程管理）**、**长篇小说连续性（novel-continuity）**、**Cursor Agent API（AstrBot proxy / Cloud REST / SDK）**、**my-project 跨项目 knowledge-hub 双写** 等工具链。

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
4. 改 Cursor Agent 程序化调用方式后，同步 `wiki/cursor-agent-api/` 与根目录 `CURSOR-AGENT-API.md`（实现仍在 sibling `ai/`，本仓只更新结论）
5. 改 Firecrawl / TrendRadar / Scrapling / agents-radar 自托管、MCP 或联网取数规则后，同步 `wiki/firecrawl/`、`wiki/trendradar/`、`wiki/scrapling/`、`wiki/agents-radar/` 与根目录 `FIRECRAWL.md`、`TRENDRADAR.md`、`SCRAPLING.md`、`AGENTS-RADAR.md`；改 AstrBot 桥接时同步 `wiki/cursor-agent-api/04-getinfo-bridge.md`
6. 改 System Informer 钉选版本、安装脚本或落盘路径后，同步 `wiki/systeminformer/` 与根目录 `SYSTEMINFORMER.md`
7. 运行 `graphify update .` 刷新 `graphify-out/`（AST，无 API 成本）
8. 大量文档变更后运行 `graphify extract . --cluster-only` 全量重建
9. 改 wiki / raw / schema / AGENTS / 小说 canon 后，同步到 `C:\Users\xwy12\Desktop\my-project\knowledge-hub`（`knowledge-hub/sync.ps1 -Project cursorEnv`）；跨项目总览见该目录 `INDEX.md`

## 查询优先级

Agent 探索本仓库时：

1. `memory_recall`（全局规则 `agentmemory-auto.mdc`，会话开场自动；MCP：`user-agentmemory`）
2. 需要从**网络**取信息时：热榜走本机 TrendRadar（全局 `firecrawl-web-fetch.mdc`；Cursor STDIO `getInfo/scripts/trendradar-mcp-stdio.py`；键 `trendradar`），AI CLI / Agent 日报走本机 agents-radar（`:3355`），具体 URL/正文走本机 Firecrawl（`getInfo/firecrawl/` API `:3002`；MCP：`user-firecrawl`），反爬或 Firecrawl 失败走**本机已部署 Scrapling**（`getInfo/scrapling/` 钉选 `0.4.15`；STDIO `scrapling-mcp.exe`；键 `scrapling` / `user-scrapling`），不要先走 WebFetch
3. `graphify query "<问题>"`（需 `graphify-out/graph.json`）
4. `wiki/index.md` → 主题页；跨项目总览 `C:\Users\xwy12\Desktop\my-project\knowledge-hub\INDEX.md`
5. 原始文件 `HEADROOM.md` / `GRAPHIFY.md` / `NOTION-MCP.md` / `AGENTMEMORY.md` / `FIRECRAWL.md` / `TRENDRADAR.md` / `SCRAPLING.md` / `AGENTS-RADAR.md` / `SYSTEMINFORMER.md` / `NOVEL-WRITING.md` / `CURSOR-AGENT-API.md`

## 命名规范

- Headroom 主题页：`wiki/headroom/NN-*.md`（两位序号）
- Skill 主题页：`wiki/caveman/`、`wiki/ponytail/`、`wiki/uzi/`、`wiki/serenity/`、`wiki/bottleneck-hunter/`、`wiki/serenity-bottleneck-hunter/`、`wiki/notion-mcp/`、`wiki/novel-writing/`
- agentmemory 主题页：`wiki/agentmemory/NN-*.md`
- Firecrawl 主题页：`wiki/firecrawl/NN-*.md`
- TrendRadar 主题页：`wiki/trendradar/NN-*.md`
- Scrapling 主题页：`wiki/scrapling/NN-*.md`
- agents-radar 主题页：`wiki/agents-radar/NN-*.md`
- System Informer 主题页：`wiki/systeminformer/NN-*.md`
- Cursor Agent API 主题页：`wiki/cursor-agent-api/NN-*.md`
- 术语统一：Base URL、BYOK、RTK、path prefix `/p/{project}`、Notion 插件 MCP `plugin-notion-workspace-notion`、PAT 备用 MCP 配置键 `notion-token` / 运行时 id `user-notion-token`、环境变量 `NOTION_TOKEN`、agentmemory REST `:3111` / Viewer `:3113` / MCP 键 `agentmemory`、Skill `notion-agentmemory-sync`、Skill `novel-continuity`、触发词 `构建小说wiki`、Cursor Agent CLI `agent`（非 `cursor.exe`）、AstrBot cursor-proxy `:18791`、OpenClaw cursor-brain `:18790`、Cloud REST `https://api.cursor.com` Basic `CURSOR_API_KEY:`、跨项目知识总览 `knowledge-hub`、双写脚本 `knowledge-hub/sync.ps1`、Firecrawl 自托管 API `:3002` / MCP 键 `firecrawl` / 运行时 id `user-firecrawl`、TrendRadar MCP `:3333` / 键 `trendradar` / 运行时 id `user-trendradar`、Scrapling 钉选 `0.4.15` / MCP 键 `scrapling` / 运行时 id `user-scrapling` / 部署根 `getInfo/`、agents-radar HTTP `:3355` / 插件 `astrbot_plugin_agents_radar` / `/radar_bind`、AstrBot getInfo 插件 `astrbot_plugin_getinfo` / 安装脚本 `getInfo/scripts/install-astrbot-getinfo.ps1`、System Informer 钉选 `v4.0.26241.138` / 便携目录 `tools/systeminformer/` / 安装脚本 `scripts/install-systeminformer.ps1`
- 介绍文档：仓库根 `README.md` 与 `cursor-env-manifest.json` 须覆盖当前工具链（含 agentmemory、Firecrawl、TrendRadar、Scrapling、agents-radar、System Informer）；静态页 `web/index.html`
