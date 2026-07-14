# 07 · Headroom 与 Token 节约方案对比

## 定义

Headroom 在「节约 LLM Token」生态中的定位：相对 RTK-only、上下文精简库、记忆层方案的差异。

## 关键结论

### Headroom 核心能力

| 能力 | 说明 |
|------|------|
| **CCR** | 可逆压缩 LLM 请求/响应（代理层） |
| **CacheAligner** | 提高 prompt cache 命中率 |
| **RTK** | Shell 输出 token 化压缩（`wrap cursor`） |
| **MCP / wrap** | 与 Cursor、Claude Code 等 IDE 集成 |
| **多项目路由** | `/p/{project}` URL 前缀 |

### 与其他开源方案（简要）

| 项目 | 主要手段 | 与 Headroom 差异 |
|------|----------|------------------|
| **RTK**（独立） | 仅 shell 输出 | Headroom 内置 RTK + 代理 CCR |
| **LeanCTX / Context Mode** | 上下文裁剪、文件选择 | 不改 API 载荷结构；Headroom 在 wire 层压缩 |
| **Caveman**（[JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)） | 提示层：极简口癖，≈−65% **输出** token | 不压缩 API 载荷；与 Headroom 互补。见 [CAVEMAN.md](../../CAVEMAN.md) |
| **Ponytail**（[DietrichGebert/ponytail](https://github.com/DietrichGebert/ponytail)） | 提示层：YAGNI，少写代码（≈−54% LOC） | 不碰 wire 压缩；与 Headroom 互补。见 [PONYTAIL.md](../../PONYTAIL.md) |
| **Claw Compactor / cavemem** | 会话摘要、跨会话记忆 | 偏应用层摘要/记忆；Headroom 偏透明代理 |
| **LLMLingua** | prompt 压缩模型 | 需额外模型；Headroom CCR 无额外推理 |
| **Mem0 / Zep** | 长期记忆 RAG | 互补：Headroom `memory.db` 为会话级，非知识库 |

### Cursor 场景选型建议

| 目标 | 建议 |
|------|------|
| 最大化 LLM token 节省 | Headroom 代理 + **BYOK** + 选对模型 |
| 仅用 Cursor 订阅 | Headroom RTK（`.cursorrules`）仍有价值 |
| 代码库理解省 token | **Graphify** `query`（本仓库 `GRAPHIFY.md`） |
| 长期项目知识 | **LLM Wiki**（本仓库 `wiki/`） |

### 组合使用（cursorEnv 推荐栈）

```text
Graphify query  → 探索代码（~2k tokens）
Headroom proxy  → 压缩 LLM API（BYOK）
Headroom RTK    → 压缩 shell 输出
Caveman         → 压缩 Agent 回复口癖（可选）
Ponytail        → 少写代码 / YAGNI（可选）
wiki/           → 配置与架构事实源
```

## 证据与来源

- Headroom 官方文档：https://headroomlabs-ai.github.io/headroom/
- 会话调研结论（2026-07-03）
- `HEADROOM.md`、`GRAPHIFY.md`

## 争议 / 不确定项

- 各竞品压缩率随模型与任务变化，需本机 `headroom savings` 与 Dashboard 实测。

## 相关页面

- [00 · 总览](00-overview.md)
- [03 · Cursor BYOK](03-byok-cursor.md)
- [Caveman 总览](../caveman/00-overview.md)
- [Ponytail 总览](../ponytail/00-overview.md)
- [../../GRAPHIFY.md](../../GRAPHIFY.md)
