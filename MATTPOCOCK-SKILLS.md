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

## 六、运维命令

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

## 七、常见问题

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

## 八、与本仓库清单的关系

本文件与 `cursor-env-manifest.json` 联动，用于迁移时快速识别：

- 该项为 Cursor 能力增强配置（非基础依赖）
- 可按需安装，不影响 Cursor 基础使用

---

*最后更新：2026-06-24 · Windows + Cursor*
