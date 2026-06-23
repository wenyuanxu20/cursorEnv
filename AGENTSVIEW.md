# AgentsView 本地部署与使用指南

> 官方文档：[Quick Start](https://agentsview.io/quickstart/) · [Configuration](https://agentsview.io/configuration/) · [CLI Reference](https://agentsview.io/commands/) · [GitHub](https://github.com/kenn-io/agentsview)

AgentsView 是本地优先的 AI 编程 Agent 会话浏览器，可自动发现、同步并分析 Cursor 等 Agent 的历史对话。所有数据保存在本机，无需账号。

---

## 一、本机部署状态（参考快照）

| 组件 | 路径 / 版本 | 说明 |
|------|-------------|------|
| CLI | `C:\Users\xwy12\AppData\Roaming\Python\Python314\Scripts\agentsview.exe` | v0.34.4 |
| 安装方式 | `pip install agentsview` | 亦可用官方脚本 / 桌面版 / `uvx` |
| 数据目录 | `C:\Users\xwy12\.agentsview\` | 数据库、配置、日志 |
| Web UI | http://127.0.0.1:8080 | 默认端口 8080 |
| 用户 PATH | **需手动添加** Scripts 目录 | 见下文「PATH 配置」 |

### Cursor 会话来源（Windows 默认）

| 来源 | 路径 | 说明 |
|------|------|------|
| 项目 transcript | `%USERPROFILE%\.cursor\projects\` | JSONL / 纯文本 transcript |
| 全局 state DB | `%APPDATA%\Cursor\User\globalStorage\state.vscdb` | Composer 会话元数据与消息 |

首次同步示例：42 个会话 · 4016 条消息（随 Cursor 使用自动增长）。

---

## 二、新机器安装（Windows）

任选一种方式即可。

### 方式 A：pip（本机采用）

```powershell
pip install agentsview
```

安装后二进制位于：

```
%APPDATA%\Python\Python314\Scripts\agentsview.exe
```

（Python 小版本号可能不同，以实际 Scripts 目录为准。）

### 方式 B：官方 PowerShell 脚本

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://agentsview.io/install.ps1 | iex"
```

脚本会从 GitHub Releases 下载、校验 SHA-256 并安装二进制。

### 方式 C：桌面版

从 [GitHub Releases](https://github.com/kenn-io/agentsview/releases) 下载 `.exe` 安装包。桌面版与 CLI **共用** `~/.agentsview/` 数据目录，可二选一或同时使用。

### 方式 D：免安装运行

```powershell
uvx agentsview serve
```

### PATH 配置

pip 安装后若提示「不在 PATH」，将 Scripts 目录加入用户环境变量：

```powershell
# 查看实际路径
python -m site --user-base
# 一般为：%APPDATA%\Python\Python314\Scripts

# 当前会话临时生效
$env:Path = "$env:APPDATA\Python\Python314\Scripts;" + $env:Path

# 永久生效（用户级）
[Environment]::SetEnvironmentVariable(
  "Path",
  "$env:APPDATA\Python\Python314\Scripts;" + [Environment]::GetEnvironmentVariable("Path", "User"),
  "User"
)
```

验证：

```powershell
agentsview --version
```

---

## 三、启动与日常使用

### 首次 / 前台启动

```powershell
agentsview serve
```

自动完成：初始化 SQLite 数据库 → 发现 Cursor 等 Agent 会话 → 监听目录变更 → 打开浏览器 `http://127.0.0.1:8080`。

### 后台运行（推荐）

```powershell
agentsview serve --background --no-browser
agentsview serve status    # 查看 PID、版本、运行时长
agentsview serve stop      # 停止
```

日志：`%USERPROFILE%\.agentsview\serve.log`

### 常用参数

```powershell
agentsview serve --port 9090              # 自定义端口
agentsview serve --host 0.0.0.0 --port 3000  # 监听所有网卡（远程访问需配合鉴权）
agentsview serve --no-browser             # 不自动打开浏览器
agentsview serve --background             # 后台守护进程
```

### Web UI 功能概览

- 会话列表：按项目、Agent、日期、消息数筛选
- 消息查看：完整内容、工具调用、thinking 块
- 全文搜索：跨所有消息内容
- 分析面板：活动热力图、工具使用、速度图表
- 导出：独立 HTML、Markdown 链接、GitHub Gist（需配置 token）

---

## 四、配置说明

### 数据目录结构

```
%USERPROFILE%\.agentsview\
├── sessions.db     # SQLite 数据库（WAL 模式）
├── config.toml     # 配置文件（首次运行自动生成）
├── serve.log       # 后台服务日志（--background 时）
└── uploads/        # 手动上传的会话文件
```

可通过环境变量覆盖数据目录：

```powershell
$env:AGENTSVIEW_DATA_DIR = "D:\data\agentsview"
agentsview serve
```

### config.toml

首次运行后自动生成 `%USERPROFILE%\.agentsview\config.toml`。**不要**在版本库或文档中提交真实密钥；新机器首次启动会重新生成。

| 字段 | 说明 |
|------|------|
| `cursor_secret` | 分页 HMAC 密钥，自动生成 |
| `github_token` | 可选，导出 Gist 用；也可在 Web UI Settings 配置 |
| `require_auth` | `true` 时 API 需 Bearer Token（远程访问建议开启） |
| `auth_token` | 远程访问鉴权 token，自动生成 |
| `public_url` | 反向代理 / 端口转发时的对外 URL |
| `result_content_blocked_categories` | 不存储的工具结果类别，默认 `["Read", "Glob"]` |

多 Cursor 项目路径示例（`config.toml`）：

```toml
cursor_project_dirs = [
  "C:\\Users\\YOUR_NAME\\.cursor\\projects",
  "D:\\backup\\cursor-projects",
]
```

### Cursor 相关环境变量

| 变量 | 作用 | Windows 默认值 |
|------|------|----------------|
| `CURSOR_PROJECTS_DIR` | transcript 根目录 | `%USERPROFILE%\.cursor\projects` |
| `CURSOR_STATE_DB` | 全局 SQLite | `%APPDATA%\Cursor\User\globalStorage\state.vscdb` |

临时指定后启动：

```powershell
$env:CURSOR_PROJECTS_DIR = "D:\custom\cursor\projects"
$env:CURSOR_STATE_DB = "D:\custom\state.vscdb"
agentsview serve --background
```

### 其他 Agent（可选）

AgentsView 同时支持 Claude Code、Codex、Copilot CLI、Gemini CLI 等。完整目录与环境变量见 [Configuration - Session Discovery](https://agentsview.io/configuration/)。

---

## 五、新机器迁移清单

AgentsView 的数据源是 **Cursor 本机会话文件**，迁移策略分两种：

### 策略 A：只迁移工具（推荐）

新机器安装 AgentsView 后，只要 Cursor 会话目录存在，**重新 sync 即可**，无需拷贝 `sessions.db`。

1. 新机器安装 Cursor，正常使用产生会话；或
2. 将旧机器 `%USERPROFILE%\.cursor\` 目录拷贝到新机器相同路径；以及（可选）
3. 拷贝 `%APPDATA%\Cursor\User\globalStorage\state.vscdb`（Composer 历史更完整）

然后：

```powershell
pip install agentsview
agentsview serve --background
```

首次启动会自动扫描并写入新机器的 `%USERPROFILE%\.agentsview\sessions.db`。

### 策略 B：连同索引库一起迁移

若希望保留已有搜索索引、分析结果、上传文件：

| 拷贝内容 | 源路径 | 目标路径 |
|----------|--------|----------|
| 整个数据目录 | `%USERPROFILE%\.agentsview\` | 新机器同路径 |

注意：

- 跨平台迁移（Windows ↔ macOS/Linux）路径不同，建议用策略 A 重新 sync
- `config.toml` 中的 `cursor_secret` / `auth_token` 可一并迁移；不迁移则新机器会自动生成
- **不要**将含 `github_token`、`auth_token` 的配置提交到 Git

### 迁移后验证

```powershell
agentsview serve status
# 浏览器打开 http://127.0.0.1:8080
# 检查会话数量、全文搜索、最近 Cursor 对话是否出现
```

查看同步日志：

```powershell
Get-Content "$env:USERPROFILE\.agentsview\serve.log" -Tail 30
```

---

## 六、macOS / Linux 快速参考

```bash
# 安装
curl -fsSL https://agentsview.io/install.sh | bash
# 或
pip install agentsview

# 启动
agentsview serve --background

# Cursor 默认路径
# macOS transcript:  ~/.cursor/projects/
# macOS state DB:    ~/Library/Application Support/Cursor/User/globalStorage/state.vscdb
# Linux transcript:  ~/.cursor/projects/
# Linux state DB:    ~/.config/Cursor/User/globalStorage/state.vscdb
```

---

## 七、故障排查

### `agentsview` 命令找不到

- 确认 pip Scripts 目录已加入 PATH（见第二节）
- 或直接用：`python -m agentsview serve`（若模块入口可用）
- 或使用：`uvx agentsview serve`

### 页面打不开 / 端口占用

```powershell
agentsview serve --port 9090
# 或先停止旧实例
agentsview serve stop
```

### 看不到 Cursor 会话

1. 确认 Cursor 已在本机使用过，且路径存在：

   ```powershell
   Test-Path "$env:USERPROFILE\.cursor\projects"
   Test-Path "$env:APPDATA\Cursor\User\globalStorage\state.vscdb"
   ```

2. 若 Cursor 数据在非默认位置，设置 `CURSOR_PROJECTS_DIR` / `CURSOR_STATE_DB` 后重启服务

3. 查看 `serve.log` 中 `Sync complete` 行与会话数量

### 远程 / WSL / 端口转发访问失败

使用对外 URL 启动：

```powershell
agentsview serve --public-url https://your-forwarded-host.example.com
```

若暴露到公网，在 `config.toml` 设置 `require_auth = true` 并使用生成的 `auth_token`。

### 升级

```powershell
pip install --upgrade agentsview
agentsview serve stop
agentsview serve --background
```

---

## 八、快速备忘

```powershell
# 安装
pip install agentsview

# 后台启动
agentsview serve --background --no-browser

# 打开 UI
start http://127.0.0.1:8080

# 状态 / 停止
agentsview serve status
agentsview serve stop

# 升级
pip install --upgrade agentsview
```

---

## 九、与本仓库的关系

本仓库（`cursorEnv`）存放 Cursor 开发环境相关的迁移文档（Graphify、AgentsView 等）。AgentsView 本身**不依赖**本仓库代码；本文档仅用于在新机器上快速复现相同的本地浏览环境。

相关文档：

- [GRAPHIFY.md](./GRAPHIFY.md) — 代码知识图谱工具
- [agency-agents.md](./agency-agents.md) — Agent 编排参考

---

*最后更新：2026-06-23 · 本机 AgentsView v0.34.4 · Windows 10*
