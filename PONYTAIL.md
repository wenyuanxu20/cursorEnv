# Ponytail 部署与使用指南

> 项目地址：[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) · 发现页：[skills.sh/DietrichGebert/ponytail](https://skills.sh/DietrichGebert/ponytail) · 官网：[ponytail.dev](https://ponytail.dev)

本文档记录在 Windows + Cursor 环境下，如何安装、验证和使用 Ponytail，并作为新机器迁移时的可复用说明。

---

## 一、定位说明

Ponytail 是面向 AI Coding Agent 的 **YAGNI / 最小实现 Skill**：

- 人格化「最懒的资深工程师」：先质疑要不要写，再写最少能用的代码
- Agentic benchmark（真实改仓）：平均约 **−54% LOC**、**−22% tokens**、**−20% cost**、**−27% 时间**；过建场景（如 date picker）可到约 **94%** 少代码
- **不砍**信任边界校验、防数据丢失的错误处理、安全措施、基础无障碍
- 支持 Claude Code、Codex、Copilot CLI、OpenCode、Gemini、Cursor 等十余种宿主

七级阶梯（停在第一档能撑住的）：

1. 要不要存在？（YAGNI）  
2. 本仓库是否已有？  
3. 标准库是否够用？  
4. 平台原生是否够用？（如 `<input type="date">`）  
5. 已装依赖是否够用？  
6. 能否一行？  
7. 否则：最小能工作的代码  

---

## 二、路径与冲突确认（本机已验证 · 2026-07-14）

| 检查项 | 结果 |
|--------|------|
| `cursorEnv/ponytail/` | **不存在**（未在仓库内克隆整仓） |
| `.cursor/rules/*ponytail*`（全局与项目） | **不存在** |
| 安装前 `~\.agents\skills\` 中 ponytail* | **不存在** |
| 与 Headroom `127.0.0.1:8787` | **无冲突**（纯技能文件，非服务） |
| 与 Graphify / agency-agents / 其它已装 skills | **无冲突**（技能名与目录均不重叠） |

安装目标：`%USERPROFILE%\.agents\skills\`

说明：本部署采用 **skills 路径**（与本仓库其它全局 skills 一致），**未**写入项目 `.cursor/rules/`，避免与现有 agency / Karpathy / graphify 规则纠缠。若需要「每会话默认 always-on」，可另从上游拷贝 `.cursor/rules/`（见下文可选步骤）。

---

## 三、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | `npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y` |
| 安装范围 | 全局（global） |
| Agent | `cursor` |
| 已安装数量 | **6** 个技能 |
| 安装目录 | `%USERPROFILE%\.agents\skills\` |

### 已安装技能

| 技能 | 用途 |
|------|------|
| `ponytail` | 主技能：YAGNI 阶梯；档位 `lite` / `full` / `ultra` |
| `ponytail-review` | 审当前 diff，给出可删清单 |
| `ponytail-audit` | 审整仓过度工程（不只看 diff） |
| `ponytail-debt` | 汇总代码里标记的 `ponytail:` 延期捷径 |
| `ponytail-gain` | 展示官方 benchmark 收益摘要 |
| `ponytail-help` | 命令速查 |

验证：

```powershell
npx skills@latest list -g --agent cursor --json
```

确认目录：

```powershell
Get-ChildItem "$env:USERPROFILE\.agents\skills" -Directory |
  Where-Object { $_.Name -like 'ponytail*' } |
  Select-Object Name
```

---

## 四、新机器安装步骤

### 1) 前置依赖

- Node.js（建议 LTS，确保 `npx` 可用）
- Cursor 已安装并可正常启动  
- Claude Code / Codex 插件若要用 lifecycle hooks，需保证 **非交互 shell 的 PATH** 上能找到 `node`

```powershell
node -v
npx -v
```

### 2) 安装（全局，仅 Cursor）

```powershell
npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y
```

说明：

- `-g`：全局安装，跨项目复用
- `-a cursor`：只装 Cursor 适配
- `--copy`：复制文件而非软链接，迁移更稳妥
- `-y`：非交互确认

### 3) 可选：Cursor always-on 规则

Skills 在 Cursor 上多为 **按需触发**。若希望每个会话默认带上 YAGNI 规则，可从上游仓库复制 `.cursor/rules/` 中的 ponytail 规则到：

- 全局：`%USERPROFILE%\.cursor\rules\`，或  
- 项目：`<repo>\.cursor\rules\`

本机当前 **未** 采用该可选步骤（避免与现有规则集冲突）。

### 4) 验证

```powershell
npx skills@latest list -g --agent cursor --json
```

列表中应出现 `ponytail`、`ponytail-review`、`ponytail-audit`、`ponytail-debt`、`ponytail-gain`、`ponytail-help`。

---

## 五、日常使用

### 开关与档位

```text
/ponytail                 # 默认 full
/ponytail lite
/ponytail full
/ponytail ultra
/ponytail off
be lazy / yagni / do less # 口语开启
normal mode               # 或 stop ponytail — 关闭
```

| 档位 | 效果 |
|------|------|
| `lite` | 按需求做，但用一句话点出更懒的替代方案，由你选 |
| `full`（默认） | 强制走阶梯；标准库/原生优先；最短 diff、最短说明 |
| `ultra` | 极端 YAGNI；先删再加；一行能搞定就一行，并当场质疑多余需求 |
| `off` | 关闭 |

可选默认档位：环境变量 `PONYTAIL_DEFAULT_MODE`，或 `%APPDATA%\ponytail\config.json` 的 `defaultMode`（`lite`/`full`/`ultra`/`off`）。

### 辅助技能

```text
/ponytail-review
/ponytail-audit
/ponytail-debt
/ponytail-gain
/ponytail-help
```

说明：完整 slash 命令能力依赖 skill-capable 宿主。Cursor 上主要靠 skill 触发 + 口语；审查类命令在 Cursor 中以对应 skill 名调用。

### 边界（务必知道）

- 管的是 **写什么代码**，不是 **怎么说话**
- 不简化：信任边界校验、防丢数据的错误处理、安全、基础 a11y、用户明确要求的完整版
- 用户坚持要完整实现 → 照做，不再抬杠
- 先读懂再爬阶梯；跳过理解的「小 diff」不算懒，是第二种 bug

---

## 六、运维命令

```powershell
# 列出全局 Cursor 技能
npx skills@latest list -g --agent cursor --json

# 更新全局技能
npx skills@latest update -g -y

# 仅卸载 Ponytail 相关（勿删整个 .agents\skills）
Remove-Item -Recurse -Force "$env:USERPROFILE\.agents\skills\ponytail*"
```

若曾启用 Claude Code 插件并留下配置态，可参考上游 `node scripts/uninstall.js`（需在移除插件 **之前** 从 checkout 运行）。

---

## 七、常见问题

### Q1: 安装成功但 Cursor 里看不到

1. 重启 Cursor  
2. 再跑 `npx skills@latest list -g --agent cursor --json`  
3. 会话里输入 `/ponytail` 或 `be lazy` / `yagni`

### Q2: 和 Headroom / 其它 skills 冲突吗？

不冲突。Ponytail 落在 `~\.agents\skills\ponytail*`；Headroom 用 `127.0.0.1:8787`；与其它已装技能名不重叠。

### Q3: 为什么默认不拷进 `.cursor/rules/`？

项目里已有 agency-agents、Karpathy、graphify 等规则。Skills 安装足够按需使用；always-on 规则留给明确需要时再加，避免规则互相抢上下文。

### Q4: 全局还是项目级？

- 全局：个人统一 YAGNI、跨项目复用（本机采用）  
- 项目级：团队希望跟仓库分发时再考虑

---

## 八、与本仓库清单的关系

本文件与 `cursor-env-manifest.json` 联动：

- 类别：`productivity-skills`（非基础依赖）
- 可按需安装，不影响 Cursor 基础使用
- Wiki：`wiki/ponytail/` · Raw：`raw/ponytail/`

---

*最后更新：2026-07-14 · Windows + Cursor*
