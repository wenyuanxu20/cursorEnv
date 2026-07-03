# 02 · Headroom 日常使用

## 定义

在已安装 Headroom 的前提下，每次开发会话的标准三步：启动代理 → 切换子项目 URL → 在 Cursor 粘贴 Base URL。

## 关键结论

### 步骤 1：启动代理

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\headroom-start-proxy.ps1 -Memory
```

| 参数 | 作用 |
|------|------|
| `-Memory` | 启用 `--memory`（跨会话记忆） |
| `-Port` | 默认 8787 |
| `-NoWait` | 不等待 health check |

日志：`%USERPROFILE%\.headroom\logs\proxy-8787.log`

### 步骤 2：切换子项目

在**目标子项目目录**执行（将 `{id}` 换为 `headroom-projects.json` 中的 `id`）：

```powershell
cd C:\Users\xwy12\Desktop\my-project\ai
..\..\cursorEnv\scripts\headroom-switch-cursor-project.ps1 ai
```

脚本将对应 OpenAI Base URL **复制到剪贴板**。

### 步骤 3：粘贴到 Cursor

`Settings → Models → Override OpenAI Base URL` → 粘贴 → 保存。

### 新子项目加入工作区

1. 编辑 `headroom-projects.json`，在 `projects` 数组追加 `{ "id", "path", "category" }`
2. 初始化：

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\headroom-init-project.ps1 -ProjectPath C:\Users\xwy12\Desktop\my-project\新项目名
```

3. 重新生成 resolved URL（可选）：

```powershell
.\scripts\headroom-map-subprojects.ps1
```

### 监控

```powershell
headroom doctor
headroom savings
start http://127.0.0.1:8787/dashboard
```

Dashboard 按 `/p/{项目名}` 分别统计 token 节省。

## 证据与来源

- `HEADROOM.md` §二、§三、§六
- `scripts/headroom-start-proxy.ps1`
- `scripts/headroom-switch-cursor-project.ps1`

## 相关页面

- [03 · Cursor BYOK](03-byok-cursor.md)（LLM 压缩需额外配置）
- [05 · 脚本参考](05-scripts-reference.md)
- [06 · 排障与验证](06-troubleshooting.md)
