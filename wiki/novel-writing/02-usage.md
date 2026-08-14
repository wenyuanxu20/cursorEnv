# 小说连续性 · 02 用法

## 定义

如何从零搭一个小说仓，以及每章怎么写才不会把 canon 写散。

## 关键结论

### 搭建

1. 新建独立文件夹并作为 Cursor 工作区。
2. 对 Agent 说：`构建小说wiki`。
3. 确认出现 `wiki/novel/`、`manuscript/`、`.cursor/rules/novel-continuity.mdc`。
4. 先填声音与人物，再写 `manuscript/ch-001.md`。

若脚手架未装：从 `cursorEnv/skills/novel-continuity/templates/` 手工复制。

### 每章

```
读 00-continuity-now → 读相关设定页 → 读上一章 → 写本章 → 更新 00/02/03 → log
铁律有新增才 memory_save
```

冲突时停笔，改 wiki，不要在正文里默默改设定。

### 与 LLM wiki 关系

`构建LLM wiki` 仍是通用知识库脚手架。小说页固定在 `wiki/novel/`，不要和 `wiki/headroom/` 一类工具文档混写。

## 证据与来源

- 规则：`.cursor/rules/novel-wiki-bootstrap.mdc`
- 技能：`skills/novel-continuity/SKILL.md`

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 记忆政策](01-memory-policy.md)
