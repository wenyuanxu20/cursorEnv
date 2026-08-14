# agentmemory · 04 Notion 同步

## 定义

把 **已分享给 `xwy-notion` 的 Notion 页面** 写入本机 agentmemory 存储；会话开场自动做增量同步。不覆盖未分享页面。

## 关键结论

| 项 | 值 |
|----|-----|
| 记忆主文件 | `cursorEnv/data/state_store.db/mem%3Amemories.bin`（即 `mem:memories.bin`） |
| 配套 | `mem%3Alessons.bin`、`mem%3Aindex%3Abm25.bin`、`mem%3Aaudit.bin` |
| 配置目录 | `%USERPROFILE%\.agentmemory\`（pid、preferences、同步 checkpoint） |
| Checkpoint | `%USERPROFILE%\.agentmemory\notion-sync-state.json` |
| 脚本 | `skills/notion-agentmemory-sync/scripts/sync.py` |
| Skill | `%USERPROFILE%\.cursor\skills\notion-agentmemory-sync\`（并复制到 `~\.agents\skills\`） |
| 全局规则 | `%USERPROFILE%\.cursor\rules\notion-agentmemory-sync.mdc`（`alwaysApply`） |
| 首轮全量 | 2026-08-13：24 页，failed=0 |
| 其后增量 | 2026-08-14：search 25 页，`synced=0 skipped=25`（无未同步变更） |
| 增量命令 | `python …\sync.py` |
| 全量命令 | `python …\sync.py --full` |

Python 访问 `api.notion.com` 须**直连**（清掉 `ALL_PROXY`/`HTTPS_PROXY`）；本机 SOCKS 会导致 TLS 失败。脚本已 `clear_proxy()`。

未分享给 Integration 的页面 search 不到，不会进记忆。记忆 blob **只留本机**，不随 cursorEnv 公开仓库发布。

## 证据与来源

- 脚本实测 2026-08-13：`synced=24 skipped=0 failed=0`
- 根：`AGENTMEMORY.md`、`wiki/notion-mcp/05-environment-and-ops.md`

## 相关页面

- [02 · 本机部署](02-local-deploy.md)
- [03 · 自动调用规则](03-auto-rule.md)
- [Notion MCP 环境](../notion-mcp/05-environment-and-ops.md)
