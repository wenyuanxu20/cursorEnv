# Bottleneck Hunter Skill 部署与使用指南

> 项目地址：[xbtlin/ai-berkshire](https://github.com/xbtlin/ai-berkshire) · 发现页：[skills.sh/…/bottleneck-hunter](https://skills.sh/xbtlin/ai-berkshire/bottleneck-hunter) · License: MIT

本文档记录在 Windows + Cursor 环境下，如何安装、验证和使用 **bottleneck-hunter**（供应链瓶颈猎手），并作为新机器迁移时的可复用说明。

---

## 一、定位说明

Bottleneck Hunter 是 [AI Berkshire](https://github.com/xbtlin/ai-berkshire) 技能集中的一条技能：

- 不问「AI 推荐什么股票」，问「趋势若继续扩张，哪一环会先不够用」
- 从物理供应链咽喉出发，优先扫 **Layer 2/3**（子组件/材料/上游设备），避开已充分定价的 Layer 1
- 覆盖超级趋势：AI 基建、能源转型、国防、半导体再工业化、太空经济等

与本仓库其它技能关系：

| 工具 | 关系 |
|------|------|
| Serenity | 互补：同为卡点/瓶颈投研；Serenity 偏方法论与 scorecard；本技能偏 AI Berkshire 工作流 + `tools/` |
| UZI | 互补：本技能排瓶颈候选 → UZI 深挖个股 |
| Caveman / Ponytail | 无冲突 |
| Headroom `:8787` | 无冲突 |

**边界**：研究工作流；输出不是投资建议。财务交叉校验依赖整仓 `tools/`。

---

## 二、路径与冲突确认（本机已验证 · 2026-07-15）

| 检查项 | 结果 |
|--------|------|
| `cursorEnv/ai-berkshire/` | **不存在**（整仓在 `github/ai-berkshire`） |
| 安装前 `~\.agents\skills\bottleneck-hunter` | **不存在** |
| 与 `serenity-skill` | **无冲突**（目录名不同） |
| 与 Headroom | **无冲突** |

| 路径 | 用途 |
|------|------|
| `%USERPROFILE%\.agents\skills\bottleneck-hunter` | Cursor **全局**技能 |
| `C:\Users\xwy12\Desktop\my-project\github\ai-berkshire` | 完整运行时（`tools/`、`AGENTS.md`、源 `skills/bottleneck-hunter.md`） |

说明：全局 skills 同步到全部 Cursor 项目；**未**写入各项目 `.cursor/rules/`。

> `npx skills add … --copy` 对本技能只复制 `SKILL.md`（该 skill 本身即为单文件）。`tools/` 必须通过整仓 clone 使用。

---

## 三、本机部署快照

| 项目 | 状态 |
|------|------|
| 安装方式 | `npx skills add xbtlin/ai-berkshire --skill bottleneck-hunter -g -a cursor --copy -y --full-depth` + clone 整仓 |
| 安装范围 | 全局 |
| Agent | `cursor` |
| 已安装技能 | **1**（`bottleneck-hunter`） |
| 技能目录内容 | `SKILL.md` + `LICENSE` + `RUNTIME.md`（指向整仓） |
| 安全扫描（skills.sh） | Gen Safe / Socket 0 / Snyk Med Risk |

验证：

```powershell
npx skills@latest list -g --agent cursor
# 应出现 bottleneck-hunter

Get-ChildItem "$env:USERPROFILE\.agents\skills\bottleneck-hunter"
Test-Path "C:\Users\xwy12\Desktop\my-project\github\ai-berkshire\tools\financial_rigor.py"
```

---

## 四、新机器安装步骤

### 1) 前置

- Node.js（`npx`）
- Python 3（跑 `tools/*.py`）
- GitHub 访问（Schannel 失败时用 `http://127.0.0.1:7897`）

### 2) 全局安装 Cursor skill

```powershell
npx skills@latest add xbtlin/ai-berkshire --skill bottleneck-hunter -g -a cursor --copy -y --full-depth
```

可选补充：

```powershell
$dst = "$env:USERPROFILE\.agents\skills\bottleneck-hunter"
Copy-Item "C:\Users\xwy12\Desktop\my-project\github\ai-berkshire\LICENSE" "$dst\LICENSE" -Force
```

### 3) 克隆整仓（tools 运行时）

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7897"
$env:HTTP_PROXY = "http://127.0.0.1:7897"
$dest = "C:\Users\xwy12\Desktop\my-project\github\ai-berkshire"
git -c http.sslBackend=openssl -c http.proxy=http://127.0.0.1:7897 clone --depth 1 `
  https://github.com/xbtlin/ai-berkshire.git $dest
```

本机曾遇 `schannel` TLS 失败；`http.sslBackend=openssl` + HTTP 代理可恢复。

---

## 五、日常用法

### Cursor 对话

```text
使用 bottleneck-hunter 扫描 AI基础设施瓶颈
/bottleneck-hunter AI基础设施
用 bottleneck-hunter 看核电 / 半导体再工业化
```

Agent 应读 `~\.agents\skills\bottleneck-hunter\SKILL.md`；需要估值/财务严谨工具时，在整仓根目录执行：

```powershell
cd C:\Users\xwy12\Desktop\my-project\github\ai-berkshire
python tools\financial_rigor.py --help
```

### 工作流摘要（技能内置）

1. 超级趋势确认（持续性 / 物理性 / 规模性 / 加速性）
2. 供应链物理分层（Layer 0–4，重点 Layer 2/3）
3. 瓶颈评分与候选公司
4. 证据与证伪 / 套利路径

---

## 六、更新

```powershell
$env:HTTPS_PROXY = "http://127.0.0.1:7897"
Set-Location "C:\Users\xwy12\Desktop\my-project\github\ai-berkshire"
git -c http.sslBackend=openssl -c http.proxy=http://127.0.0.1:7897 pull --ff-only
npx skills@latest add xbtlin/ai-berkshire --skill bottleneck-hunter -g -a cursor --copy -y --full-depth
```

---

## 七、FAQ

**Q: 和 Serenity 重复吗？**  
A: 方法论相近但来源不同。可并存；Serenity 带本地 scorecard；Bottleneck Hunter 绑 AI Berkshire `tools/` 与超级趋势清单。

**Q: 为何要 clone 整仓？**  
A: skill 文本要求使用仓库 `tools/`（如 `financial_rigor.py`），CLI 不会把 `tools/` 装进 `~\.agents\skills\`。

**Q: 算投资建议吗？**  
A: 否。

---

## 八、相关文件

- Wiki：`wiki/bottleneck-hunter/` · Raw：`raw/bottleneck-hunter/`
- Manifest：`cursor-env-manifest.json`（`BOTTLENECK-HUNTER.md`）
- 姊妹：`SERENITY.md`、`UZI.md`

---

*最后更新：2026-07-15 · Windows + Cursor*
