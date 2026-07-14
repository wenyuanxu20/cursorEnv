# 00 · Ponytail 总览

## 定义

**Ponytail**（[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)）是面向 AI Coding Agent 的 YAGNI Skill：用七级阶梯逼出 **最小能用实现**，降低写出的代码量与过建风险。

## 关键结论

| 项 | 内容 |
|----|------|
| 上游 | https://github.com/DietrichGebert/ponytail |
| 官网 | https://ponytail.dev |
| License | MIT |
| 本机安装 | 6 个技能 → `%USERPROFILE%\.agents\skills\` |
| Cursor 安装 | `npx skills@latest add DietrichGebert/ponytail -g -a cursor --copy -y` |
| 开启 | `/ponytail` 或 `be lazy` / `yagni` |
| 关闭 | `normal mode` / `stop ponytail` |
| 档位 | `lite` / `full`（默认）/ `ultra` / `off` |
| 与 Headroom | 互补：Ponytail=少写代码；Headroom=少传 token |
| 冲突结论 | 安装前仓库与规则均无同名部署；不占 `:8787`；未写入项目 `.cursor/rules/` |

**安全边界**：信任边界校验、防丢数据错误处理、安全、基础 a11y、用户明确要求的完整版 — 不砍。

## 证据与来源

- 仓库根 [PONYTAIL.md](../../PONYTAIL.md)
- `raw/ponytail/research-notes.md`
- 本机：`%USERPROFILE%\.agents\skills\ponytail*`

## 相关页面

- [01 · 用法与命令](01-usage.md)
- [Headroom 对比](../headroom/07-comparison.md)
- [HEADROOM.md](../../HEADROOM.md)
- [MATTPOCOCK-SKILLS.md](../../MATTPOCOCK-SKILLS.md)
