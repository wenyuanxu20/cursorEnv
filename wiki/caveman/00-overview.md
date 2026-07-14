# 00 · Caveman 总览

## 定义

**Caveman**（[JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)）是面向 AI Coding Agent 的输出压缩 Skill：用极简口癖说话，降低 **输出 token**，代码 / 命令 / 错误原文保持精确。

## 关键结论

| 项 | 内容 |
|----|------|
| 上游 | https://github.com/JuliusBrussee/caveman |
| 官网 | https://caveman.so |
| License | MIT |
| 本机安装 | 7 个技能（含 `cavecrew`）→ `%USERPROFILE%\.agents\skills\` |
| Cursor 安装 | `npx skills@latest add JuliusBrussee/caveman -g -a cursor --copy -y` |
| 开启 | `/caveman` 或 `talk like caveman` |
| 关闭 | `normal mode` / `stop caveman` |
| 档位 | `lite` / `full`（默认）/ `ultra` / `wenyan-*` |
| 与 Headroom | 互补：Caveman=提示层口癖；Headroom=API/shell 载荷压缩 |
| 冲突结论 | 安装前仓库与规则均无同名部署；不占 `:8787` |

**诚实上限**：只省输出 token；技能本身约 +1–1.5k 输入/轮。极简任务可能净不省。

## 证据与来源

- 仓库根 [CAVEMAN.md](../../CAVEMAN.md)
- `raw/caveman/research-notes.md`
- 本机：`%USERPROFILE%\.agents\skills\caveman*`、`cavecrew`

## 相关页面

- [01 · 用法与命令](01-usage.md)
- [Headroom 对比](../headroom/07-comparison.md)
- [HEADROOM.md](../../HEADROOM.md)
- [MATTPOCOCK-SKILLS.md](../../MATTPOCOCK-SKILLS.md)
