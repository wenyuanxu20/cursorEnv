# Serenity Bottleneck Hunter Skill 部署与使用指南

> 项目地址：[Mrjie7205/serenity-bottleneck-hunter](https://github.com/Mrjie7205/serenity-bottleneck-hunter) · 发现页：[skills.sh/…](https://skills.sh/mrjie7205/serenity-bottleneck-hunter/serenity-bottleneck-hunter) · License: MIT

本文档记录在 Windows + Cursor 环境下，如何安装、验证和使用 **serenity-bottleneck-hunter**（Serenity 瓶颈猎手 · mrjie7205），并作为新机器迁移时的可复用说明。

---

## 一、定位说明

给定投资**主题**，复用 X 博主 Serenity（@aleabitoreddit）公开分享的「供应链瓶颈逆向映射」方法，**独立挖出被忽视的上游瓶颈股**（不抄他已喊过的票）。

- 主题 → 逆向拆链 → **9 大瓶颈原型** → 候选 + 论证 + 择时/证伪
- 工程化纪律：穷尽性 audit、ETF 持仓兜底、ticker 真值库、禁止 WebSearch 猜价、报告契约校验
- 产出：自包含 HTML 报告 + `tracking/forward_picks.csv` 向前验证

与本仓库其它技能关系：

| 工具 | 关系 |
|------|------|
| `serenity-skill`（muxuuu） | 互补：方法论同源气质；本仓库偏工程纪律 + HTML/脚本闭环 |
| `bottleneck-hunter`（ai-berkshire） | 互补：都做卡点扫描；来源与工具链不同 |
| UZI | 互补：本技能筛主题候选 → UZI 深挖个股 |
| Headroom | 无端口冲突 |

**边界**：研究教育用途；非投资建议；与 Serenity 本人无关联/背书。

---

## 二、路径与冲突确认（本机已验证 · 2026-07-15）

| 检查项 | 结果 |
|--------|------|
| 安装前 `~\.agents\skills\serenity-bottleneck-hunter` | **不存在** |
| 与 `serenity-skill` / `bottleneck-hunter` | **无冲突**（目录名不同） |
| 与 Headroom | **无冲突** |

| 路径 | 用途 |
|------|------|
| `%USERPROFILE%\.agents\skills\serenity-bottleneck-hunter` | Cursor **全局**技能（完整包） |
| `C:\Users\xwy12\Desktop\my-project\github\serenity-bottleneck-hunter` | 整仓（更新 / 对照） |

> `npx skills add … --copy` 本机曾**只复制 `SKILL.md`**；已按上游结构手动补全 `reference/`、`scripts/`、`tracking/`、`agents/`。

---

## 三、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | CLI 安装后 → clone 整仓 → 完整复制到 `~\.agents\skills\` |
| 安装范围 | 全局 |
| Agent | `cursor` |
| 已安装技能 | **1**（`serenity-bottleneck-hunter`） |
| 技能目录文件数 | **35** |
| 安全扫描（skills.sh） | Gen Safe / Socket 0 / Snyk Med Risk |
| 可选环境变量 | `EODHD_API_KEY`（价格；无则回退 yfinance） |

验证：

```powershell
npx skills@latest list -g --agent cursor
# 应出现 serenity-bottleneck-hunter

Get-ChildItem "$env:USERPROFILE\.agents\skills\serenity-bottleneck-hunter" |
  Select-Object Name
# 应含 SKILL.md、LICENSE、agents、reference、scripts、tracking
```

---

## 四、新机器安装步骤

### 1) 前置

- Node.js（`npx`）
- Python 3（`scripts/price.py` 等；美股可 yfinance，A 股估值建议 akshare）
- GitHub 访问（失败时用 `http.sslBackend=openssl` + `http://127.0.0.1:7897`）

### 2) 克隆整仓

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7897"
$env:HTTP_PROXY = "http://127.0.0.1:7897"
$dest = "C:\Users\xwy12\Desktop\my-project\github\serenity-bottleneck-hunter"
git -c http.sslBackend=openssl -c http.proxy=http://127.0.0.1:7897 clone --depth 1 `
  https://github.com/mrjie7205/serenity-bottleneck-hunter.git $dest
```

### 3) 安装到 Cursor 全局 skills（完整复制）

```powershell
$src = "C:\Users\xwy12\Desktop\my-project\github\serenity-bottleneck-hunter"
$dst = "$env:USERPROFILE\.agents\skills\serenity-bottleneck-hunter"
if (Test-Path $dst) { Remove-Item -Recurse -Force $dst }
New-Item -ItemType Directory -Path $dst -Force | Out-Null
foreach ($i in @("SKILL.md","LICENSE","agents","reference","scripts","tracking",".env.example")) {
  if (Test-Path (Join-Path $src $i)) {
    Copy-Item -Recurse -Force (Join-Path $src $i) $dst
  }
}
```

备选（可能仅 SKILL.md）：

```powershell
npx skills@latest add mrjie7205/serenity-bottleneck-hunter -g -a cursor --copy -y --full-depth
# 若目录缺 reference/scripts/tracking，再执行上一节完整复制
```

### 4)（可选）价格 API

```powershell
# 见 .env.example；也可系统环境变量
$env:EODHD_API_KEY = "你的key"
```

无 key 时 `scripts/price.py` 回退 yfinance（美股可用）。**禁止用 WebSearch 猜价格**。

---

## 五、日常用法

### Cursor 对话

```text
用 Serenity 瓶颈猎手方法分析「AI 数据中心电力」主题，给出候选标的和论证
使用 serenity-bottleneck-hunter 分析「人形机器人」产业链
```

Agent 应读取 `~\.agents\skills\serenity-bottleneck-hunter\SKILL.md`，并按需调用同目录 `scripts/`、`reference/`、`tracking/`。

### 常用脚本（在 skill 目录或整仓根执行）

```powershell
$S = "$env:USERPROFILE\.agents\skills\serenity-bottleneck-hunter"
cd $S
python scripts\price.py --help
python scripts\theme_etf_coverage.py --help
python scripts\verify_report.py --help
```

交付 HTML 前应跑 `verify_report.py` 契约校验。

---

## 六、更新

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7897"
Set-Location "C:\Users\xwy12\Desktop\my-project\github\serenity-bottleneck-hunter"
git -c http.sslBackend=openssl -c http.proxy=http://127.0.0.1:7897 pull --ff-only

$src = (Get-Location).Path
$dst = "$env:USERPROFILE\.agents\skills\serenity-bottleneck-hunter"
Remove-Item -Recurse -Force $dst
New-Item -ItemType Directory -Path $dst -Force | Out-Null
foreach ($i in @("SKILL.md","LICENSE","agents","reference","scripts","tracking",".env.example")) {
  if (Test-Path (Join-Path $src $i)) {
    Copy-Item -Recurse -Force (Join-Path $src $i) $dst
  }
}
```

---

## 七、FAQ

**Q: 和 muxuuu/serenity-skill 重复吗？**  
A: 气质相近、目录独立。本仓库强调翻车纪律、ETF audit、HTML 报告与 forward tracking。

**Q: 和 xbtlin bottleneck-hunter？**  
A: 都可扫卡点；本技能绑 Serenity 9 原型 + 工程脚本闭环。

**Q: 算投资建议吗？**  
A: 否。仅研究教育。

---

## 八、相关文件

- Wiki：`wiki/serenity-bottleneck-hunter/` · Raw：`raw/serenity-bottleneck-hunter/`
- Manifest：`cursor-env-manifest.json`
- 姊妹：`SERENITY.md`、`BOTTLENECK-HUNTER.md`、`UZI.md`

---

*最后更新：2026-07-15 · Windows + Cursor*
