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
    necessity: "非必要",
    desc: "Google Cloud 开放知识格式规范调研；知识文档标准化参考，可与 manifest 互补用于知识组织。",
    cmd: "阅读参考，无需安装",
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
