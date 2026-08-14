# 小说连续性脚手架（2026-08-14）

用户确认：现有 agentmemory 不能单独解决长篇记忆丢失/混淆；继续落地「小说仓 wiki 模板 + 记忆该记/不该记」，上线后 push。

决策：

- Canon = `wiki/novel/` + `manuscript/`
- agentmemory 只存铁律
- 全局触发词 `构建小说wiki`
- 小说工作区单独文件夹，避免与 cursorEnv 记忆混搜
