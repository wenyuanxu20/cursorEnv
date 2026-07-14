# 01 · Ponytail 用法与命令

## 定义

Ponytail 在 Cursor 全局 skills 安装后的触发方式、强度档位与辅助命令。

## 关键结论

### 开关与档位

| 命令 / 话术 | 作用 |
|-------------|------|
| `/ponytail` | 开启，默认 `full` |
| `/ponytail lite\|full\|ultra\|off` | 切换强度或关闭 |
| `be lazy` / `yagni` / `do less` | 口语开启 |
| `normal mode` / `stop ponytail` | 关闭 |

| 档位 | 效果 |
|------|------|
| `lite` | 按需求做，并点出更懒替代方案 |
| `full` | 强制阶梯；标准库/原生优先（默认） |
| `ultra` | 极端 YAGNI；先删再加 |
| `off` | 关闭 |

可选默认：`PONYTAIL_DEFAULT_MODE` 或 `%APPDATA%\ponytail\config.json` 的 `defaultMode`。

### 辅助技能

| 命令 | 作用 |
|------|------|
| `/ponytail-review` | 审当前 diff，给可删清单 |
| `/ponytail-audit` | 审整仓过度工程 |
| `/ponytail-debt` | 汇总 `ponytail:` 延期捷径 |
| `/ponytail-gain` | benchmark 收益摘要 |
| `/ponytail-help` | 命令速查 |

### 七级阶梯

1. 要不要存在？（YAGNI）  
2. 仓库里已有？  
3. 标准库？  
4. 平台原生？  
5. 已装依赖？  
6. 一行？  
7. 否则：最小能用代码  

### Cursor 注意

本机采用 skills 路径（按需触发），**未**拷贝上游 `.cursor/rules/`，以免与现有规则集抢上下文。

## 证据与来源

- 上游 README；本机 `~\.agents\skills\ponytail\SKILL.md`
- [PONYTAIL.md](../../PONYTAIL.md)

## 相关页面

- [00 · 总览](00-overview.md)
- [Headroom 对比](../headroom/07-comparison.md)
