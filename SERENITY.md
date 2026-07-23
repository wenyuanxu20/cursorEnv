# Serenity Skill 部署与使用指南

> 项目地址：[muxuuu/serenity-skill](https://github.com/muxuuu/serenity-skill) · 发现页：[skills.sh/muxuuu/serenity-skill](https://skills.sh/muxuuu/serenity-skill) · License: MIT

本文档记录在 Windows + Cursor 环境下，如何安装、验证和使用 Serenity（供应链瓶颈猎人 Skill），并作为新机器迁移时的可复用说明。

---

## 一、定位说明

Serenity.skill 把投资研究 Agent 变成 **供应链卡点猎人**：

- 从市场叙事 → 系统变化 → 价值链分层 → **稀缺约束层** → 上市公司证据 → 证伪条件
- 适合 AI 基建、半导体、CPO、先进封装、电力设备、机器人、材料/检测等重供应链主题
- 支持美股 / 港股 / A 股 / 台日韩欧等跨市场候选发现；本地可用标准库 Python scorecard

与本仓库其它技能关系：

| 工具 | 关系 |
|------|------|
| UZI | 互补：UZI 偏个股全量建模；Serenity 偏主题→卡点→研究优先级 |
| Caveman / Ponytail | 无冲突（口癖 / YAGNI，非投研方法论） |
| Headroom `:8787` | 无冲突（纯技能文件，不占端口） |

**边界**：研究方法论与公开证据支持；**无**券商接入、钱包、下单执行。输出不是投资建议。

---

## 二、路径与冲突确认（本机已验证 · 2026-07-15）

| 检查项 | 结果 |
|--------|------|
| `cursorEnv/serenity-skill/` | **不存在**（整仓放在 `github/serenity-skill`） |
| 安装前 `~\.agents\skills\serenity-skill` | **不存在** |
| 与 Headroom `127.0.0.1:8787` | **无冲突** |
| 与已装 uzi / caveman / ponytail | **无冲突**（目录名不重叠） |

| 路径 | 用途 |
|------|------|
| `%USERPROFILE%\.agents\skills\serenity-skill` | Cursor **全局**技能（跨所有项目可见） |
| `C:\Users\xwy12\Desktop\my-project\github\serenity-skill` | 完整上游仓（更新、校验、文档） |

说明：采用 **skills 全局路径** 同步到其它 Cursor 项目，**未**写入各项目 `.cursor/rules/`。

> 注意：`npx skills add … --copy` 在本机曾**只复制 `SKILL.md`**；需 `--full-depth` 仍不足时，按下方手动复制 `references/`、`assets/`、`scripts/` 等。

---

## 三、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | `git clone` 整仓 → 手动复制运行时文件到 `~\.agents\skills\serenity-skill` |
| 备选 CLI | `npx skills@latest add muxuuu/serenity-skill -g -a cursor --copy -y --full-depth`（可能仅 SKILL.md） |
| 安装范围 | 全局（global） |
| Agent | `cursor` |
| 已安装技能 | **1**（`serenity-skill`） |
| 校验 | `python scripts/validate_skill.py .` → `OK` |
| 上游版本 | `1.0.0`（`SKILL.md` metadata） |

验证：

```powershell
npx skills@latest list -g --agent cursor
# 应出现 serenity-skill

Get-ChildItem "$env:USERPROFILE\.agents\skills\serenity-skill" |
  Select-Object Name

python "$env:USERPROFILE\.agents\skills\serenity-skill\scripts\validate_skill.py" `
  "$env:USERPROFILE\.agents\skills\serenity-skill"
```

目录中应含：`SKILL.md`、`LICENSE`、`references/`、`assets/`、`scripts/`、`examples/`、`agents/`。

---

## 四、新机器安装步骤

### 1) 前置

- Node.js（`npx`，可选，用于 skills CLI 列表/更新）
- Python 3（本地 scorecard / validate，仅标准库）
- 可访问 GitHub（Windows Schannel 不稳时用 HTTP 代理 `http://127.0.0.1:7897`）

### 2) 克隆整仓

```powershell
$dest = "C:\Users\xwy12\Desktop\my-project\github\serenity-skill"
git -c http.proxy=http://127.0.0.1:7897 clone --depth 1 `
  https://github.com/muxuuu/serenity-skill.git $dest
```

### 3) 安装到 Cursor 全局 skills（推荐：完整复制）

```powershell
$src = "C:\Users\xwy12\Desktop\my-project\github\serenity-skill"
$dst = "$env:USERPROFILE\.agents\skills\serenity-skill"
if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
New-Item -ItemType Directory -Path $dst -Force | Out-Null
foreach ($i in @("SKILL.md","LICENSE","references","assets","scripts","examples","agents")) {
  Copy-Item -Recurse -Force (Join-Path $src $i) $dst
}
python (Join-Path $dst "scripts\validate_skill.py") $dst
```

`-g` / 全局目录：写入 `%USERPROFILE%\.agents\skills\`，**所有 Cursor 工作区共用**，无需逐仓安装。

### 4)（可选）仅用 skills CLI

```powershell
npx skills@latest add muxuuu/serenity-skill -g -a cursor --copy -y --full-depth
# 若目录只有 SKILL.md，再执行上一节完整复制
```

---

## 五、日常用法

### Cursor 对话

触发词示例：

- `用 Serenity 的方式看 A 股 AI 半导体`
- `深度调研 CPO / 先进封装产业链卡点`
- `challenge this thesis` / `找供应链瓶颈并排序研究优先级`

Agent 应读取 `~\.agents\skills\serenity-skill\SKILL.md`，并按需加载 `references/`。

### 请求路由（技能内置）

| 模式 | 何时 |
|------|------|
| Theme scan | 给市场 + 主题，要候选与优先级 |
| Single-company challenge | 单票：链上位置、证据、证伪 |
| Candidate comparison | 多票按稀缺/证据/时机比较 |
| Research partner | 对话推演，逼近证据与失败条件 |
| Learning mode | 学方法：趋势→系统→卡点→证明 |

### 本地 Scorecard

```powershell
$S = "$env:USERPROFILE\.agents\skills\serenity-skill"
python "$S\scripts\serenity_scorecard.py" --template > my-company.json
python "$S\scripts\serenity_scorecard.py" --format md my-company.json
```

---

## 六、更新

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7897"
Set-Location "C:\Users\xwy12\Desktop\my-project\github\serenity-skill"
git -c http.proxy=http://127.0.0.1:7897 pull --ff-only

$src = (Get-Location).Path
$dst = "$env:USERPROFILE\.agents\skills\serenity-skill"
Remove-Item -Recurse -Force $dst
New-Item -ItemType Directory -Path $dst -Force | Out-Null
foreach ($i in @("SKILL.md","LICENSE","references","assets","scripts","examples","agents")) {
  Copy-Item -Recurse -Force (Join-Path $src $i) $dst
}
```

---

## 七、FAQ

**Q: 为什么不全量复制到每个子项目？**  
A: 全局 skills 已被 Cursor 加载；与 Caveman / Ponytail / UZI 策略一致。

**Q: 和 UZI 怎么选？**  
A: 主题/产业链/卡点优先用 Serenity；单票全量建模/HTML 研报用 UZI。可串联：Serenity 排优先级 → UZI 深挖个股。

**Q: 算投资建议吗？**  
A: 否。仅研究支持，无交易执行。

---

## 八、相关文件

- Wiki：`wiki/serenity/` · Raw：`raw/serenity/`
- Manifest：`cursor-env-manifest.json`（`SERENITY.md`）

---

*最后更新：2026-07-15 · Windows + Cursor*
