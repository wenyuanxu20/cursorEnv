# 00 · Serenity Skill 总览

## 定义

**Serenity.skill**（[muxuuu/serenity-skill](https://github.com/muxuuu/serenity-skill)）是面向投资研究 Agent 的 **供应链瓶颈猎人**：主题叙事 → 价值链 → 稀缺约束 → 公开公司证据 → 证伪条件。

## 关键结论

| 项 | 内容 |
|----|------|
| 上游 | https://github.com/muxuuu/serenity-skill |
| License | MIT |
| 本机技能 | 1 个 → `%USERPROFILE%\.agents\skills\serenity-skill`（全局） |
| 整仓 | `C:\Users\xwy12\Desktop\my-project\github\serenity-skill` |
| Cursor 安装 | clone 后完整复制运行时目录（勿依赖仅 SKILL.md 的 CLI copy） |
| 校验 | `python scripts/validate_skill.py .` |
| 与 Headroom | 无端口冲突 |
| 冲突结论 | 安装前无同名 skill；未写入项目 `.cursor/rules/` |

**诚实上限**：公开方法论模拟，非券商投研；无下单；需联网工具做「当前」结论。

## 证据与来源

- 仓库根 [SERENITY.md](../../SERENITY.md)
- `raw/serenity/research-notes.md`
- 本机：`~\.agents\skills\serenity-skill`；`github\serenity-skill`

## 相关页面

- [01 · 用法与命令](01-usage.md)
- [UZI.md](../../UZI.md)（个股深度分析，可串联）
