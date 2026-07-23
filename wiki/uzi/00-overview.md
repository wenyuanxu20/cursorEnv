# 00 · UZI Skill 总览

## 定义

**UZI（游资）Skill**（[wbh604/UZI-Skill](https://github.com/wbh604/UZI-Skill)）是面向 AI Coding Agent 的 **A/H/美股深度分析** 技能：22 维数据 × 机构模型 × 多投资人 persona → HTML 研报。

## 关键结论

| 项 | 内容 |
|----|------|
| 上游 | https://github.com/wbh604/UZI-Skill |
| License | MIT |
| 本机技能 | 5 个 → `%USERPROFILE%\.agents\skills\`（全局，跨项目） |
| 运行时整仓 | `C:\Users\xwy12\Desktop\my-project\github\UZI-Skill` |
| Cursor 安装 | `npx skills add <本地克隆路径> -g -a cursor --copy -y --full-depth` |
| CLI | `python run.py <ticker> [--depth lite\|medium\|deep]` |
| 与 Headroom | 无端口冲突 |
| 冲突结论 | 安装前无同名 skills；未写入项目 `.cursor/rules/` |

**诚实上限**：全量分析耗时长、耗 token；评委为模拟非真人；非投资建议。

## 证据与来源

- 仓库根 [UZI.md](../../UZI.md)
- `raw/uzi/research-notes.md`
- 本机：`~\.agents\skills\uzi` 等 5 目录；`github\UZI-Skill`

## 相关页面

- [01 · 用法与命令](01-usage.md)
- [CAVEMAN.md](../../CAVEMAN.md) / [PONYTAIL.md](../../PONYTAIL.md)（同类全局 skill 模式）
