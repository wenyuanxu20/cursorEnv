# System Informer · 02 本机部署

## 定义

在 Windows 上把官方便携版解压进 `cursorEnv/tools/systeminformer/`，并校验 GitHub Release 的 SHA256。

## 关键结论

### 布局

| 组件 | 路径 / 值 |
|------|-----------|
| 部署根 | `cursorEnv/tools/systeminformer/` |
| 钉选 | `4.0.26241.138` |
| 包 | GitHub `*-bin.zip`，不是 `*-release-setup.exe` |
| SHA256 | `3e12cc4f1ffa1cc34ab9202a9dfe410724cb8b68aaf2efa43c01d3705b27219e` |
| x64 exe | `tools/systeminformer/amd64/SystemInformer.exe` |
| 状态 | `tools/systeminformer/install-state.json` |
| 安装 | `scripts/install-systeminformer.ps1` |
| 启动 | `scripts/start-systeminformer.ps1` |
| 代理 | 默认 `http://127.0.0.1:7897`（Clash mixed）；失败则直连 |

### 复现步骤

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\scripts\install-systeminformer.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\scripts\start-systeminformer.ps1 -RunAsAdmin
```

已装同一版本且哈希一致时跳过下载。强制重装加 `-Force`。装完立刻启动加 `-Start`。

不要把 `amd64/` 等二进制提交进 Git。

### 本机已验证 / 上游推断

| 项 | 性质 |
|----|------|
| zip SHA256 与 `amd64/SystemInformer.exe` 在官方包内 | Cloud Agent 已验证（2026-09-09） |
| Windows GUI 可启动、管理员插件可用 | 上游文档；待 Windows 本机跑脚本后确认 |
| 从源码编译 | 需 VS2022；本仓不走这条路径 |

### 安全

- 只从 `winsiderss/systeminformer` GitHub Releases 下载，脚本拒绝 SHA256 不符的 zip。
- 内核驱动 `SystemInformer.sys` 随便携包提供；以管理员运行才会加载相关功能。
- 结束系统进程会导致黑屏或登录失败；用法页列了禁止项。

## 证据与来源

- `SYSTEMINFORMER.md`、`scripts/install-systeminformer.ps1`
- `raw/systeminformer/research-notes.md`
- 上游：https://github.com/winsiderss/systeminformer/releases/tag/v4.0.26241.138

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
