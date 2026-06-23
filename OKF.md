# Open Knowledge Format (OKF) 调研总结

> 官方资源：[SPEC.md](https://github.com/GoogleCloudPlatform/knowledge-catalog/blob/main/okf/SPEC.md) · [GitHub 仓库](https://github.com/GoogleCloudPlatform/knowledge-catalog) · [Google Cloud 公告](https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing)

**OKF**（Open Knowledge Format，开放知识格式）由 **Google Cloud** 于 2026 年 5 月发布，当前版本 **v0.1 Draft**。它将「LLM Wiki」模式标准化为可交换、厂商中立的知识表示格式，供 AI Agent 与人类共同读写。

---

## 一、背景与定位

AI Agent 需要上下文知识（元数据、文档、runbook、指标定义等），但各工具各自为政：

- Cursor 使用 `.mdc` 规则 + 项目 Markdown
- Obsidian / Notion 使用 Markdown 笔记
- 数据目录（Dataplex、Unity Catalog 等）使用专有格式

OKF 的目标：把这些模式统一为**开放标准**，实现跨工具、跨组织的知识交换，且可用 Git 管理。

核心原则：

| 原则 | 说明 |
|------|------|
| 格式，非平台 | 不绑定云、数据库、模型或 Agent 框架 |
| 人类 + Agent 友好 | 纯 Markdown + YAML frontmatter |
| 最小约束 | **唯一必填字段：`type`** |
| 宽松消费 | 缺字段、未知 type、断链都不应导致拒绝解析 |
| Git 原生 | 可 diff、可版本控制、可 clone 分发 |

一句话概括：**「Markdown 文件 + YAML 头 + 目录结构 + 交叉链接」的互操作规范。**

---

## 二、核心概念

| 术语 | 含义 |
|------|------|
| **Knowledge Bundle** | 自包含的知识文档集合，是分发与版本管理的基本单位 |
| **Concept** | 单个知识单元，对应一个 `.md` 文件 |
| **Concept ID** | 文件在 bundle 内的路径（去掉 `.md` 后缀），如 `tables/users` |
| **Frontmatter** | 文件顶部 `---` 包裹的 YAML 元数据 |
| **Body** | frontmatter 之后的 Markdown 正文 |
| **Link** | 概念之间的 Markdown 链接，表达关系 |
| **Citation** | 指向外部来源的引用链接 |

---

## 三、Bundle 目录结构

```
bundle/
├── index.md              # 可选，目录索引（progressive disclosure）
├── log.md                # 可选，变更日志
├── concept-a.md          # 知识单元
└── subdir/
    ├── index.md
    └── concept-b.md
```

**保留文件名**（不可用作 Concept 文档）：

| 文件名 | 用途 |
|--------|------|
| `index.md` | 目录列表，支持渐进式浏览 |
| `log.md` | 按日期分组的变更历史 |

Bundle 可分发为：Git 仓库（推荐）、tarball/zip、或更大仓库的子目录。

---

## 四、Concept 文档格式

### 4.1 Frontmatter

```yaml
---
type: <Type name>                  # 必填
title: <Optional display name>
description: <Optional one-line summary>
resource: <Optional canonical URI>
tags: [<tag>, <tag>, …]
timestamp: <ISO 8601 datetime>
# … 其他 producer 自定义字段
---
```

- **`type`**（必填）：概念类型，如 `BigQuery Table`、`Playbook`、`API Endpoint`。无中央注册表，消费者须容忍未知 type。
- **`title`**（推荐）：人类可读标题；缺省时可从文件名推导。
- **`description`**（推荐）：单行摘要，用于索引与搜索预览。
- **`resource`**（推荐）：底层资产 URI；抽象概念可省略。
- **`tags`**（可选）：跨目录标签。
- **`timestamp`**（可选）：ISO 8601 最后修改时间。
- **扩展字段**：生产者可自由添加；消费者应保留未知字段。

### 4.2 Body 约定章节

| 标题 | 用途 |
|------|------|
| `# Schema` | 结构化字段/列描述 |
| `# Examples` | 用法示例（常为代码块） |
| `# Citations` | 外部来源引用 |

### 4.3 完整示例

```markdown
---
type: Playbook
title: Cursor 环境迁移
description: 新机器一键部署 Cursor 开发环境
tags: [cursor, migration, devops]
timestamp: 2026-06-23T00:00:00Z
---

# Steps

1. 安装 [Graphify](/tools/graphify.md)
2. 配置 PATH 与 API Key
3. 验证 `graphify --version`

# Citations

[1] [Graphify 官方文档](https://graphify.net/zh/)
```

---

## 五、交叉链接规则

两种链接形式：

```markdown
# 推荐：bundle 根相对路径（移动文件时更稳定）
See [customers table](/tables/customers.md).

# 相对路径
See [neighbor](./other.md).
```

- 链接语义由上下文 prose 表达，链接本身不携带类型。
- 消费者**必须**容忍断链（目标尚未编写的情况）。

---

## 六、Index 与 Log

### index.md

无 frontmatter，用 Markdown 列表枚举目录内容：

```markdown
# Tools

* [Graphify](tools/graphify.md) - 代码知识图谱，Cursor 全局规则依赖
* [AgentsView](tools/agentsview.md) - 本地 Agent 会话浏览器
```

### log.md

按日期倒序记录变更（日期格式 `YYYY-MM-DD`）：

```markdown
# Directory Update Log

## 2026-06-23
* **Creation**: 添加 [OKF 调研总结](/OKF.md)
* **Update**: 更新 [环境清单](/cursor-env-manifest.json)
```

---

## 七、合规性（Conformance）

OKF v0.1 合规 bundle 须满足：

1. 每个非保留 `.md` 文件有可解析的 YAML frontmatter
2. frontmatter 含非空 `type` 字段
3. 保留文件名遵循规范（若存在）

消费者**不应**因以下原因拒绝 bundle：缺可选字段、未知 type、未知扩展键、断链、缺 index.md。

---

## 八、生态与工具

Google 在 [knowledge-catalog](https://github.com/GoogleCloudPlatform/knowledge-catalog) 提供参考实现：

| 工具 | 作用 |
|------|------|
| **Enrichment Agent** | 从 BigQuery 等数据源自动生成 OKF 文档 |
| **Visualizer** | 将 bundle 渲染为独立 HTML 知识图谱（单文件，无后端） |
| **Knowledge Catalog** | Google Cloud 产品已支持 OKF 导入与服务 |

示例 bundle：GA4 电商、Stack Overflow、Bitcoin 公开数据集。

本地探索：

```powershell
git clone https://github.com/GoogleCloudPlatform/knowledge-catalog.git
cd knowledge-catalog/okf
# 详见仓库 README 中的 visualize 子命令
```

---

## 九、与其他格式的关系

OKF 接近但不等同于：

- **LLM Wiki 仓库** — Markdown + frontmatter 作为 Agent 知识库
- **Obsidian / Notion** — 层级 Markdown + 交叉链接
- **Metadata as Code** — 元数据与源码同仓管理

差异：OKF 是**有规范文档**的互操作标准，只约束结构，不约束工具链。

**非目标**：不替代 Avro、Protobuf、OpenAPI 等领域 schema；OKF 仅引用它们。

---

## 十、与本仓库 cursorEnv 的对比

当前结构：

```
cursorEnv/
├── GRAPHIFY.md
├── AGENTSVIEW.md
├── KARPATHY.md
├── agency-agents.md
├── cursor-env-manifest.json   # 机器可读部署清单
└── OKF.md                     # 本文档
```

| 维度 | 当前方案 | OKF |
|------|----------|-----|
| 人类阅读 | ✅ 纯 MD | ✅ 纯 MD |
| Agent 消费 | ⚠️ 需自定义 JSON manifest | ✅ 标准 frontmatter + 链接 |
| 必要/非必要标记 | ✅ JSON `necessity` 字段 | ⚠️ 需自定义 frontmatter 扩展 |
| 部署命令 | ✅ `quick_deploy` 数组 | ⚠️ 需写在 body 或自定义字段 |
| 跨工具互操作 | ❌ 私有 schema | ✅ 开放规范 |
| 成熟度 | 已可用 | v0.1 Draft，仍在演进 |

**结论**：`cursor-env-manifest.json` 更适合**一键部署脚本**；OKF 更适合**知识文档的标准化组织与 Agent 检索**。两者互补，非互斥。

---

## 十一、若改造为 OKF 兼容结构的示例

```
cursorEnv/
├── index.md
├── log.md
├── tools/
│   ├── index.md
│   ├── graphify.md          # type: DevTool, necessity: 必要
│   └── agentsview.md        # type: DevTool, necessity: 非必要
├── rules/
│   ├── karpathy.md          # type: CursorRule
│   └── agency-agents.md     # type: CursorRule
└── deploy/
    └── manifest.json        # 保留，供脚本读取
```

`tools/graphify.md` frontmatter 示例：

```yaml
---
type: DevTool
title: Graphify
description: 代码知识图谱，Cursor 全局规则依赖
necessity: 必要
category: cursor-core
install_method: uv tool install "graphifyy[openai]"
tags: [cursor, graphify, necessary]
---
```

`necessity` 非 OKF 标准字段，但规范允许任意扩展 frontmatter，消费端（部署脚本）自行识别即可。

---

## 十二、优劣评估

### 优势

- 与 Cursor Rules、Obsidian、静态站点天然兼容
- Agent 可直接 Read MD，无需专有 SDK
- Git diff 友好，适合团队协作
- Google 背书，未来可能与更多 Agent 平台互通

### 局限

- 仅 v0.1，规范可能变化
- 无内置「部署/安装」语义，需自定义扩展字段
- 无 schema 注册中心，`type` 值需自行约定
- 与 Cursor 的 `.mdc` 规则格式不同，不能直接替代

---

## 十三、采用建议

| 场景 | 建议 |
|------|------|
| 仅做 Cursor 环境迁移 | 保持现有方案（MD + `cursor-env-manifest.json`） |
| 希望 Agent 自动理解环境配置 | 给 MD 加 OKF frontmatter（`type`、`tags`、`necessity`） |
| 希望与 Google Cloud / 数据目录互通 | 考虑完整 OKF bundle 结构 |
| 一键部署脚本 | JSON manifest 比纯 OKF 更直接，建议保留 |

---

## 十四、版本与演进

- 当前规范：**OKF v0.1**
- 版本号形式：`major.minor`
  - **minor**：向后兼容的新增（可选字段、新约定章节）
  - **major**：可能破坏性变更
- Bundle 可在根 `index.md` frontmatter 声明 `okf_version: "0.1"`
- Google 明确表示 v0.1 是起点，欢迎社区贡献与替代实现

---

## 相关文档

- [GRAPHIFY.md](./GRAPHIFY.md) — 代码知识图谱
- [AGENTSVIEW.md](./AGENTSVIEW.md) — Agent 会话浏览器
- [cursor-env-manifest.json](./cursor-env-manifest.json) — 环境配置清单

---

*最后更新：2026-06-23 · OKF 规范 v0.1 Draft*
