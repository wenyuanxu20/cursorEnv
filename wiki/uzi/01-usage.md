# 01 · UZI 用法与命令

## 关键结论

| 场景 | 做法 |
|------|------|
| Cursor 任意项目 | 全局 skill 已装；说「深度分析 / quick-scan / 杀猪盘」等触发词 |
| CLI 推荐入口 | `cd ...\github\UZI-Skill` → `python run.py <ticker> --no-browser` |
| 快速扫一眼 | `--depth lite`（1–2 min） |
| 日常研报 | `--depth medium`（默认，5–8 min） |
| IC / 首次覆盖级 | `--depth deep`（15–20 min） |

## 五个技能

| 技能目录 | 何时用 |
|----------|--------|
| `uzi` | 总路由 |
| `deep-analysis` | 全量分析、估值、HTML |
| `investor-panel` | 只要评委投票 |
| `lhb-analyzer` | 龙虎榜 / 游资 |
| `trap-detector` | 杀猪盘 / 炒作 |

## CLI 示例

```powershell
$UZI = "C:\Users\xwy12\Desktop\my-project\github\UZI-Skill"
python "$UZI\run.py" 600519 --depth lite --no-browser
python "$UZI\run.py" 00700.HK --depth medium --no-browser
python "$UZI\run.py" BABA --depth deep --no-browser
```

## 验证全局可见（跨项目）

```powershell
npx skills@latest list -g --agent cursor
```

应含：`uzi`、`deep-analysis`、`investor-panel`、`lhb-analyzer`、`trap-detector`。

## 相关页面

- [00 · 总览](00-overview.md)
- [UZI.md](../../UZI.md)
