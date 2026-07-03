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
headroom doctor
headroom perf
start http://127.0.0.1:8787/dashboard
```

Dashboard 按 `/p/{项目名}` 前缀分别统计各子项目 token 节省。

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
