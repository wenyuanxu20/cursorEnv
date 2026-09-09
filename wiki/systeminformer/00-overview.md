# System Informer · 00 总览

## 定义

**System Informer**（上游 [winsiderss/systeminformer](https://github.com/winsiderss/systeminformer)，MIT，原 Process Hacker）是 Windows 开源进程 / 服务 / 句柄管理器。cursorEnv 用官方 GitHub Releases **便携包**部署到 `tools/systeminformer/`，用来查看和结束后台无用进程。

## 关键结论

| 结论 | 说明 |
|------|------|
| 按需安装 | `cursor-env-manifest.json` 中 `necessity=按需`；Windows GUI，不是 Cursor MCP |
| 钉选 | `v4.0.26241.138` 便携 zip，SHA256 见 `SYSTEMINFORMER.md` |
| 落盘 | `tools/systeminformer/amd64/SystemInformer.exe`（二进制 gitignore） |
| 安装 | `scripts/install-systeminformer.ps1` |
| 启动 | `scripts/start-systeminformer.ps1`（磁盘/网络细节加 `-RunAsAdmin`） |
| 与 Optimizer | SI 管正在运行的进程；Optimizer 管服务启动类型与隐私开关 |
| Cloud Agent | Linux 上不能跑 GUI；只验证 zip 哈希 |

## 证据与来源

| 来源 | 路径 |
|------|------|
| 根指南 | `SYSTEMINFORMER.md` |
| 安装脚本 | `scripts/install-systeminformer.ps1` |
| 原始笔记 | `raw/systeminformer/research-notes.md` |
| 上游 | https://github.com/winsiderss/systeminformer |

## 相关页面

- [01 · 用法](01-usage.md)
- [02 · 本机部署](02-local-deploy.md)
- 目录：`wiki/index.md`
