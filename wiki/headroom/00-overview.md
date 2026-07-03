# 00 · Headroom 总览

## 定义

**Headroom**（[headroomlabs-ai/headroom](https://github.com/headroomlabs-ai/headroom)，Apache 2.0）是面向 LLM 工作流的 **Token 压缩与路由** 工具链：本地代理拦截 API 请求做 CCR 可逆压缩、CacheAligner、内容感知路由；并通过 **RTK** 优化 Agent 发出的 shell 命令输出。

在 `my-project` 工作区中，**cursorEnv** 担任 Headroom 配置中枢：一个本地代理服务全部 16 个子项目，通过 Base URL 路径前缀 `/p/{项目名}` 区分上下文。

## 关键结论

| 项 | 本机状态 |
|----|----------|
| CLI 版本 | `headroom` v0.28.0（`pip install "headroom-ai[proxy]"`） |
| 代理地址 | `http://127.0.0.1:8787` |
| Dashboard | `http://127.0.0.1:8787/dashboard` |
| 配置中枢 | `C:\Users\xwy12\Desktop\my-project\cursorEnv` |
| 子项目数 | 16（见 [04-subproject-map](04-subproject-map.md)） |
| RTK | `%USERPROFILE%\.headroom\bin\rtk.exe`，经 `headroom wrap cursor` 注入各子项目 `.cursorrules` |
| 持久 Windows 服务 | 未安装（权限不足）；用手动 `headroom-start-proxy.ps1` |

### 两类节省

| 机制 | 作用层 | Cursor 订阅用户能否享受 |
|------|--------|-------------------------|
| **RTK** | Shell 命令输出压缩（`.cursorrules`） | ✅ 可以 |
| **代理 CCR** | LLM API 请求/响应压缩 | ❌ 需 BYOK（见 [03-byok-cursor](03-byok-cursor.md)） |

## 证据与来源

- `HEADROOM.md` §一、§六
- `headroom-projects.json`
- `cursor-env-manifest.json` → `configs[].file: HEADROOM.md`

## 相关页面

- [01 · 架构与路由](01-architecture.md)
- [02 · 日常使用](02-daily-usage.md)
- [03 · Cursor BYOK](03-byok-cursor.md)
- [../index.md](../index.md)
