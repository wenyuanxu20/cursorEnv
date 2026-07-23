# UZI Skill（游资）部署与使用指南

> 项目地址：[wbh604/UZI-Skill](https://github.com/wbh604/UZI-Skill) · License: MIT

本文档记录在 Windows + Cursor 环境下，如何安装、验证和使用 UZI（股票深度分析 Skill），并作为新机器迁移时的可复用说明。

---

## 一、定位说明

UZI 把 AI coding agent 变成 **A 股 / 港股 / 美股私有分析师**：

- 输入代码 → 拉 **22 维**公开数据 → 跑 **17** 套机构模型 → **50+** 投资人 persona 打分
- 产出 Bloomberg 风格单文件 HTML + 分享图卡 + 一行摘要
- 深度档位：`lite`（1–2 min）/ `medium`（5–8 min，默认）/ `deep`（15–20 min）

与本仓库其它技能关系：

| 工具 | 关系 |
|------|------|
| Caveman / Ponytail | 无冲突；UZI 是领域分析技能，不是口癖/YAGNI |
| Headroom `:8787` | 无冲突（UZI 不占该端口） |
| Graphify | 无冲突 |

**免责声明**：输出为研究工具与规则引擎模拟，**不是投资建议**。

---

## 二、路径与冲突确认（本机已验证 · 2026-07-15）

| 检查项 | 结果 |
|--------|------|
| `cursorEnv/UZI-Skill/` | **不存在**（整仓放在 `github/UZI-Skill`，非 hub 内嵌） |
| 安装前 `~\.agents\skills\` 中 uzi / deep-analysis / investor-panel / lhb-analyzer / trap-detector | **不存在** |
| 与 Headroom `127.0.0.1:8787` | **无冲突** |
| 与已装 caveman / ponytail / mattpocock skills | **无冲突**（目录名不重叠） |

| 路径 | 用途 |
|------|------|
| `%USERPROFILE%\.agents\skills\{uzi,deep-analysis,investor-panel,lhb-analyzer,trap-detector}` | Cursor **全局**技能（跨所有项目可见） |
| `C:\Users\xwy12\Desktop\my-project\github\UZI-Skill` | 完整运行时（`run.py`、更新、hooks、commands） |

说明：采用 **skills 全局路径** 同步到其它 Cursor 项目，**未**写入各项目 `.cursor/rules/`。

---

## 三、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | 先 `git clone` 整仓，再 `npx skills add <本地路径> -g -a cursor --copy -y --full-depth` |
| 安装范围 | 全局（global）→ 自动对 `headroom-projects.json` 中全部子项目可见 |
| Agent | `cursor` |
| 已安装技能 | **5** |
| Python 依赖 | 已 `pip install -r requirements.txt`（清华镜像） |
| 上游版本 | plugin `3.9.2`（以 clone 时 `main` 为准） |

### 已安装技能

| 技能 | 用途 |
|------|------|
| `uzi` | 根入口：按意图路由到下列子技能 |
| `deep-analysis` | 全量深度分析 / DCF / IC memo / HTML 报告（含 scripts） |
| `investor-panel` | 仅评委团投票 |
| `lhb-analyzer` | 龙虎榜 / 游资席位 |
| `trap-detector` | 杀猪盘 / 炒作信号 |

验证：

```powershell
npx skills@latest list -g --agent cursor
# 应出现 uzi / deep-analysis / investor-panel / lhb-analyzer / trap-detector

python "C:\Users\xwy12\Desktop\my-project\github\UZI-Skill\run.py" --help
```

---

## 四、新机器安装步骤

### 1) 前置

- Node.js（`npx`）
- Python 3.10+（本机为 3.14）
- 可访问 GitHub（Windows Schannel + SOCKS 常失败时，用 **HTTP 代理** `http://127.0.0.1:7897`）

### 2) 克隆整仓（运行时）

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7897"
$env:HTTP_PROXY = "http://127.0.0.1:7897"
$dest = "C:\Users\xwy12\Desktop\my-project\github\UZI-Skill"
git -c http.proxy=http://127.0.0.1:7897 clone --depth 1 https://github.com/wbh604/UZI-Skill.git $dest
```

> 直接 `npx skills add wbh604/UZI-Skill` 在本机曾因 **schannel TLS** 克隆失败；本地路径安装更稳。

### 3) 全局安装到 Cursor（跨项目同步）

```powershell
npx skills@latest add "C:\Users\xwy12\Desktop\my-project\github\UZI-Skill" -g -a cursor --copy -y --full-depth
```

`-g`：写入 `%USERPROFILE%\.agents\skills\`，**所有 Cursor 工作区共用**，无需逐个项目复制。

### 4) Python 依赖

```powershell
python -m pip install -r "C:\Users\xwy12\Desktop\my-project\github\UZI-Skill\requirements.txt" `
  -i https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
```

可选：设置免费 `MX_APIKEY`（东财妙想）提升 A 股稳定性，见上游 `.env.example`。

### 5)（可选）Cursor Plugin UI

在 Cursor 对话中也可尝试 `/add-plugin stock-deep-analyzer`；本机以 **skills CLI 全局安装** 为准。

---

## 五、日常用法

### Cursor 对话

触发词示例：`深度分析 600519`、`quick-scan 00700.HK`、`杀猪盘检测 BABA`。

Agent 应读取对应 `~\.agents\skills\*\SKILL.md`，并在运行时目录执行 CLI：

```powershell
cd C:\Users\xwy12\Desktop\my-project\github\UZI-Skill
python run.py 600519 --depth lite --no-browser
python run.py 00700.HK --depth medium --no-browser
python run.py AAPL --depth deep --no-browser
```

也可在已复制的 skill 目录跑（功能略少，以整仓为准）：

```powershell
python "$env:USERPROFILE\.agents\skills\deep-analysis\run.py" 600519 --depth lite --no-browser
```

### 常用意图 → 技能

| 意图 | 技能 / 命令 |
|------|-------------|
| 全面研报 / 估值 / IC | `deep-analysis` · `python run.py <ticker>` |
| 只要评委投票 | `investor-panel` · `--depth lite` 或 panel-only 流程 |
| 龙虎榜 / 游资 | `lhb-analyzer` |
| 杀猪盘 | `trap-detector` |

代码格式：A 股 `600519` / `600519.SH`；港股 `00700.HK`；美股 `AAPL`；中文名如「贵州茅台」。

---

## 六、更新

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7897"
Set-Location "C:\Users\xwy12\Desktop\my-project\github\UZI-Skill"
git -c http.proxy=http://127.0.0.1:7897 pull --ff-only
npx skills@latest add "C:\Users\xwy12\Desktop\my-project\github\UZI-Skill" -g -a cursor --copy -y --full-depth
```

---

## 七、FAQ

**Q: 为什么不全量复制到每个子项目？**  
A: `-g` 全局 skills 已被 Cursor 加载；与 Caveman/Ponytail 策略一致。finance / Quant-Research / vibe-trading 等无需再装一份。

**Q: 分析很慢？**  
A: 先用 `--depth lite`；全量 medium 约 5–8 分钟，多数时间在抓数。

**Q: 算投资建议吗？**  
A: 否。评委是规则 + agent 扮演，不是真人观点。

---

## 八、相关文件

- 结构化知识：`wiki/uzi/`
- 清单：`cursor-env-manifest.json`（`UZI.md`）
- 上游：`AGENTS.md`、`README.md`（中文）
