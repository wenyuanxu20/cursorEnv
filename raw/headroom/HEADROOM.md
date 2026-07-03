# Headroom × Cursor 配置指南（my-project 工作区）

> 官方：[Headroom 文档](https://headroomlabs-ai.github.io/headroom/) · [GitHub](https://github.com/headroomlabs-ai/headroom)

本仓库是 `my-project` 下 Headroom 的**配置中枢**：统一代理、子项目 URL 映射、批量初始化脚本。

---

## 一、本机部署状态

| 组件 | 路径 / 版本 | 说明 |
|------|-------------|------|
| CLI | `headroom` v0.28.0 | `pip install "headroom-ai[proxy]"` |
| Python Scripts | `%APPDATA%\Python\Python314\Scripts` | 需加入 PATH |
| RTK | `%USERPROFILE%\.headroom\bin\rtk.exe` | wrap 时自动安装 |
| 本地代理 | `http://127.0.0.1:8787` | 单实例服务所有子项目 |
| 子项目映射 | `headroom-projects.json` | 16 个子项目 |
| 解析后 URL | `headroom-projects.resolved.json` | 运行 map 脚本后生成 |

### 子项目 URL 规则

Cursor 无法发送自定义 Header，Headroom 用 **Base URL 路径前缀** 区分子项目：

| 提供商 | Base URL 模板 |
|--------|---------------|
| OpenAI 兼容 | `http://127.0.0.1:8787/p/{项目名}/v1` |
| Anthropic | `http://127.0.0.1:8787/p/{项目名}` |

示例：`ai` 子项目 → OpenAI Base URL = `http://127.0.0.1:8787/p/ai/v1`

---

## 二、日常使用（3 步）

### 1. 启动代理

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\headroom-start-proxy.ps1 -Memory
```

### 2. 切换子项目（在目标项目目录）

```powershell
cd C:\Users\xwy12\Desktop\my-project\ai
..\..\cursorEnv\scripts\headroom-switch-cursor-project.ps1 ai
```

脚本会把该子项目的 OpenAI Base URL **复制到剪贴板**。

### 3. 粘贴到 Cursor

`Settings > Models > Override OpenAI Base URL` → 粘贴 → 保存。

> Cursor 全局只有一处 Base URL，**换子项目时需重新切换**（运行 switch 脚本即可）。

---

## 三、脚本索引

| 脚本 | 作用 |
|------|------|
| `scripts/headroom-start-proxy.ps1` | 后台启动本地代理 |
| `scripts/headroom-init-project.ps1` | 单项目：RTK + `.headroom/` + 打印 URL |
| `scripts/headroom-map-subprojects.ps1` | 批量配置 my-project 全部子项目 |
| `scripts/headroom-switch-cursor-project.ps1` | 切换当前子项目 Base URL |
| `scripts/headroom-verify-cursor.ps1` | 验证 Base URL、BYOK、代理是否有 LLM 流量 |

### 新子项目加入工作区

1. 在 `headroom-projects.json` 的 `projects` 数组追加一项
2. 运行：

```powershell
.\scripts\headroom-init-project.ps1 -ProjectPath C:\Users\xwy12\Desktop\my-project\新项目名
```

---

## 四、已映射子项目（16 个）

| 项目 | 类别 | OpenAI Base URL |
|------|------|-----------------|
| ai | code | `http://127.0.0.1:8787/p/ai/v1` |
| backtest | code | `http://127.0.0.1:8787/p/backtest/v1` |
| cursorEnv | devtools | `http://127.0.0.1:8787/p/cursorEnv/v1` |
| diary | notes | `http://127.0.0.1:8787/p/diary/v1` |
| EE | code | `http://127.0.0.1:8787/p/EE/v1` |
| exam | notes | `http://127.0.0.1:8787/p/exam/v1` |
| Fate | code | `http://127.0.0.1:8787/p/Fate/v1` |
| finance | code | `http://127.0.0.1:8787/p/finance/v1` |
| food | notes | `http://127.0.0.1:8787/p/food/v1` |
| frontEnd | code | `http://127.0.0.1:8787/p/frontEnd/v1` |
| github | code | `http://127.0.0.1:8787/p/github/v1` |
| Quant-Research | code | `http://127.0.0.1:8787/p/Quant-Research/v1` |
| record | notes | `http://127.0.0.1:8787/p/record/v1` |
| travel | notes | `http://127.0.0.1:8787/p/travel/v1` |
| vibe-trading | code | `http://127.0.0.1:8787/p/vibe-trading/v1` |
| zjuilearn | code | `http://127.0.0.1:8787/p/zjuilearn/v1` |

完整列表见 `headroom-projects.resolved.json`。

---

## 五、每个子项目生成的文件

| 文件 | 说明 |
|------|------|
| `.cursorrules` | RTK 命令优化指引（`headroom wrap cursor --prepare-only` 注入） |
| `.headroom/project.json` | 子项目标记与初始化时间 |
| `.headroom/memory.db` | 首次使用后由代理创建（跨会话记忆） |

建议将 `.headroom/memory.db` 加入各子项目 `.gitignore`。

---

## 六、验证与监控

```powershell
.\scripts\headroom-verify-cursor.ps1 cursorEnv   # 检查 Base URL + BYOK + 代理流量
headroom doctor
headroom savings
start http://127.0.0.1:8787/dashboard
```

Dashboard 按 `/p/{项目名}` 前缀分别统计各子项目 token 节省。

---

## 六点五、让 Cursor 流量真正走 Headroom（BYOK 必做）

> **现状（本机已验证）**：`openAIBaseUrl` 已设为 `http://127.0.0.1:8787/p/cursorEnv/v1`，但 `useOpenAIKey = false` 时，Auto / Composer 等 **Cursor 订阅模型** 仍走 `api2.cursor.sh`，**不会**经过 Headroom，因此 savings 为 0。

### 路径 A：OpenAI BYOK（推荐，与当前 Base URL 一致）

| 步骤 | 操作 |
|------|------|
| 1 | 确保代理运行：`.\scripts\headroom-start-proxy.ps1 -Memory` |
| 2 | 切换子项目 URL：`.\scripts\headroom-switch-cursor-project.ps1 cursorEnv` |
| 3 | Cursor → **Settings → Models → OpenAI** |
| 4 | 打开 **Use OpenAI API Key**（或填入 API Key 并启用） |
| 5 | **Override OpenAI Base URL** 粘贴：`http://127.0.0.1:8787/p/cursorEnv/v1` |
| 6 | 模型选择器里选 **OpenAI 系列 BYOK 模型**（如 `gpt-4o`、`gpt-4.1`），**不要**选 Auto / Composer 订阅路由 |
| 7 | 新开对话，发一条测试消息 |
| 8 | 验证：`.\scripts\headroom-verify-cursor.ps1` → `LLM api_requests > 0` |

### 路径 B：Anthropic BYOK（Claude API 直连）

| 项 | 值 |
|----|-----|
| Anthropic API Key | 你的 `sk-ant-...` |
| Override Base URL | `http://127.0.0.1:8787/p/cursorEnv`（**无** `/v1`） |
| 模型 | 选 Claude BYOK 模型，非 Cursor 托管 Claude |

### 路径 C：继续用 Cursor 订阅（Auto / Composer）

- Headroom **代理层无法拦截** `api2/api5.cursor.sh` 流量
- 仍可享受 **RTK**（`.cursorrules` 里 shell 命令压缩），但 `headroom savings` / Dashboard **不会**显示 LLM 压缩数据

### 链式上游（例如 z.ai GLM）

若 BYOK 实际要走第三方 OpenAI 兼容端点：

```powershell
$env:OPENAI_TARGET_API_URL = "https://api.z.ai/api/coding/paas/v4"
.\scripts\headroom-start-proxy.ps1 -Memory
```

Cursor Base URL 仍填 `http://127.0.0.1:8787/p/cursorEnv/v1`，由 Headroom 转发到 z.ai。

### 生效判定

配置成功后，代理 `/stats` 应出现：

- `api_requests > 0`
- `by_path` 含 `/v1/chat/completions` 或 `/v1/messages`
- `tokens.saved > 0`

---

## 七、可选增强

```powershell
$env:HEADROOM_OUTPUT_SHAPER = "1"
$env:OPENAI_TARGET_API_URL = "https://api.z.ai/api/coding/paas/v4"
.\scripts\headroom-start-proxy.ps1
```

---

## 八、持久化服务（需管理员）

本机 `headroom install apply --preset persistent-service` 因权限不足未安装。可每次手动运行 `headroom-start-proxy.ps1`，或以管理员安装持久服务。

---

## 九、PATH 配置（一次性）

```
C:\Users\xwy12\AppData\Roaming\Python\Python314\Scripts
```
