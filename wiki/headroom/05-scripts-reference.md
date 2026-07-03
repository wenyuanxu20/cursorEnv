# 05 · Headroom 脚本参考

## 定义

`cursorEnv/scripts/` 下 PowerShell 脚本封装 Headroom CLI，供 Hub 与子项目目录调用。

## 关键结论

| 脚本 | 用法 | 作用 |
|------|------|------|
| `headroom-start-proxy.ps1` | `.\scripts\headroom-start-proxy.ps1 [-Memory] [-Port 8787]` | 后台启动 `headroom proxy`；已运行则跳过 |
| `headroom-init-project.ps1` | `.\scripts\headroom-init-project.ps1 -ProjectPath <绝对或相对路径>` | 单项目：`wrap cursor --prepare-only`、写 `.headroom/project.json`、打印 URL |
| `headroom-map-subprojects.ps1` | `.\scripts\headroom-map-subprojects.ps1` | 按 `headroom-projects.json` 批量 init，生成 `headroom-projects.resolved.json` |
| `headroom-switch-cursor-project.ps1` | `.\scripts\headroom-switch-cursor-project.ps1 <项目id>` | 从 resolved JSON 取 URL，复制 OpenAI Base URL 到剪贴板 |
| `headroom-verify-cursor.ps1` | `.\scripts\headroom-verify-cursor.ps1 [-ProjectId cursorEnv]` | 检查代理 health、Cursor state.vscdb、BYOK、`/stats` LLM 流量 |

### PATH 依赖

脚本自动将 `%APPDATA%\Python\Python314\Scripts` 加入当前进程 PATH（`headroom` CLI）。

一次性用户 PATH 添加：

```text
C:\Users\xwy12\AppData\Roaming\Python\Python314\Scripts
```

### 环境变量（可选）

| 变量 | 用途 |
|------|------|
| `HEADROOM_OUTPUT_SHAPER` | 输出整形（设 `1` 启用） |
| `OPENAI_TARGET_API_URL` | 链式上游 OpenAI 兼容端点 |
| `ANTHROPIC_TARGET_API_URL` | 链式上游 Anthropic 端点 |

在启动代理**之前**设置，由 `headroom-start-proxy.ps1` 继承的子进程读取。

### CLI 常用命令

```powershell
headroom doctor
headroom savings
headroom wrap cursor --prepare-only
headroom proxy --port 8787 --host 127.0.0.1 --memory
```

## 证据与来源

- `scripts/headroom-*.ps1`
- `HEADROOM.md` §三、§七、§九

## 相关页面

- [02 · 日常使用](02-daily-usage.md)
- [06 · 排障与验证](06-troubleshooting.md)
