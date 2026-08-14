# 小说连续性 · 01 记忆政策

## 定义

规定长篇写作时 **什么进入 agentmemory、什么只留在 wiki/正文**，避免新旧设定被 BM25 一起召回造成混淆。

## 关键结论

### 该记（1–5 句）

| 类型 | 例子 | 字段 |
|------|------|------|
| 叙事铁律 | 限知只跟甲；禁止系统面板 | `type=decision` |
| 不可逆事实 | 乙已死；左耳旧伤 | `type=fact` |
| 作者偏好 | 章末不要鸡汤 | `type=preference` |

`project` = 小说工作区文件夹名。concepts = 书名 slug + 人物或规则名。

### 不该记

- 章摘要、大纲、完整人设 → `wiki/novel/`
- 正文 → `manuscript/`
- 已否决剧情 → `wiki/novel/04-rejected.md`（禁止再 save 成 fact）
- 其它项目的代码记忆

### 召回

续写 **先读 wiki**。`memory_recall` 仅用于核铁律；query 用书名 + 人名 + `constraint`。

不要开 `AGENTMEMORY_INJECT_CONTEXT`。

模板原文：`skills/novel-continuity/templates/memory-policy.md`。

## 证据与来源

- 本机 agentmemory：BM25-only、core 工具、开场 limit 8（`AGENTMEMORY.md`）
- 2026-08-14 评估：记忆层不能当长篇外接海马体

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · 用法](02-usage.md)
- [agentmemory 用法](../agentmemory/01-usage.md)
