# Cursor Rules 备份日志

| 日期 | 操作 | 源路径 | 备份路径 |
|------|------|--------|----------|
| 2026-06-26 | 更新 | `agency-agents.md` | `cursor-rules/latest/docs/agency-agents.md` |
| 2026-06-26 | 更新 | `.cursor/rules/agency-agent-router-beginner.mdc` | `cursor-rules/latest/rules/agency-agent-router-beginner.mdc` |
| 2026-06-26 | 更新 | `C:\Users\xwy12\.cursor\rules\agency-agent-router-beginner.mdc` | `cursor-rules/latest/rules/agency-agent-router-beginner--global.mdc` |
| 2026-06-26 | 新增 | `.cursor/rules/cursor-rules-auto-backup.mdc` | `cursor-rules/latest/rules/cursor-rules-auto-backup.mdc` |
| 2026-06-26 | 新增 | `C:\Users\xwy12\.cursor\rules\cursor-rules-auto-backup.mdc` | `cursor-rules/latest/rules/cursor-rules-auto-backup--global.mdc` |
| 2026-06-28 | quant2026/.cursor/rules/agency-agent-router-beginner.mdc | latest/rules/ | 部署+备份（修复 quant2026 未声明 agent） |
| 2026-06-28 | agency-agents/.cursor/rules/*.mdc (122) | quant2026/.cursor/rules/ | 批量部署全部 agency-agents 规则到 quant2026（默认 alwaysApply:false 按需调用） |
| 2026-06-28 | 部署 | `cursorEnv/.cursor/rules/llm-wiki-bootstrap.mdc` | `quant2026/.cursor/rules/llm-wiki-bootstrap.mdc` |
| 2026-06-28 | 备份 | `quant2026/.cursor/rules/llm-wiki-bootstrap.mdc` | `cursor-rules/latest/rules/llm-wiki-bootstrap--quant2026.mdc` |
| 2026-07-01 | 新增 | `.cursor/rules/cursor-git-rules.mdc` | `cursor-rules/latest/rules/cursor-git-rules.mdc` |
