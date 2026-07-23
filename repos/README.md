# cursorEnv 内置仓库

本目录将 Cursor 环境相关的独立 Git 仓库归并到 [cursorEnv](https://github.com/wenyuanxu20/cursorEnv) 单仓，便于一键克隆与迁移。

| 子目录 | 原独立仓库 | 说明 |
|--------|------------|------|
| [agency-agents](./agency-agents/) | [wenyuanxu20/agency-agents](https://github.com/wenyuanxu20/agency-agents) | 多 Agent 编排规则（162 个 agent） |
| [serenity-bottleneck-hunter](./serenity-bottleneck-hunter/) | [wenyuanxu20/serenity-bottleneck-hunter](https://github.com/wenyuanxu20/serenity-bottleneck-hunter) | Serenity Bottleneck Hunter Skill（mrjie7205） |

## 本地路径

```
cursorEnv/repos/agency-agents/
cursorEnv/repos/serenity-bottleneck-hunter/
```

## 更新子目录

从 fork 拉取最新内容后，同步到本目录并提交 cursorEnv：

```powershell
git -C C:\path\to\agency-agents pull origin main
robocopy C:\path\to\agency-agents C:\path\to\cursorEnv\repos\agency-agents /MIR /XD .git
```
