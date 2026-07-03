# 来源标记

本目录为 Headroom 配置的**原始事实源**副本，供 wiki ingest 引用。

| 文件 | 仓库路径 | 说明 |
|------|----------|------|
| HEADROOM.md | `../HEADROOM.md` | 主配置指南（与仓库根同步） |
| headroom-projects.json | `../headroom-projects.json` | 16 子项目映射清单 |
| headroom-projects.resolved.json | `../headroom-projects.resolved.json` | 解析后 OpenAI/Anthropic URL |

> 更新配置时：先改仓库根文件，再更新 `wiki/headroom/` 与 `wiki/log.md`，最后 `graphify update .`。
