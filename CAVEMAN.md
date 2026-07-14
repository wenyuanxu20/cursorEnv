# Caveman 部署与使用指南

> 项目地址：[JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) · 发现页：[skills.sh/JuliusBrussee/caveman](https://skills.sh/JuliusBrussee/caveman) · 官网：[caveman.so](https://caveman.so)

本文档记录在 Windows + Cursor 环境下，如何安装、验证和使用 Caveman，并作为新机器迁移时的可复用说明。

---

## 一、定位说明

Caveman 是面向 AI Coding Agent 的 **输出压缩 Skill/Plugin**：

- 让 Agent 用极简「caveman」口癖回复，去掉客套与填充词
- 官方 benchmark：输出 token 平均约 **−65%**（范围约 22–87%）
- **不改写**代码块、命令、错误原文；压缩的是表述风格，不是技术内容
- 支持 Claude Code、Codex、Gemini、Cursor、Windsurf、Cline、Copilot 等 30+ Agent

与同作者生态（本仓库当前只部署本 skill，不强制安装）：

| 仓库 | 压缩对象 |
|------|----------|
| **caveman**（本页） | Agent **说什么** |
| caveman-code | 整条 Agent 链路 |
| cavemem | Agent **记住什么** |
| cavekit | 构建循环（spec-driven） |

---

## 二、路径与冲突确认（本机已验证 · 2026-07-14）

| 检查项 | 结果 |
|--------|------|
| `cursorEnv/caveman/` | **不存在**（未在仓库内克隆整仓） |
| `.cursor/rules/*caveman*`（全局与项目） | **不存在** |
| 安装前 `~\.agents\skills\` 中 caveman* / cavecrew | **不存在** |
| 与 Headroom `127.0.0.1:8787` | **无冲突**（纯技能文件，非服务） |
| 与 Graphify / agency-agents / mattpocock skills | **无冲突**（技能名与目录均不重叠） |

安装目标：`%USERPROFILE%\.agents\skills\`

---

## 三、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | `npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y` |
| 安装范围 | 全局（global） |
| Agent | `cursor` |
| 已安装数量 | **7** 个技能 |
| 安装目录 | `%USERPROFILE%\.agents\skills\` |

### 已安装技能

| 技能 | 用途 |
|------|------|
| `caveman` | 主技能：简洁口癖；档位 `lite` / `full` / `ultra` / `wenyan-*` |
| `caveman-commit` | Conventional Commit，短 subject，偏 why |
| `caveman-review` | 一行式 PR 评论（含行号与严重度） |
| `caveman-compress` | 将记忆/规则文件改写为 caveman 风格，约 −46% 后续输入 |
| `caveman-stats` | 会话/累计节约统计 |
| `caveman-help` | 帮助 |
| `cavecrew` | 压缩输出的子 agent（investigator / builder / reviewer） |

验证：

```powershell
npx skills@latest list -g --agent cursor --json
```

确认目录：

```powershell
Get-ChildItem "$env:USERPROFILE\.agents\skills" -Directory |
  Where-Object { $_.Name -match '^(caveman|cavecrew)' } |
  Select-Object Name
```

---

## 四、新机器安装步骤

### 1) 前置依赖

- Node.js（建议 LTS，确保 `npx` 可用）
- Cursor 已安装并可正常启动

```powershell
node -v
npx -v
```

### 2) 安装（全局，仅 Cursor）

```powershell
npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y
```

说明：

- `-g`：全局安装，跨项目复用
- `-a cursor`：只装 Cursor 适配
- `--copy`：复制文件而非软链接，迁移更稳妥
- `-y`：非交互确认

### 3) 可选：多 Agent 一键安装

若同时需要 Claude Code / Gemini / Copilot 等：

```powershell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
```

### 4) 验证

```powershell
npx skills@latest list -g --agent cursor --json
```

列表中应出现 `caveman`、`caveman-commit`、`caveman-review`、`caveman-compress`、`caveman-stats`、`caveman-help`、`cavecrew`。

---

## 五、日常使用

### 开关与档位

```text
/caveman              # 默认 full
/caveman lite
/caveman full
/caveman ultra
talk like caveman     # 口语开启
normal mode           # 或 stop caveman — 关闭
```

| 档位 | 效果 |
|------|------|
| `lite` | 去掉填充/客套，保留完整句子 |
| `full`（默认） | 去冠词、可用碎片句、短同义词 |
| `ultra` | 极致压缩，一词能说清则一词 |
| `wenyan-*` | 文言文风格；会改变语言形态 |

### 辅助技能

```text
/caveman-commit
/caveman-review
/caveman-compress <filepath>
/caveman-stats
/caveman-help
```

### 边界（务必知道）

- **只压缩输出表述**；input / reasoning token 不动
- 技能本身大约增加 **1–1.5k 输入 token/轮**；任务本身已经很短时，可能净不省
- 安全警告、不可逆确认、易歧义的多步说明：应暂时退出 caveman 口癖，说清楚后再恢复

---

## 六、运维命令

```powershell
# 列出全局 Cursor 技能
npx skills@latest list -g --agent cursor --json

# 更新全局技能
npx skills@latest update -g -y

# 仅卸载 Caveman 相关（勿删整个 .agents\skills）
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\caveman*"
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\cavecrew"
```

---

## 七、常见问题

### Q1: 安装成功但 Cursor 里看不到

1. 重启 Cursor  
2. 再跑 `npx skills@latest list -g --agent cursor --json`  
3. 会话里直接输入 `/caveman` 或 `talk like caveman`

### Q2: 和 Headroom 会不会抢端口 / Base URL？

不会。Caveman 是 `~\.agents\skills\` 下的提示技能；Headroom 是本地代理 `127.0.0.1:8787`。可并存。

### Q3: 全局还是项目级？

- 全局：个人统一口癖、跨项目复用（本机采用）  
- 项目级：团队希望跟仓库分发时再考虑

---

## 八、与本仓库清单的关系

本文件与 `cursor-env-manifest.json` 联动：

- 类别：`productivity-skills`（非基础依赖）
- 可按需安装，不影响 Cursor 基础使用
- Wiki：`wiki/caveman/` · Raw：`raw/caveman/`

---

*最后更新：2026-07-14 · Windows + Cursor*
