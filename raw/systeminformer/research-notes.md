# System Informer 钉选记录

日期：2026-09-09

- 上游：https://github.com/winsiderss/systeminformer
- 选用 GitHub Releases **便携 zip**，不 clone 源码（需 VS2022）。
- 钉选 tag：`v4.0.26241.138`（Latest，published 2026-08-29）
- 资产：`systeminformer-4.0.26241.138-bin.zip`（约 21 MB）
- SHA256：`3e12cc4f1ffa1cc34ab9202a9dfe410724cb8b68aaf2efa43c01d3705b27219e`
- zip 内 x64 入口：`amd64/SystemInformer.exe`（另有 `i386/`、`arm64/`）
- 另有 `*-release-setup.exe` 安装包，本仓脚本不用，避免静默安装器参数差异。
- Cloud Agent 环境为 Linux，只校验下载与哈希；GUI 必须在用户 Windows 本机启动。
