# 01 · Headroom 架构与路由

## 定义

`my-project` 采用 **单 Hub 代理 + 多子项目 URL 前缀** 模型：所有子项目共享 `127.0.0.1:8787` 上的一个 Headroom 进程，靠 Base URL 中的 `/p/{project}` 段隔离记忆库与统计。

## 关键结论

### 组件关系

```text
my-project/
├── cursorEnv/          ← Hub：脚本、headroom-projects.json、HEADROOM.md
│   └── scripts/headroom-*.ps1
├── ai/                 ← 子项目：.cursorrules + .headroom/project.json
├── finance/
└── …（共 16 个子项目）
         │
         ▼
   Headroom Proxy :8787
         │
         ├── /p/ai/v1          → OpenAI 兼容上游
         ├── /p/finance/v1
         └── /p/cursorEnv/v1
```

### URL 模板（Cursor 无法发自定义 Header，故用路径前缀）

| 提供商 | Base URL 模板 | 示例（项目 `ai`） |
|--------|---------------|-------------------|
| OpenAI 兼容 | `http://127.0.0.1:8787/p/{project}/v1` | `http://127.0.0.1:8787/p/ai/v1` |
| Anthropic | `http://127.0.0.1:8787/p/{project}` | `http://127.0.0.1:8787/p/ai` |

### 机器可读配置

| 文件 | 字段 |
|------|------|
| `headroom-projects.json` | `proxy`, `url_templates`, `projects[]` |
| `headroom-projects.resolved.json` | 每项含 `openai_base_url`, `anthropic_base_url`（运行 map 脚本生成） |

### 每子项目落地文件

| 路径 | 来源 |
|------|------|
| `.cursorrules` | `headroom wrap cursor --prepare-only` |
| `.headroom/project.json` | `headroom-init-project.ps1` |
| `.headroom/memory.db` | 代理首次使用后创建（跨会话记忆，勿提交 git） |

### Cursor 全局限制

Cursor **仅有一处** OpenAI Base URL（`state.vscdb` → `openAIBaseUrl`）。切换子项目时必须重新运行 `headroom-switch-cursor-project.ps1` 并粘贴新 URL。

## 证据与来源

- `HEADROOM.md` §一、§五
- `headroom-projects.json` → `path_prefix_pattern`, `url_templates`
- `scripts/headroom-init-project.ps1`
- `scripts/headroom-map-subprojects.ps1`

## 相关页面

- [00 · 总览](00-overview.md)
- [04 · 子项目映射表](04-subproject-map.md)
- [02 · 日常使用](02-daily-usage.md)
