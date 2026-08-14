# 记忆政策（小说 × agentmemory）

agentmemory 是跨会话便签，**不是**书稿。默认 BM25、开场大约召回 8 条，会把编码项目和过期剧情搜进来。

## 该记（短、硬、少改）

| 类型 | 例子 | `memory_save` 字段 |
|------|------|-------------------|
| 叙事铁律 | 全书限知只跟赵衡 | `type=decision`，concepts=`书名,pov` |
| 不可逆事实 | 林晚已死于 ch-12；左耳旧伤 | `type=fact`，concepts=`书名,林晚` |
| 作者偏好 | 不要系统文、章末不要鸡汤 | `type=preference` |

`project` = 小说工作区文件夹名（slug），禁止写磁盘路径。

## 不该记

- 章摘要、大纲、人物表全文 → `wiki/novel/`
- 正文 → `manuscript/`
- 已否决剧情 → `04-rejected.md`（记进 memory 会造成新旧两版一起被召回）
- 密钥、他人隐私

## 召回怎么用

续写时：**先读 wiki**。只有要核「铁律还在不在」时才 `memory_recall`，query 用书名 + 人名 + `constraint`。

不要开 `AGENTMEMORY_INJECT_CONTEXT`（会把所有项目记忆灌进对话）。
