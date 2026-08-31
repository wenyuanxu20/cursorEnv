// ---------- 核心 Cursor 规则（本项目激活：项目级 + 全局）----------
const CORE_RULES = [
  {
    key: "llm-wiki-bootstrap",
    icon: "📚",
    title: "LLM Wiki 自动构建",
    file: "llm-wiki-bootstrap.mdc",
    scopes: ["项目", "全局"],
    always: true,
    desc: "中文知识库脚手架规则。命中触发词后立即创建 raw/、wiki/、schema/、AGENTS.md 等目录与模板，并执行首轮 ingest，保持幂等不覆盖已有内容。",
    trigger: "触发词：构建LLM wiki / 搭建LLM wiki / build llm wiki",
  },
  {
    key: "agency-agent-router-beginner",
    icon: "🧭",
    title: "Agency Agent 自动路由",
    file: "agency-agent-router-beginner.mdc",
    scopes: ["项目"],
    always: true,
    desc: "面向新手的 Agent 自动选择策略。未显式指定 @agent 时自动判断任务类型并在回答开头声明“主Agent / 备选 / 理由”；显式指定则手动优先。",
    trigger: "输出契约：主Agent: @name | 备选: @name | 理由: …",
  },
  {
    key: "cursor-rules-auto-backup",
    icon: "💾",
    title: "Cursor 规则自动备份",
    file: "cursor-rules-auto-backup.mdc",
    scopes: ["项目"],
    always: true,
    desc: "新建或更新任意 .cursor/rules/*.mdc 时，自动同步备份到中央目录 latest/，全局规则额外保存 --global 副本，并在 backup-log.md 追加记录。",
    trigger: "备份至：cursor-rules/latest/rules · docs · backup-log.md",
  },
  {
    key: "graphify",
    icon: "🕸️",
    title: "Graphify 图谱前置",
    file: "graphify.mdc",
    scopes: ["全局"],
    always: true,
    desc: "代码探索前置规则。使用 Read/Grep/Glob 探索代码库前必须先运行 graphify query/path/explain，借助知识图谱发现跨文件与推断依赖；改动后用 graphify update 保持同步。",
    trigger: "命令：graphify query / path / explain / update",
  },
  {
    key: "agentmemory-auto",
    icon: "🧠",
    title: "agentmemory 自动召回",
    file: "agentmemory-auto.mdc",
    scopes: ["项目", "全局"],
    always: true,
    desc: "任意工作区开场自动 memory_recall，有可复用结论时 memory_save；MCP 不可用则静默跳过。不需要口头说「记住 / 召回」。",
    trigger: "开场：memory_recall → 过薄再 smart_search → Notion 增量同步",
  },
  {
    key: "notion-agentmemory-sync",
    icon: "🔄",
    title: "Notion → 记忆同步",
    file: "notion-agentmemory-sync.mdc",
    scopes: ["项目", "全局"],
    always: true,
    desc: "recall 之后自动把已分享给 xwy-notion 的页面增量写入本机 agentmemory。缺 token 或服务未起则跳过。",
    trigger: "python …/notion-agentmemory-sync/scripts/sync.py",
  },
  {
    key: "cursor-git-rules",
    icon: "🔀",
    title: "GitHub 同步流程",
    file: "cursor-git-rules.mdc",
    scopes: ["项目"],
    always: true,
    desc: "用户明确要求 push / 建仓时按 Windows + 代理 + GCM 凭据流程执行；禁止 force push 与提交密钥。",
    trigger: "触发：push 到 git / 同步 GitHub / 创建仓库",
  },
  {
    key: "novel-wiki-bootstrap",
    icon: "📖",
    title: "小说 Wiki 脚手架",
    file: "novel-wiki-bootstrap.mdc",
    scopes: ["项目", "全局"],
    always: true,
    desc: "在小说工作区命中触发词后复制 wiki/novel 与 manuscript 模板，写入项目级连续性规则。agentmemory 只记铁律。",
    trigger: "触发词：构建小说wiki / 搭建小说知识库 / build novel wiki",
  },
  {
    key: "firecrawl-web-fetch",
    icon: "🔥",
    title: "Firecrawl + TrendRadar + Scrapling + agents-radar 联网取数",
    file: "firecrawl-web-fetch.mdc",
    scopes: ["项目", "全局"],
    always: true,
    desc: "要从网络取信息时：热榜走本机 TrendRadar，AI 生态日报走 agents-radar :3355，网页正文走本机 Firecrawl :3002，反爬或 Firecrawl 失败走本机已部署 Scrapling，不要先用 WebFetch。",
    trigger: "热榜 TrendRadar；日报 :3355/card；正文 firecrawl_scrape；反爬 Scrapling",
  },
];

// ---------- 环境工具文档（来自 cursor-env-manifest.json）----------
const TOOLS = [
  {
    name: "GRAPHIFY.md",
    title: "Graphify 代码知识图谱",
    necessity: "必要",
    desc: "代码知识图谱工具；全局 Cursor 规则要求 Agent 在探索代码前先运行 graphify，发现 grep 无法找到的跨文件依赖。",
    cmd: 'uv tool install "graphifyy[openai]" && graphify install --platform cursor',
  },
  {
    name: "FIRECRAWL.md",
    title: "Firecrawl 本机抓取",
    necessity: "必要",
    desc: "getInfo/ 自托管 Firecrawl API :3002。与 TrendRadar / Scrapling 共用联网规则：正文走 Firecrawl。",
    cmd: "powershell.exe -File .\\getInfo\\scripts\\start-firecrawl.ps1",
  },
  {
    name: "TRENDRADAR.md",
    title: "TrendRadar 本机热榜",
    necessity: "必要",
    desc: "getInfo/ 部署 TrendRadar MCP :3333。全局规则要求热榜/舆情优先 TrendRadar。",
    cmd: "powershell.exe -File .\\getInfo\\scripts\\start-trendradar.ps1",
  },
  {
    name: "SCRAPLING.md",
    title: "Scrapling 本机反爬抓取",
    necessity: "必要",
    desc: "getInfo/scrapling uv 钉选 0.4.15。全局规则：反爬或 Firecrawl 失败时走 Scrapling MCP。",
    cmd: "powershell.exe -File .\\getInfo\\scripts\\start-scrapling.ps1",
  },
  {
    name: "AGENTS-RADAR.md",
    title: "agents-radar 本机日报",
    necessity: "必要",
    desc: "getInfo/ 部署 agents-radar HTTP :3355。AI CLI / Agent 生态日报与 AstrBot /radar_bind 推送。",
    cmd: "powershell.exe -File .\\getInfo\\scripts\\start-agents-radar.ps1",
  },
  {
    name: "AGENTSVIEW.md",
    title: "AgentsView 会话浏览器",
    necessity: "必要",
    desc: "本地优先的 AI Agent 会话浏览器，自动发现并分析 Cursor 历史对话，支持全文搜索与分析面板，数据全部留在本机。",
    cmd: "pip install agentsview && agentsview serve --background",
  },
  {
    name: "KARPATHY.md",
    title: "Karpathy 编码风格规则",
    necessity: "必要",
    desc: "Andrej Karpathy 编码风格的项目级规则模板，按需在具体仓库部署 karpathy-guidelines.mdc，非全局依赖。",
    cmd: "复制 .cursor/rules/karpathy-guidelines.mdc 到目标项目",
  },
  {
    name: "karpathy-llm-wiki-knowledge-base-guide.md",
    title: "Karpathy LLM Wiki 知识库",
    necessity: "必要",
    desc: "raw/wiki/schema 三层知识库架构；全局规则支持中文触发「构建LLM wiki」一键脚手架，每个项目建议初始化。",
    cmd: "确认 llm-wiki-bootstrap.mdc 全局规则 → 在目标项目输入：构建LLM wiki",
  },
  {
    name: "agency-agents.md",
    title: "多 Agent 编排规则集",
    necessity: "必要",
    desc: "162 个专家 Agent 规则集的使用指南，建议仅启用 3 个常驻 + 按需调用，避免全部 alwaysApply 互相干扰。",
    cmd: "克隆 agency-agents 仓库并生成 .cursor/rules/*.mdc",
  },
  {
    name: "MATTPOCOCK-SKILLS.md",
    title: "Matt Pocock 工程化技能",
    necessity: "非必要",
    desc: "工程化 Agent Skills 增强包，支持 TDD / 排障 / PRD / Issue 流程，提升 Cursor 产研协作效率。",
    cmd: "npx skills@latest add mattpocock/skills -g --all --copy",
  },
  {
    name: "OKF.md",
    title: "Open Knowledge Format 调研",
    necessity: "参考",
    desc: "Google Cloud 开放知识格式规范调研；知识文档标准化参考，可与 manifest 互补用于知识组织。",
    cmd: "阅读参考，无需安装",
  },
  {
    name: "CAVEMAN.md",
    title: "Caveman 输出压缩",
    necessity: "见 manifest",
    desc: "压缩 Agent 输出口癖（约 −65% 输出 token），代码与命令保持精确。不占 Headroom 端口。",
    cmd: "npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y",
  },
  {
    name: "PONYTAIL.md",
    title: "Ponytail 最小实现",
    necessity: "见 manifest",
    desc: "YAGNI Skill：用最少代码解决问题，不砍安全与校验。",
    cmd: "npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y",
  },
  {
    name: "HEADROOM.md",
    title: "Headroom Token 压缩",
    necessity: "非必要",
    desc: "本地代理 + /p/{project} 路由压缩 Cursor 请求。订阅模型不走代理，需 BYOK。",
    cmd: "pip install headroom-ai[proxy] ；scripts/headroom-start-proxy.ps1",
  },
  {
    name: "NOTION-MCP.md",
    title: "Notion MCP 连接",
    necessity: "必要",
    desc: "插件 OAuth + PAT 兜底 + 飞书桥接。Token 只进用户环境变量 NOTION_TOKEN。",
    cmd: "启用 Notion Workspace 插件；mcp_auth 或 set-notion-token.ps1",
  },
  {
    name: "AGENTMEMORY.md",
    title: "agentmemory 持久记忆",
    necessity: "必要",
    desc: "本机 REST :3111 + MCP。开场自动 recall；决策自动 save；可读 Notion 页增量同步。记忆 blob 不入库。",
    cmd: "pwsh .\\scripts\\start-agentmemory.ps1",
  },
  {
    name: "NOVEL-WRITING.md",
    title: "长篇小说连续性",
    necessity: "非必要",
    desc: "wiki/novel 为设定真相，manuscript 为正文；agentmemory 只记铁律。新开小说仓说：构建小说wiki。",
    cmd: "触发词：构建小说wiki / 搭建小说知识库",
  },
  {
    name: "CURSOR-AGENT-API.md",
    title: "Cursor Agent API",
    necessity: "非必要",
    desc: "IDE 外调用 Cursor Agent：AstrBot 本地 proxy :18791 → agent CLI；Cloud REST Basic 鉴权；官方 SDK。实现在 sibling ai/。",
    cmd: "阅读 CURSOR-AGENT-API.md；实现见 ai/AstrBot/cursor-proxy",
  },
  {
    name: "UZI.md",
    title: "UZI 股票深度分析",
    necessity: "见 manifest",
    desc: "A/H/美股深度分析 Skill：数据维 × 机构模型 × 多投资人 persona。",
    cmd: "见 UZI.md（Quant-Research/UZI-Skill + 全局 skills）",
  },
  {
    name: "SERENITY.md",
    title: "Serenity 供应链瓶颈",
    necessity: "见 manifest",
    desc: "主题 → 价值链 → 稀缺约束 → 公开公司证据。",
    cmd: "见 SERENITY.md",
  },
  {
    name: "BOTTLENECK-HUNTER.md",
    title: "Bottleneck Hunter",
    necessity: "见 manifest",
    desc: "AI Berkshire 供应链瓶颈猎手，与 Serenity / UZI 互补。",
    cmd: "见 BOTTLENECK-HUNTER.md",
  },
  {
    name: "SERENITY-BOTTLENECK-HUNTER.md",
    title: "Serenity Bottleneck Hunter",
    necessity: "见 manifest",
    desc: "mrjie7205 完整包：9 原型、价格纪律、HTML 契约。源在 repos/。",
    cmd: "复制 repos/serenity-bottleneck-hunter 到 ~/.agents/skills/",
  },
];

// ---------- 渲染：核心规则 ----------
function scopeTag(s) {
  const cls = s === "全局" ? "scope-global" : "scope-project";
  return `<span class="tag ${cls}">${s}</span>`;
}
function renderCore() {
  const grid = document.getElementById("coreGrid");
  grid.innerHTML = CORE_RULES.map((r) => `
    <article class="core-card" data-key="${r.key}" tabindex="0" role="button" aria-label="查看 ${r.title} 完整原文">
      <div class="core-top">
        <span class="core-icon">${r.icon}</span>
        <div style="flex:1">
          <h3>${r.title}</h3>
          <div class="core-file"><code>${r.file}</code></div>
        </div>
      </div>
      <p>${r.desc}</p>
      <div class="core-trigger"><b>${r.trigger}</b></div>
      <div class="core-tags">
        ${r.scopes.map(scopeTag).join("")}
        ${r.always ? '<span class="tag always">alwaysApply</span>' : ""}
      </div>
      <div class="core-expand">展开完整 .mdc 原文 <span class="core-arrow">↗</span></div>
    </article>
  `).join("");

  grid.querySelectorAll(".core-card").forEach((card) => {
    const open = () => openRule(card.dataset.key);
    card.addEventListener("click", open);
    card.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") { e.preventDefault(); open(); }
    });
  });
}

// ---------- 规则原文弹窗 ----------
const RULES = window.RULES_SOURCE || {};
function openRule(key) {
  const rule = CORE_RULES.find((r) => r.key === key);
  const src = RULES[key] || "（未找到原文）";
  document.getElementById("modalTitle").textContent = rule ? rule.title : key;
  document.getElementById("modalFile").textContent = rule ? rule.file : "";
  document.querySelector("#modalBody code").textContent = src;
  const modal = document.getElementById("ruleModal");
  modal.hidden = false;
  document.body.classList.add("modal-open");
}
function closeRule() {
  document.getElementById("ruleModal").hidden = true;
  document.body.classList.remove("modal-open");
}
function initModal() {
  const modal = document.getElementById("ruleModal");
  modal.querySelectorAll("[data-close]").forEach((el) => el.addEventListener("click", closeRule));
  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && !modal.hidden) closeRule();
  });
}

// ---------- 风格切换 ----------
const THEMES = ["theme-library", "theme-pixel"];
const THEME_LABELS = { "theme-library": "极客像素风", "theme-pixel": "藏书阁风" };
function applyTheme(theme) {
  document.body.classList.remove(...THEMES);
  document.body.classList.add(theme);
  const btn = document.getElementById("themeToggle");
  if (btn) btn.title = "切换为" + THEME_LABELS[theme];
  try { localStorage.setItem("cursorenv-theme", theme); } catch (e) {}
}
function initTheme() {
  let saved = "theme-library";
  try { saved = localStorage.getItem("cursorenv-theme") || "theme-library"; } catch (e) {}
  if (!THEMES.includes(saved)) saved = "theme-library";
  applyTheme(saved);
  document.getElementById("themeToggle").addEventListener("click", () => {
    const current = document.body.classList.contains("theme-pixel") ? "theme-pixel" : "theme-library";
    applyTheme(current === "theme-library" ? "theme-pixel" : "theme-library");
  });
}

// ---------- 渲染：工具 ----------
function renderTools() {
  const grid = document.getElementById("toolsGrid");
  grid.innerHTML = TOOLS.map((t) => {
    const reqCls = t.necessity === "必要" ? "req" : "opt";
    return `
    <article class="tool-card">
      <div class="tool-head">
        <div>
          <h3>${t.title}</h3>
          <div class="tool-name">${t.name}</div>
        </div>
        <span class="necessity ${reqCls}">${t.necessity}</span>
      </div>
      <p>${t.desc}</p>
      <div class="tool-cmd">${t.cmd}</div>
    </article>`;
  }).join("");
}

// ---------- 渲染：Agent 目录 ----------
const DATA = window.AGENCY_DATA || {};
let allAgents = [];
let activeCat = "all";
let query = "";

function buildAgentIndex() {
  Object.entries(DATA).forEach(([key, group]) => {
    group.items.forEach((it) => {
      allAgents.push({
        name: it.name,
        desc: it.description || "（暂无描述）",
        always: it.alwaysApply,
        catKey: key,
        catLabel: group.label,
      });
    });
  });
}

function renderFilters() {
  const wrap = document.getElementById("filters");
  const chips = [`<button class="chip active" data-cat="all">全部 <span class="c-count">${allAgents.length}</span></button>`];
  Object.entries(DATA).forEach(([key, group]) => {
    chips.push(`<button class="chip" data-cat="${key}">${group.label} <span class="c-count">${group.count}</span></button>`);
  });
  wrap.innerHTML = chips.join("");
  wrap.querySelectorAll(".chip").forEach((btn) => {
    btn.addEventListener("click", () => {
      activeCat = btn.dataset.cat;
      wrap.querySelectorAll(".chip").forEach((b) => b.classList.remove("active"));
      btn.classList.add("active");
      renderCatalog();
    });
  });
}

function prettyName(n) {
  return n.replace(/-/g, " ").replace(/\b\w/g, (c) => c.toUpperCase());
}

function renderCatalog() {
  const grid = document.getElementById("catalogGrid");
  const empty = document.getElementById("emptyState");
  const count = document.getElementById("resultCount");
  const q = query.trim().toLowerCase();

  const filtered = allAgents.filter((a) => {
    const catOk = activeCat === "all" || a.catKey === activeCat;
    const qOk = !q || a.name.toLowerCase().includes(q) || a.desc.toLowerCase().includes(q);
    return catOk && qOk;
  });

  count.textContent = `共 ${filtered.length} 个 Agent`;
  empty.hidden = filtered.length !== 0;

  grid.innerHTML = filtered.map((a) => `
    <article class="agent-card">
      <div class="agent-top">
        <span class="agent-spine"></span>
        <div>
          <div class="agent-name">${prettyName(a.name)}</div>
          <div class="agent-cat">${a.catLabel}</div>
        </div>
      </div>
      <p class="agent-desc">${a.desc}</p>
      ${a.always ? '<span class="agent-badge">alwaysApply</span>' : ""}
    </article>
  `).join("");
}

// ---------- 统计 ----------
function renderStats() {
  document.getElementById("statRules").textContent = CORE_RULES.length;
  document.getElementById("statTools").textContent = TOOLS.length;
  document.getElementById("statAgents").textContent = allAgents.length;
  document.getElementById("statCats").textContent = Object.keys(DATA).length;
  const catTotal = document.getElementById("catTotal");
  if (catTotal) catTotal.textContent = allAgents.length;
}

// ---------- 初始化 ----------
document.addEventListener("DOMContentLoaded", () => {
  initTheme();
  renderCore();
  renderTools();
  buildAgentIndex();
  renderStats();
  renderFilters();
  renderCatalog();
  initModal();

  const search = document.getElementById("search");
  search.addEventListener("input", (e) => {
    query = e.target.value;
    renderCatalog();
  });
});
