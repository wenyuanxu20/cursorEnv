# Caveman / Ponytail 调研摘录（raw）

> Ingest 源：2026-07-14 会话调研。结构化结论见 `wiki/caveman-ponytail/` 与根目录 `CAVEMAN-PONYTAIL.md`。

## Caveman（JuliusBrussee/caveman）

- 类型：Agent skill/plugin（Claude Code、Cursor、Windsurf、Cline、Copilot 等 30+）
- 作用：压缩 **输出表述**，代码/命令/错误保持原文；官方均值约 −65% 输出 token
- Cursor：`npx skills add JuliusBrussee/caveman -a cursor`
- Windows 全量：`irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex`
- 生态：caveman-code（整 agent）、cavemem（记忆）、cavekit（构建环）
- 注意：wiki 旧文曾误写为「会话摘要」——那更接近摘要/记忆类工具；Caveman 本身是口癖压缩

## Ponytail（DietrichGebert/ponytail）

- 类型：Agent skill/plugin + 多平台 rules
- 作用：YAGNI 七级阶梯，优先原生/标准库/已有代码；agentic 均值约 −54% LOC、−20% cost
- Cursor：skills 安装或拷 `.cursor/rules/`；指令型宿主无 slash 命令，靠 always-on rules
- 与 Caveman 对照：官方 agentic 表里 caveman 作「短散文对照」时 LOC −20%、token 反而可能略增；ponytail 在少写代码上更强
- 安全边界：校验 / 安全 / a11y / 数据丢失处理不砍

## 本机部署决策

- 路径：`%USERPROFILE%\.agents\skills\`（与 mattpocock 同层）
- 确认无 `cursorEnv/caveman|ponytail`、无已有同名 rules、不占用 Headroom 8787
- 安装：`npx skills@latest add … -g -a cursor --copy -y`（Caveman 7 + Ponytail 6）
