# Matt Pocock Skills 部署与使用指南

> 项目地址：[mattpocock/skills](https://github.com/mattpocock/skills) · 文档入口：[README](https://github.com/mattpocock/skills/blob/main/README.md) · 发现页：[skills.sh](https://skills.sh/mattpocock/skills)

本文档记录在 Windows + Cursor 环境下，如何安装、验证和使用 `mattpocock/skills`，并作为新机器迁移时的可复用说明。

---

## 一、定位说明

`mattpocock/skills` 是一组面向真实工程实践的 Agent Skills，特点是：

- 小而可组合（composable）
- 同时支持用户触发与模型自动触发技能
- 偏重工程流程（TDD、排障、架构、PRD/Issue 流程）而非一次性“生成代码”

---

## 二、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | `npx skills@latest add mattpocock/skills -g --all --copy` |
| 安装范围 | 全局（global） |
| Agent | `cursor` |
| 已安装数量 | 34 个技能 |
| 安装目录 | `%USERPROFILE%\\.agents\\skills\\` |

验证命令：

```powershell
npx skills@latest list -g --agent cursor --json
```

统计数量：

```powershell
($json = npx skills@latest list -g --agent cursor --json | Out-String | ConvertFrom-Json).Count
```

---

## 三、新机器安装步骤

### 1) 前置依赖

- Node.js（建议 LTS，确保 `npx` 可用）
- Cursor 已安装并可正常启动

检查：

```powershell
node -v
npx -v
```

### 2) 安装技能包（全局）

```powershell
npx skills@latest add mattpocock/skills -g --all --copy
```

说明：

- `-g`：全局安装，便于多个项目复用
- `--all`：安装该仓库全部技能
- `--copy`：复制文件而非软链接，迁移更稳妥

### 3) 验证安装

```powershell
npx skills@latest list -g --agent cursor --json
```

如返回技能列表即安装成功。

---

## 四、首次启用（关键）

安装后，建议在 Cursor 中先运行：

```text
/setup-matt-pocock-skills
```

该命令会引导你配置：

1. issue tracker（GitHub / Linear / local files）
2. triage 标签体系
3. 文档保存位置（如 PRD、ADR、上下文文档）

未完成这一步时，部分工程工作流技能无法发挥完整效果。

---

## 五、推荐常用技能

| 技能 | 用途 |
|------|------|
| `/grill-with-docs` | 在实现前做需求澄清，并同步沉淀文档 |
| `/tdd` | 红绿重构循环，降低回归风险 |
| `/diagnosing-bugs` | 结构化排障流程 |
| `/to-prd` | 将当前对话沉淀为 PRD |
| `/to-issues` | 将 PRD/计划拆成可独立领取的问题 |
| `/triage` | 问题分诊与状态流转 |
| `/improve-codebase-architecture` | 定期扫描并改进代码架构 |

---

## 六、全部 skills 清单（34）

> 说明：以下命令名与 `npx skills@latest list -g --agent cursor --json` 的安装结果一致。

| 技能 | 用途（简述） |
|------|--------------|
| `/ask-matt` | 技能路由器：帮助选择当前最合适的工作流技能 |
| `/codebase-design` | 用深模块思路做接口与模块边界设计 |
| `/decision-mapping` | 将模糊想法拆成可执行的决策与调查路径 |
| `/design-an-interface` | 并行探索多个接口设计方案并比较取舍 |
| `/diagnosing-bugs` | 结构化排障循环：复现→假设→验证→修复 |
| `/domain-modeling` | 建立与迭代领域术语/上下文模型 |
| `/edit-article` | 编辑和重构文章，提高可读性与结构性 |
| `/git-guardrails-claude-code` | 给 Claude Code 配置危险 Git 操作防护 |
| `/grill-me` | 通过高密度提问澄清方案与边界 |
| `/grill-with-docs` | 澄清需求并同步沉淀文档（PRD/ADR/术语等） |
| `/grilling` | 通用“深挖式提问”能力（`grill-me` 的底层循环） |
| `/handoff` | 把当前上下文压缩成交接文档给下一个 agent |
| `/implement` | 按 PRD/Issue 执行实现落地 |
| `/improve-codebase-architecture` | 扫描代码库并提出架构改进机会 |
| `/migrate-to-shoehorn` | 将测试中的 `as` 断言迁移到 shoehorn |
| `/obsidian-vault` | 在 Obsidian 知识库中搜索/组织笔记 |
| `/prototype` | 快速构建可运行原型验证设计 |
| `/qa` | 交互式 QA 会话，记录问题并沉淀 issue |
| `/request-refactor-plan` | 通过访谈生成“可小步提交”的重构计划 |
| `/resolving-merge-conflicts` | 处理 merge/rebase 冲突并保证可继续开发 |
| `/review` | 对照规范与需求做并行评审 |
| `/scaffold-exercises` | 批量生成练习目录、题目与解答骨架 |
| `/setup-matt-pocock-skills` | 初始化 Matt 技能配置（tracker/标签/文档布局） |
| `/setup-pre-commit` | 配置 Husky + lint-staged + 提交前校验 |
| `/tdd` | 红绿重构测试驱动开发流程 |
| `/teach` | 多轮教学模式，围绕目标逐步训练 |
| `/to-issues` | 把计划/PRD 拆分成可独立领取的 issue |
| `/to-prd` | 将当前讨论沉淀为 PRD |
| `/triage` | issue 分诊与状态流转 |
| `/ubiquitous-language` | 抽取并维护项目统一术语（DDD） |
| `/writing-beats` | 用“节拍式结构”组织文章叙事路径 |
| `/writing-fragments` | 先收集碎片化观点，再组织成文 |
| `/writing-great-skills` | 编写高质量技能文档的方法论 |
| `/writing-shape` | 将素材逐步塑形成可发布文章 |

---

## 七、运维命令

```powershell
# 列出全局技能
npx skills@latest list -g --agent cursor --json

# 更新全局技能
npx skills@latest update -g -y

# 移除全局技能
npx skills@latest remove -g --all

# 查看仓库可安装技能列表（不安装）
npx skills@latest add mattpocock/skills -l --full-depth
```

---

## 八、常见问题

### Q1: 提示 `Invalid agents: cursor-cli`

请使用 `cursor`，而非 `cursor-cli`：

```powershell
npx skills@latest list -g --agent cursor --json
```

### Q2: 安装成功但 Cursor 中不可用

1. 重启 Cursor
2. 再次执行 `npx skills@latest list -g --agent cursor --json` 确认已安装
3. 在会话中手动输入 `/setup-matt-pocock-skills`

### Q3: 全局安装与项目安装怎么选

- 全局：个人工作流统一、跨项目复用（推荐）
- 项目级：团队希望跟随仓库分发时可考虑

---

## 九、与本仓库清单的关系

本文件与 `cursor-env-manifest.json` 联动，用于迁移时快速识别：

- 该项为 Cursor 能力增强配置（非基础依赖）
- 可按需安装，不影响 Cursor 基础使用

---

*最后更新：2026-06-24 · Windows + Cursor*
