# Cloud Agent · 01 AstrBot 如何调用 Cursor Agent API

## 定义

本页记录 **my-project/ai 中的 AstrBot** 调用 Cursor Agent 的方式：手机 IM 消息如何进入 Cursor 编码 Agent，以及这与 Windows 本机 Cursor / Fate 飞书 bot 的差别。

## 关键结论

### 调用链（cursorEnv 已核实部分）

| 步 | 组件 | 说明 |
|----|------|------|
| 1 | 手机 IM | AstrBot 适配器收消息 |
| 2 | 阿里云 ECS 上的 AstrBot | 生产入口；**不是** 本机 `Desktop\my-project\ai` 进程 |
| 3 | Cursor CLI（`agent` / `cursor-agent`） | AstrBot 侧通过 CLI 使用 Cursor Agent；CLI 再用 `CURSOR_API_KEY` 访问 Cursor 后端 |
| 4 | MCP `agentmemory` | ECS `agentmemory.service` 独立 store；MCP id 无 `user-` 前缀 |
| 5 | 回写 IM | CLI 文本/JSON 输出回到 AstrBot 再发给用户 |

本机 Windows Cursor（IDE + `:3111` agentmemory + Headroom `:8787`）**不在这条链上**。

### 与「Cloud Agents REST」的关系

| 面 | 本用户 AstrBot | 证据等级 |
|----|----------------|----------|
| Cursor CLI headless（`-p`） | **正在用**（ECS + MCP） | verified in cursorEnv wiki |
| CLI `-c/--cloud`（把任务丢到 Cloud VM） | 未证实 | 插件源码本次未打开 |
| `cursor_sdk` Python（`AsyncAgent`） | 未证实 | 同上 |
| `POST https://api.cursor.com/v0\|v1/agents` | 未证实；cursorEnv **无** 引用 | 同上 |

「Cursor Agent API」在本部署里首先指 **CLI 代打的 Cursor 后端**，不是仪表盘里的 Cloud Agent HTTP 编排 API。二者认证都可用 [Dashboard → API Keys](https://cursor.com/dashboard/api) 的 `CURSOR_API_KEY`，但入口不同。

### 官方 CLI 形态（上游；插件未打开前的对照）

Headless 脚本形态（[官方 headless](https://cursor.com/docs/cli/headless)）：

```bash
export CURSOR_API_KEY=your_api_key_here
agent -p --force --trust --output-format text "用户从 IM 发来的任务"
```

AstrBot 若用 SDK，官方推荐 async（[Python SDK](https://cursor.com/docs/sdk/python)）：

```python
from cursor_sdk import AsyncClient, LocalAgentOptions

async with await AsyncClient.launch_bridge(workspace=cwd) as client:
    async with await client.agents.create(
        api_key=os.environ["CURSOR_API_KEY"],
        local=LocalAgentOptions(cwd=cwd),
    ) as agent:
        run = await agent.send(user_text)
        reply = await run.text()
```

**不要把上面两段当成 ai 仓里已存在的代码。** 它们是官方入口，用来对照下次打开 `ai/AstrBot/data/plugins` 时的实现。

### 三条易混路径

| 路径 | 机器 | 调用物 | 记忆 |
|------|------|--------|------|
| AstrBot 生产 | 阿里云 ECS | Cursor CLI + MCP | ECS `agentmemory.service` |
| 本机 Cursor IDE | Windows | IDE Agent + MCP | `:3111` / `user-agentmemory` |
| Fate 飞书 | Windows | `cursor-agent` + `notion_bridge.py` | 不走 AstrBot |

详页仍在 ai 仓（本仓未复制全文）：`ai/AstrBot/wiki/aliyun/agentmemory.md`。

### 本次未能打开的源码

`wenyuanxu20/ai` 不在 GitHub（当前 token 可见范围）。本 Cloud Agent 环境只有 cursorEnv，因此 **插件文件名、是 subprocess 还是 `cursor_sdk`，尚未用源码钉死**。补全步骤见 `raw/cloud-agent/astrbot-cursor-agent-2026-08-14.md`。

## 证据与来源

| 来源 | 等级 |
|------|------|
| `wiki/agentmemory/03-auto-rule.md`（阿里云 AstrBot = Cursor CLI + 独立 store） | 本仓已核实 |
| `wiki/log.md` 2026-08-13 · 阿里云 AstrBot 部署独立 agentmemory | 本仓已核实 |
| `wiki/notion-mcp/02-feishu-bridge.md`（Fate ≠ AstrBot） | 本仓已核实 |
| `headroom-projects.json` → `ai` 路径 | 本仓已核实 |
| `raw/cloud-agent/astrbot-cursor-agent-2026-08-14.md` | 本次调研 |
| https://cursor.com/docs/cli/headless · https://cursor.com/docs/sdk/python · https://cursor.com/docs/cloud-agent/api/endpoints | 上游文档 |

## 相关页面

- [00 · 总览](00-overview.md)
- [agentmemory · 03 自动调用](../agentmemory/03-auto-rule.md)
- [Notion MCP · 飞书桥接](../notion-mcp/02-feishu-bridge.md)
- 根指南：[CLOUD-AGENT.md](../../CLOUD-AGENT.md)
