# 01 · Serenity Bottleneck Hunter 用法

## 关键结论

| 场景 | 做法 |
|------|------|
| Cursor | `用 Serenity 瓶颈猎手方法分析「AI 数据中心电力」` |
| 显式技能名 | `使用 serenity-bottleneck-hunter 分析「人形机器人」` |
| 价格 | `scripts/price.py`（EODHD→yfinance）；禁 WebSearch 猜价 |
| 交付前 | `python scripts/verify_report.py …` |

## 触发示例

```text
用 Serenity 瓶颈猎手方法分析「AI 数据中心电力」主题，给出候选标的和论证。
使用 serenity-bottleneck-hunter 分析「人形机器人」产业链，寻找被忽视的上游瓶颈股。
```

## 验证

```powershell
npx skills@latest list -g --agent cursor
Get-ChildItem "$env:USERPROFILE\.agents\skills\serenity-bottleneck-hunter"
```

应含：`SKILL.md`、`reference/`、`scripts/`、`tracking/`、`agents/`。

## 相关页面

- [00 · 总览](00-overview.md)
- [SERENITY-BOTTLENECK-HUNTER.md](../../SERENITY-BOTTLENECK-HUNTER.md)
