# Graphify 本地部署与使用指南

> 官方文档：[Graphify 中文站](https://graphify.net/zh/) · [GitHub](https://github.com/safishamsi/graphify) · PyPI 包名 `graphifyy`（双 y）

本文档记录本机 Graphify 的部署状态，以及在新项目中快速启用的步骤。

---

## 一、本机部署状态（一次性，已完成）

| 组件 | 路径 / 版本 | 说明 |
|------|-------------|------|
| CLI | `C:\Users\xwy12\.local\bin\graphify` | v0.8.44，含 OpenAI 扩展 |
| 包管理 | `uv` | 安装于 `C:\Users\xwy12\.local\bin\` |
| Cursor 全局规则 | `C:\Users\xwy12\.cursor\rules\graphify.mdc` | `alwaysApply: true`，所有 Cursor 项目生效 |
| 一键初始化脚本 | `C:\Users\xwy12\.local\bin\graphify-init-project.ps1` | 进入新项目后可直接调用 |
| 用户 PATH | 已包含 `C:\Users\xwy12\.local\bin` | 新终端 / 重启 Cursor 后 `graphify` 命令可用 |

### 已初始化项目

| 项目 | 图谱规模 | 输出目录 |
|------|----------|----------|
| `cursorEnv` | 见 `graphify-out/GRAPH_REPORT.md` | `cursorEnv/graphify-out/` |
| `ai` | 76 节点 · 101 边 · 8 社区 | `ai/graphify-out/` |
| `quant2026` | 898 节点 · 2037 边 · 41 社区 | `github/quant2026/graphify-out/` |

`cursorEnv` 图谱包含 **Headroom 配置 wiki**（`wiki/headroom/`）、脚本与 `HEADROOM.md`；查询示例：

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
graphify query "Headroom Cursor BYOK 如何配置"
graphify explain "Headroom"
```

---

## 二、在新项目中使用（推荐流程）

### 方式 A：一键脚本（最快）

```powershell
cd C:\path\to\your-new-project
graphify-init-project.ps1
```

脚本会自动：

1. 读取项目 `.env` 中的 API Key（见下文「API Key 配置」）
2. 写入 `.cursor/rules/graphify.mdc`
3. 执行 `graphify extract .` + `graphify cluster-only .`
4. 生成 `graphify-out/` 目录

完成后用浏览器打开：

```
your-project/graphify-out/graph.html
```

### 方式 B：手动步骤

```powershell
cd C:\path\to\your-new-project

# 1. 注册 Cursor 规则（可选，已有全局规则时可跳过）
graphify cursor install

# 2. 构建知识图谱
graphify extract .
graphify cluster-only .

# 3. 查看可视化
start graphify-out\graph.html
```

---

## 三、API Key 配置

Graphify **不内置 LLM**，文档 / Markdown 的语义提取需要 API Key。纯代码项目可跳过 Key，使用 `--cluster-only` 仅做 AST 分析。

### 项目 `.env`（推荐，初始化脚本会自动读取）

| `.env` 变量 | 映射到 Graphify |
|-------------|-----------------|
| `AI_API_KEY` | `OPENAI_API_KEY` |
| `AI_API_BASE_URL` | `OPENAI_BASE_URL` |
| `AI_MODEL` | `OPENAI_MODEL` |

### 系统环境变量（备选）

```powershell
$env:OPENAI_API_KEY = "your-key"
$env:OPENAI_BASE_URL = "https://api.openai.com/v1"   # 或兼容接口地址
$env:OPENAI_MODEL = "gpt-4o-mini"
```

### 其他后端

| 后端 | 环境变量 |
|------|----------|
| Gemini | `GEMINI_API_KEY` 或 `GOOGLE_API_KEY` |
| Claude | `ANTHROPIC_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |

指定后端示例：

```powershell
graphify extract . --backend openai
graphify extract . --backend gemini
```

### 纯代码项目（无需 API Key）

```powershell
graphify extract . --cluster-only
```

---

## 四、日常使用命令

在项目根目录执行：

```powershell
# 查询架构 / 业务逻辑（优先于全量读文件，约 2k tokens）
graphify query "ETF 策略如何运行？"

# 查两个模块 / 符号之间的依赖路径
graphify path "UserService" "DatabasePool"

# 解释某个核心概念及其关联节点
graphify explain "_etf_strategy_cycle"

# 改代码后增量更新（纯 AST，不消耗 API）
graphify update .

# 强制覆盖（大量删代码后节点变少时使用）
graphify update . --force

# 查看文字版架构报告
notepad graphify-out\GRAPH_REPORT.md
```

### 在 Cursor 中使用

全局规则已启用，Agent 会优先调用 `graphify query` 而非盲目 Read/Grep 全仓库。

可直接在对话中说：

- 「用 graphify 查询认证流程」
- 「graphify explain QQFuturesAlertBot」

**前提**：当前项目下存在 `graphify-out/graph.json`（需先完成初始化）。

---

## 五、输出文件说明

每个项目初始化后生成：

```
your-project/
├── graphify-out/
│   ├── graph.html          # 交互式可视化（浏览器打开）
│   ├── graph.json          # 可查询的图谱数据
│   ├── GRAPH_REPORT.md     # 架构报告：社区、God Nodes、意外连接
│   └── cache/              # 增量缓存，加速后续构建
└── .cursor/rules/
    └── graphify.mdc        # 项目级 Cursor 规则（可选）
```

### 建议加入 `.gitignore`

```
graphify-out/
```

---

## 六、可选增强

### Git 提交后自动更新图谱

```powershell
graphify hook install    # 安装 post-commit hook（AST 更新，秒级）
graphify hook status     # 检查状态
graphify hook uninstall  # 移除
```

升级 Graphify 后需重新执行 `graphify hook install` 以刷新嵌入的 Python 路径。

### 跨仓库合并图谱

```powershell
graphify global add ./graphify-out/graph.json --as my-project
graphify global list
```

---

## 七、故障排查

### `graphify: command not found`

重启终端或 Cursor。临时修复：

```powershell
$env:Path = "C:\Users\xwy12\.local\bin;$env:Path"
```

### 语义提取失败：`max_seq_len` / token 超限

大型项目文档较多时，降低单次 chunk 大小：

```powershell
graphify extract . --backend openai --token-budget 20000
```

`quant2026` 项目即采用此参数成功构建（默认 60000 会超出部分模型的 32768 上限）。

### `openai package is required`

重新安装带 OpenAI 扩展的版本：

```powershell
uv tool install "graphifyy[openai]" --force
```

### 全局重装（罕见情况）

```powershell
uv tool install "graphifyy[openai]" --force
cd $env:USERPROFILE
graphify install --platform cursor
```

---

## 八、首次安装参考（新机器 / 重装）

本机已完成，仅供其他电脑参考：

```powershell
# 1. 安装 uv
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"

# 2. 安装 Graphify（推荐 uv，避免 pip PATH 问题）
uv tool install "graphifyy[openai]"

# 3. 注册 Cursor 全局规则
cd $env:USERPROFILE
graphify install --platform cursor

# 4. 复制初始化脚本到 PATH（可选，见本机 graphify-init-project.ps1）
```

> **注意**：PyPI 官方包名为 `graphifyy`（双 y），CLI 命令仍为 `graphify`。其他 `graphify*` 包非官方。

---

## 九、快速备忘

```powershell
# 新项目三步
cd C:\path\to\project
graphify-init-project.ps1
start graphify-out\graph.html

# 日常维护
graphify update .
graphify query "你的问题"
```

---

*最后更新：2026-07-03 · 本机 Graphify v0.8.44 · cursorEnv 图谱已含 Headroom wiki*
