# 01 · Serenity 用法与命令

## 关键结论

| 场景 | 做法 |
|------|------|
| Cursor 任意项目 | 全局 skill 已装；说「用 Serenity」「产业链卡点」「深度调研主题」等 |
| Theme scan | 给市场 + 主题，要分层排序与候选优先级 |
| 单票挑战 | 「challenge 这只票的 CPO 逻辑」 |
| 本地打分 | `serenity_scorecard.py` |

## 触发示例

```text
用 serenity-skill 深度调研现在 A 股 AI 半导体产业链，
找 5 个最值得优先研究的标的，给出产业链位置、证据、排序理由和主要风险。
```

```text
Use serenity-skill to challenge this company's CPO supplier thesis.
Where does it sit in the chain, what evidence supports it, and what would weaken the idea?
```

## Scorecard

```powershell
$S = "$env:USERPROFILE\.agents\skills\serenity-skill"
python "$S\scripts\serenity_scorecard.py" --template > my-company.json
python "$S\scripts\serenity_scorecard.py" --format md my-company.json
```

## 验证全局可见

```powershell
npx skills@latest list -g --agent cursor
Get-ChildItem "$env:USERPROFILE\.agents\skills\serenity-skill"
```

应含：`serenity-skill`，且目录内有 `references/`、`scripts/` 等（不止 `SKILL.md`）。

## 相关页面

- [00 · 总览](00-overview.md)
- [SERENITY.md](../../SERENITY.md)
