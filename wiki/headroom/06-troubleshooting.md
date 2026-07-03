# 06 · Headroom 排障与验证

## 定义

本页汇总 Headroom × Cursor 集成的常见故障、验证步骤与判定标准。

## 关键结论

### 一键验证

```powershell
cd C:\Users\xwy12\Desktop\my-project\cursorEnv
.\scripts\headroom-verify-cursor.ps1 cursorEnv
```

检查项：

1. `http://127.0.0.1:8787/health` 代理存活
2. `state.vscdb` 中 `openAIBaseUrl` 是否匹配 `/p/{ProjectId}/v1`
3. `useOpenAIKey` / `useClaudeKey` 是否启用
4. `GET /stats` 中 `api_requests` 是否 > 0

### 常见问题

| 现象 | 原因 | 处理 |
|------|------|------|
| `headroom: command not found` | Python Scripts 不在 PATH | 加 `%APPDATA%\Python\Python314\Scripts` 或用脚本（自动加 PATH） |
| 代理启动超时 | 端口占用或 headroom 未安装 | 查 `~\.headroom\logs\proxy-8787.log`；`pip install "headroom-ai[proxy]"` |
| Base URL 正确但 savings=0 | Cursor 订阅模型不走代理 | 启用 BYOK（见 [03-byok-cursor](03-byok-cursor.md)） |
| 换项目后统计错乱 | Cursor 全局仅一处 Base URL | 运行 `headroom-switch-cursor-project.ps1 <新id>` 并重新粘贴 |
| 持久服务安装失败 | 需管理员 | 用手动 `headroom-start-proxy.ps1` 或管理员运行 `headroom install apply` |
| `.headroom/memory.db` 变大 | 正常跨会话记忆 | 加入子项目 `.gitignore`（Hub 已忽略 `*.db`） |

### 代理健康端点

| URL | 用途 |
|-----|------|
| `http://127.0.0.1:8787/readyz` | 启动脚本等待的就绪探针 |
| `http://127.0.0.1:8787/health` | verify 脚本使用 |
| `http://127.0.0.1:8787/dashboard` | 可视化节省统计 |
| `http://127.0.0.1:8787/stats` | JSON 统计（api_requests, tokens.saved, by_path） |

### Cursor 状态数据库

路径：`%APPDATA%\Cursor\User\globalStorage\state.vscdb`  
表：`ItemTable`，键 `src.vs.platform.reactivestorage.browser.reactiveStorageServiceImpl.persistentStorage.applicationUser`

### RTK 单独验证

即使 LLM 不走代理，RTK 仍可通过 Agent 执行带大量输出的 shell 命令观察 token 变化；`headroom savings` 可能仅显示少量 RTK 节省。

## 证据与来源

- `HEADROOM.md` §六、§八
- `scripts/headroom-verify-cursor.ps1`
- `scripts/headroom-start-proxy.ps1`

## 相关页面

- [03 · Cursor BYOK](03-byok-cursor.md)
- [05 · 脚本参考](05-scripts-reference.md)
