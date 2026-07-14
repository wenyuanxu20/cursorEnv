# Caveman 调研摘录（raw）

> Ingest 源：2026-07-14。结构化结论见 `wiki/caveman/` 与根目录 `CAVEMAN.md`。

## 项目

- 仓库：https://github.com/JuliusBrussee/caveman
- 官网：https://caveman.so
- License：MIT
- 作者：Julius Brussee

## 做什么

- Agent skill/plugin：压缩 **输出表述**（caveman 口癖）
- 代码 / 命令 / 错误原文保持精确
- 官方 benchmark：输出 token 平均约 −65%
- `caveman-compress`：记忆文件约 −46% 后续输入

## Cursor 安装（本机采用）

```powershell
npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y
```

安装目录：`%USERPROFILE%\.agents\skills\`  
本机技能：`caveman`、`caveman-commit`、`caveman-review`、`caveman-compress`、`caveman-stats`、`caveman-help`、`cavecrew`

## 冲突确认（2026-07-14）

- 无 `cursorEnv/caveman/`
- 无 `.cursor/rules/*caveman*`
- 安装前 skills 目录无同名项
- 不占用 Headroom `127.0.0.1:8787`

## 注意

- wiki/对比页旧文曾误写为「会话摘要」——不正确。会话记忆见同作者 [cavemem](https://github.com/JuliusBrussee/cavemem)。
- 只省输出 token；技能本身约 +1–1.5k 输入/轮。
