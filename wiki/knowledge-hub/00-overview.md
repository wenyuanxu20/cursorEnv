# 跨项目知识库总览（knowledge-hub）

## 定义

`C:\Users\xwy12\Desktop\my-project\knowledge-hub` 是 **my-project 全部子项目** 的 LLM Wiki / raw / schema / AGENTS / Graphify **总览目录**。各项目路径下的原文件保留；wiki 类文件是副本，`graphify-out` 是目录联接（junction）。

## 关键结论

| 项 | 值 |
|----|------|
| 总览根 | `C:\Users\xwy12\Desktop\my-project\knowledge-hub` |
| 项目镜像 | `knowledge-hub/projects/{相对路径}/` |
| 目录 | `knowledge-hub/INDEX.md` |
| 同步脚本 | `knowledge-hub/sync.ps1` |
| 默认方向 | 项目 → hub；hub 改完加 `-FromHub` |
| Graphify | hub 内为 junction，在项目根 `graphify update .` 即可两边可见 |
| agentmemory | **不镜像**；仍走本机 `:3111`，禁止拷 blob |
| 全局规则 | `%USERPROFILE%\.cursor\rules\knowledge-hub-dual-update.mdc`（`alwaysApply`） |

改 wiki / ingest / 小说 canon 之后必须跑 sync，禁止只改一侧。

```powershell
powershell -File C:\Users\xwy12\Desktop\my-project\knowledge-hub\sync.ps1 -Project cursorEnv
```

**禁止**在资源管理器删除 hub 里的 `graphify-out`（会删到项目原目录）。只移除联接：`cmd /c rmdir <hub>\projects\<项目>\graphify-out`

## 证据与来源

- 总览说明：`C:\Users\xwy12\Desktop\my-project\knowledge-hub\README.md`
- 全局规则：`%USERPROFILE%\.cursor\rules\knowledge-hub-dual-update.mdc`
- 本仓副本：`.cursor/rules/knowledge-hub-dual-update.mdc`

## 相关页面

- 目录：`wiki/index.md`
- [agentmemory · 03 自动调用](../agentmemory/03-auto-rule.md)
- 根指南：[GRAPHIFY.md](../../GRAPHIFY.md)、[AGENTMEMORY.md](../../AGENTMEMORY.md)、[FIRECRAWL.md](../../FIRECRAWL.md)、[TRENDRADAR.md](../../TRENDRADAR.md)、[SCRAPLING.md](../../SCRAPLING.md)
