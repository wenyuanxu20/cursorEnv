# 长篇小说连续性（Wiki canon × 有限记忆）

> 技能：`skills/novel-continuity/` · Wiki：`wiki/novel-writing/`  
> 触发：在**小说工作区**对 Agent 说 `构建小说wiki`

## 是什么

给 Cursor 写长篇用的最小结构：**正文在 `manuscript/`，设定在 `wiki/novel/`，agentmemory 只记极少铁律。**  
不解决「把全书装进模型」；解决的是续写时先读哪几页、什么东西不准写进记忆以免混淆。

## 本机状态

| 项 | 值 |
|----|-----|
| Skill | `~\.cursor\skills\novel-continuity` 与 `~\.agents\skills\novel-continuity` |
| 全局规则 | `~\.cursor\rules\novel-wiki-bootstrap.mdc`（`alwaysApply`，仅脚手架触发词） |
| 小说仓规则 | 脚手架写入该项目 `.cursor/rules/novel-continuity.mdc` |
| 模板 | `skills/novel-continuity/templates/` |

## 新开一部长篇

1. 单独文件夹当工作区（不要和 cursorEnv / 代码仓混用）。
2. 打开 Cursor，说：`构建小说wiki`。
3. 先填 `wiki/novel/05-voice.md`、`01-characters.md`，再写 `manuscript/ch-001.md`。
4. 每章结束后改 `00-continuity-now.md`。

## 查询顺序（续写）

1. `wiki/novel/00-continuity-now.md`
2. 人物 / 时间线 / 伏笔 / 已否决 / 声音
3. 上一章正文
4. 仅核铁律时才 `memory_recall`（`project` = 该文件夹名）

## 记忆：该记 / 不该记

详见技能模板 `memory-policy.md` 与 [wiki/novel-writing/01-memory-policy.md](wiki/novel-writing/01-memory-policy.md)。

**记：** POV、不可逆生死、稳定外观标记、作者禁令。  
**不记：** 章摘要、人物表、过期剧情、正文。

不要开全局 `AGENTMEMORY_INJECT_CONTEXT`。

## 相关

- Skill：`skills/novel-continuity/SKILL.md`
- 脚手架规则：`.cursor/rules/novel-wiki-bootstrap.mdc`
- agentmemory 能力边界：[AGENTMEMORY.md](./AGENTMEMORY.md)
