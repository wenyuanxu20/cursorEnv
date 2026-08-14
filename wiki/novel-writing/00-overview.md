# 小说连续性 · 00 总览

## 定义

cursorEnv 提供的 **长篇写作脚手架**：小说仓以 `wiki/novel/` 为 canon、`manuscript/` 为正文；本机 agentmemory 只保存短铁律。用来减轻「新对话从零开始」，不宣称能记住整本书。

## 关键结论

| 结论 | 说明 |
|------|------|
| 触发上线 | 任意工作区说 `构建小说wiki`（全局规则 `novel-wiki-bootstrap.mdc`） |
| Skill | `novel-continuity`：续写前读 wiki，写完更新连续性页 |
| 记忆 | 默认 BM25 + 开场约 8 条，**不能**当人物表 |
| 隔离 | 小说用独立工作区；`memory_save` 的 `project` 用该文件夹名 |
| 模板 | `skills/novel-continuity/templates/` |

## 证据与来源

- 根指南：`NOVEL-WRITING.md`
- 技能：`skills/novel-continuity/`
- 能力边界：`wiki/agentmemory/01-usage.md`、会话结论 2026-08-14

## 相关页面

- [01 · 记忆政策](01-memory-policy.md)
- [02 · 用法](02-usage.md)
- [agentmemory 总览](../agentmemory/00-overview.md)
