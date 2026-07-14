# 00 · Caveman × Ponytail 总览

## 定义

两个面向 AI Coding Agent 的 **Skills / 提示层** 工具：

- **Caveman**：让 Agent 用极简口癖说话，降低 **输出 token**。
- **Ponytail**：用 YAGNI 七级阶梯约束实现，降低 **写出的代码量**。

二者均安装到 `%USERPROFILE%\.agents\skills\`，不占用本地 HTTP 端口。

## 关键结论

| 项 | Caveman | Ponytail |
|----|---------|----------|
| 上游 | [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman) | [DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail) |
| 本机安装 | 7 skills（含 cavecrew） | 6 skills |
| Cursor 安装命令 | `npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y` | `npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y` |
| 开启 | `/caveman` 或 `talk like caveman` | `/ponytail` 或 `be lazy` / `yagni` |
| 关闭 | `normal mode` / `stop caveman` | `normal mode` / `stop ponytail` |
| 与 Headroom | 互补（提示层 vs 代理层） | 互补（少写代码 vs 少传 token） |

## 证据与来源

- 仓库根 [CAVEMAN-PONYTAIL.md](../../CAVEMAN-PONYTAIL.md)
- `raw/caveman-ponytail/` 调研摘录
- 本机路径：`%USERPROFILE%\.agents\skills\caveman*`、`ponytail*`

## 相关页面

- [01 · 用法与命令](01-usage.md)
- [Headroom 对比](../headroom/07-comparison.md)
- [Matt Pocock Skills](../../MATTPOCOCK-SKILLS.md)
