# 01 · Caveman 用法与命令

## 定义

Caveman 在 Cursor 全局 skills 安装后的触发方式、强度档位与辅助命令。

## 关键结论

### 开关与档位

| 命令 / 话术 | 作用 |
|-------------|------|
| `/caveman` | 开启，默认 `full` |
| `/caveman lite\|full\|ultra` | 切换强度 |
| `talk like caveman` | 口语开启 |
| `normal mode` / `stop caveman` | 关闭 |

| 档位 | 效果 |
|------|------|
| `lite` | 去填充/客套，保留完整句子 |
| `full` | 去冠词、可用碎片句（默认） |
| `ultra` | 极致压缩 |
| `wenyan-*` | 文言文风格（会改语言形态） |

### 辅助技能

| 命令 | 作用 |
|------|------|
| `/caveman-commit` | 短 Conventional Commit |
| `/caveman-review` | 一行式 PR 评论 |
| `/caveman-compress <file>` | 压缩记忆/规则文件，约 −46% 后续输入 |
| `/caveman-stats` | 节约统计 |
| `/caveman-help` | 帮助 |
| `cavecrew` | 压缩输出子 agent |

### 边界

- 代码块、命令、错误字符串不改写
- 安全警告、不可逆确认、易歧义多步说明：应暂时退出口癖

## 证据与来源

- 上游 README；本机 `~\.agents\skills\caveman\SKILL.md`
- [CAVEMAN.md](../../CAVEMAN.md)

## 相关页面

- [00 · 总览](00-overview.md)
- [Headroom 对比](../headroom/07-comparison.md)
