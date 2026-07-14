# Caveman × Ponytail 部署与使用指南

> Caveman：[JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) · [skills.sh](https://skills.sh/JuliusBrussee/caveman)  
> Ponytail：[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) · [skills.sh](https://skills.sh/DietrichGebert/ponytail)

本文档记录在 Windows + Cursor 下调研、冲突确认、全局安装与日常用法，便于新机器迁移。

---

## 一、定位对比

| | **Caveman** | **Ponytail** |
|---|---|---|
| 核心目标 | 压缩 **Agent 说话**（输出 token） | 压缩 **写出的代码量**（YAGNI） |
| 口号 | why use many token when few do trick | He says nothing. He writes one line. It works. |
| 典型收益 | 输出 token 约 −65%（官方 benchmark） | 代码行数约 −54%（agentic benchmark）；过建场景可到 94% |
| 不碰什么 | 代码 / 命令 / 错误原文保持精确 | 校验、安全、无障碍、数据丢失处理不砍 |
| 与 Headroom | 互补：Caveman=提示层口癖；Headroom=API/shell 载荷压缩 | 互补：Ponytail=少写代码；Headroom=少传 token |
| License | MIT | MIT |

**何时用谁**

| 场景 | 建议 |
|------|------|
| 回复太长、读起来慢 | `/caveman`（或 `talk like caveman`） |
| 怕 Agent 过度封装、乱加依赖 | `/ponytail`（或 `be lazy` / `yagni`） |
| 同时开两者 | 可用，但叠加收益有限；优先按任务二选一 |
| 已有 Headroom 代理 | 继续用；二者不占 8787 端口、不改 Base URL |

---

## 二、路径与冲突确认（本机已验证 · 2026-07-14）

| 检查项 | 结果 |
|--------|------|
| `cursorEnv/caveman`、`cursorEnv/ponytail` | **不存在**（未在仓库内克隆整仓） |
| `.cursor/rules/*caveman*` / `*ponytail*` | **不存在** |
| 安装前 `%USERPROFILE%\.agents\skills\` | 仅 34 个 mattpocock skills，**无** caveman/ponytail |
| 与 Headroom `127.0.0.1:8787` | **无冲突**（skills 为提示文件，非服务） |
| 与 Graphify / agency-agents | **无冲突**（不同目录、不同职责） |

安装目标目录：`%USERPROFILE%\.agents\skills\`（与 [MATTPOCOCK-SKILLS.md](./MATTPOCOCK-SKILLS.md) 同层，技能名不重叠）。

---

## 三、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | `npx skills@latest add … -g -a cursor --copy -y` |
| 安装范围 | 全局（global） |
| Agent | `cursor` |
| Caveman 技能数 | **7**（含 cavecrew） |
| Ponytail 技能数 | **6** |
| 安装目录 | `%USERPROFILE%\.agents\skills\` |

### 已安装技能清单

**Caveman**

| 技能 | 用途 |
|------|------|
| `caveman` | 简洁说话主技能；`lite` / `full` / `ultra` / `wenyan-*` |
| `caveman-commit` | 短 Conventional Commit |
| `caveman-review` | 一行式 PR 评论 |
| `caveman-compress` | 把记忆/规则文件压成 caveman 风格（约 −46% 输入） |
| `caveman-stats` | 会话 token 节约统计 |
| `caveman-help` | 帮助 |
| `cavecrew` | 压缩输出的子 agent（investigator/builder/reviewer） |

**Ponytail**

| 技能 | 用途 |
|------|------|
| `ponytail` | YAGNI 七级阶梯主技能；`lite` / `full` / `ultra` |
| `ponytail-review` | 审当前 diff，给出可删清单 |
| `ponytail-audit` | 审整仓过度工程 |
| `ponytail-debt` | 汇总 `ponytail:` 延期捷径 |
| `ponytail-gain` | 展示 benchmark 收益 |
| `ponytail-help` | 帮助 |

验证：

```powershell
npx skills@latest list -g --agent cursor --json
```

---

## 四、新机器安装

### 1) 前置

- Node.js LTS（`npx` 可用）
- Cursor 已安装

```powershell
node -v
npx -v
```

### 2) 安装（推荐全局 + copy）

```powershell
npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y
npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y
```

说明：`-g` 全局 · `--copy` 复制文件（迁移更稳）· `-a cursor` 仅装 Cursor · `-y` 非交互。

### 3) 可选：一键安装器（多 Agent）

仅当还要装 Claude Code / Gemini 等时使用：

```powershell
# Caveman 全 Agent
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
```

Ponytail 在 Cursor 上以 skills / rules 为主；本仓库采用与 mattpocock 一致的 `npx skills` 路径即可。

---

## 五、Cursor 日常用法

### Caveman

```text
/caveman
/caveman lite
/caveman ultra
talk like caveman
normal mode          # 或 stop caveman
```

- 代码块、命令、错误字符串 **不压缩**
- `wenyan`：文言文极简（会改语言风格）
- 诚实上限：只省 **输出** token；技能本身约 +1–1.5k 输入/轮，极简任务可能净负

### Ponytail

```text
/ponytail
/ponytail lite|full|ultra|off
/ponytail-review
/ponytail-audit
be lazy
yagni
normal mode          # 或 stop ponytail
```

**七级阶梯（停在第一档能撑住的）**

1. 要不要存在？（YAGNI）  
2. 仓库里已有？  
3. 标准库？  
4. 平台原生？（如 `<input type="date">`）  
5. 已装依赖？  
6. 一行？  
7. 否则：最小能用代码  

注意：Cursor 的 skills 路径以 **按需触发** 为主；说触发词或用 `/技能名` 即可。若需「每会话默认 always-on」，可另从上游拷 `.cursor/rules/` 规则文件（本部署未改项目规则，避免与 agency-agents / Karpathy 纠缠）。

---

## 六、与 cursorEnv 推荐栈关系

```text
Graphify query     → 少读文件、省探索 token
Headroom proxy/RTK → API / shell 载荷压缩
Caveman            → 回复更短（输出侧）
Ponytail           → 代码更少（实现侧）
mattpocock skills  → 工程流程（TDD / PRD / review）
wiki/              → 配置事实源
```

更新 `wiki/headroom/07-comparison.md` 时已纠正：Caveman ≠ 会话摘要工具；摘要/记忆见上游 [cavemem](https://github.com/JuliusBrussee/cavemem)。

---

## 七、卸载

```powershell
# 按技能名删除；或用 skills CLI remove（以当前 skills CLI 文档为准）
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\caveman*"
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\cavecrew"
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\ponytail*"
```

勿删整个 `.agents\skills\`，以免误删 mattpocock 等其它技能。

---

## 八、证据与来源

- 上游 README（2026-07 拉取）
- 本机安装日志：`npx skills@latest add …` → `~\.agents\skills\`
- 相关页：[MATTPOCOCK-SKILLS.md](./MATTPOCOCK-SKILLS.md)、[HEADROOM.md](./HEADROOM.md)、[wiki/index.md](./wiki/index.md)
