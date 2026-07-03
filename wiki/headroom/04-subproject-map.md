# 04 · Headroom 子项目映射表

## 定义

`headroom-projects.json` 声明 `my-project` 下所有纳入 Headroom 的子项目；`headroom-projects.resolved.json` 为每个项目生成完整 OpenAI / Anthropic Base URL。

## 关键结论

### 全局参数

| 字段 | 值 |
|------|-----|
| `workspace_root` | `C:\Users\xwy12\Desktop\my-project` |
| `hub` | `cursorEnv` |
| `proxy.host:port` | `127.0.0.1:8787` |
| `path_prefix_pattern` | `/p/{project}` |

### 16 个子项目

| id | category | OpenAI Base URL |
|----|----------|-----------------|
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

Anthropic 模板：`http://127.0.0.1:8787/p/{id}`（无 `/v1`）。

### Hub 标记

`cursorEnv` 项含 `"hub": true`，表示配置脚本与文档的存放目录，非路由特殊项。

### 批量初始化

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\headroom-map-subprojects.ps1
```

为 `workspace_root` 下每个 `projects[].path` 执行 RTK wrap 并写入 `.headroom/project.json`。

## 证据与来源

- `headroom-projects.json`
- `headroom-projects.resolved.json`
- `HEADROOM.md` §四

## 相关页面

- [01 · 架构与路由](01-architecture.md)
- [02 · 日常使用](02-daily-usage.md)
- [05 · 脚本参考](05-scripts-reference.md)
