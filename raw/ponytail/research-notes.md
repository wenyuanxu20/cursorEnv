# Ponytail 调研摘录（raw）

> Ingest 源：2026-07-14。结构化结论见 `wiki/ponytail/` 与根目录 `PONYTAIL.md`。

## 项目

- 仓库：https://github.com/DietrichGebert/ponytail
- 官网：https://ponytail.dev
- License：MIT
- 作者：Dietrich Gebert

## 做什么

- Agent skill/plugin：YAGNI 七级阶梯，逼出最小能用实现
- Agentic benchmark：平均约 −54% LOC、−22% tokens、−20% cost、−27% 时间
- 过建场景（date/color picker）可到约 94% 少代码
- 不砍：校验、安全、a11y、防数据丢失

## Cursor 安装（本机采用）

```powershell
npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y
```

安装目录：`%USERPROFILE%\.agents\skills\`  
本机技能：`ponytail`、`ponytail-review`、`ponytail-audit`、`ponytail-debt`、`ponytail-gain`、`ponytail-help`

可选 always-on：拷上游 `.cursor/rules/`（本机未采用，避免与现有规则冲突）。

## 冲突确认（2026-07-14）

- 无 `cursorEnv/ponytail/`
- 无 `.cursor/rules/*ponytail*`
- 安装前 skills 目录无同名项
- 不占用 Headroom `127.0.0.1:8787`
- 与其它已装 skills 技能名不重叠
