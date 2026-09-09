# System Informer · 本机进程管理器

> 上游：[winsiderss/systeminformer](https://github.com/winsiderss/systeminformer)（MIT，原 Process Hacker）  
> 钉选：GitHub Releases **v4.0.26241.138** 便携包 `*-bin.zip`  
> 安装：`scripts/install-systeminformer.ps1` · 启动：`scripts/start-systeminformer.ps1`  
> 落盘：`tools/systeminformer/`（二进制 gitignore，不入库）

## 是什么

**System Informer** 是 Windows 上的开源进程 / 服务 / 句柄查看器。用来看清后台在跑什么、结束无用进程、查文件占用，比任务管理器细。cursorEnv 用官方 **便携 zip**，不 clone Visual Studio 源码，也不走 winget 以免版本漂。

它不是 Optimizer 那种一键改注册表的工具。Optimizer 改「下次还起不起」；System Informer 管「现在正在跑」。

## 本机约定

| 项 | 值 |
|----|-----|
| 上游 | https://github.com/winsiderss/systeminformer |
| 钉选 | `4.0.26241.138`（tag `v4.0.26241.138`，2026-08-29） |
| 包 | `systeminformer-4.0.26241.138-bin.zip` |
| SHA256 | `3e12cc4f1ffa1cc34ab9202a9dfe410724cb8b68aaf2efa43c01d3705b27219e` |
| 目录 | `cursorEnv/tools/systeminformer/`（`amd64/` 等不入库） |
| 本机 exe（x64） | `tools/systeminformer/amd64/SystemInformer.exe` |
| 状态文件 | `tools/systeminformer/install-state.json` |
| 系统 | Windows 10+（便携包 README 仍写 Win7；上游仓库写 Win10+） |
| 管理员 | 磁盘/网络插件、服务控制、内核驱动需要 |

## 快速开始（Windows）

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\install-systeminformer.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\start-systeminformer.ps1 -RunAsAdmin
```

安装脚本会：经 `http://127.0.0.1:7897` 拉 GitHub Release → 校验 SHA256 → 解压到 `tools/systeminformer/`。代理失败则直连重试。已装同一钉选版本时跳过下载。

加 `-Start` 可在装完后立刻启动；加 `-RunAsAdmin` 以管理员启动。

## 新机器检查清单

1. 在 **Windows** 上打开 `cursorEnv` 仓库（本工具不能在 Linux Cloud Agent 里运行 GUI）。
2. 运行 `scripts/install-systeminformer.ps1`。
3. 确认 `tools/systeminformer/amd64/SystemInformer.exe`（ARM 机用 `arm64/`）存在。
4. `scripts/start-systeminformer.ps1 -RunAsAdmin` 看进程列表。
5. 只结束第三方进程；不要杀 `csrss` / `lsass` / 核心 `svchost`。

## 和 Optimizer 怎么配合

| 工具 | 管什么 |
|------|--------|
| System Informer | 正在运行的进程、句柄、服务状态 |
| hellzerg/optimizer（已 archived） | 服务启动类型、隐私开关、UWP |
| 开机项要持久关掉 | 在 SI 里确认进程名后，再去 Optimizer / 启动项里 Disabled |

不要叠多个 Aggressive 一键优化器。

## 本机已验证 / 上游推断

| 项 | 性质 |
|----|------|
| Release zip SHA256、`amd64/SystemInformer.exe` 存在于官方 bin.zip | Cloud Agent 已验证（2026-09-09，Linux 只校验包，未跑 GUI） |
| 便携、MIT、管理员才能看磁盘/网络细节 | 上游 README / 便携包 README |
| 本机 Windows GUI 已启动 | 需用户在 Windows 跑 `start-systeminformer.ps1` 后才算验证 |
