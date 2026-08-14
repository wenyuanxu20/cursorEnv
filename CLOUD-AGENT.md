# Cloud Agent · 部署与使用指南

> 官方文档：[Cloud Agent 概览](https://cursor.com/docs/cloud-agent) · [环境配置](https://cursor.com/docs/cloud-agent/setup) · [Builds](https://cursor.com/docs/cloud-agent/builds) · [Secrets](https://cursor.com/docs/cloud-agent/security-network)  
> 配置 Schema：[environment.schema.json](https://cursor.com/schemas/environment.schema.json)  
> 仪表盘：[Cloud Agents](https://cursor.com/dashboard/cloud-agents) · [Environments](https://cursor.com/dashboard/cloud-agents#environments)  
> Wiki：`wiki/cloud-agent/` · 本机对照：`AGENTMEMORY.md`（仅本机）· `HEADROOM.md`（仅本机）  
> 文档日期：2026-08-14

## 是什么

**Cloud Agent** 是 Cursor 在**隔离远程 Ubuntu 虚拟机**上运行的自主编码 Agent。你在 Cursor 桌面端、网页端或 Automations 中下达任务后，Agent 会：

1. 检出指定仓库与分支
2. 在已配置的开发环境中读写代码、运行命令与测试
3. 提交变更并推送分支，通常附带 **Draft PR**
4. 用截图、录屏、终端输出等**可验证证据**说明完成情况

与本地 Agent 相比，Cloud Agent 的优势是**长时间后台执行**、**不占用本机资源**，且可通过 **Environment Builds** 预装依赖，缩短每次启动时间。

## 适用场景

| 场景 | 是否适合 Cloud Agent |
|------|----------------------|
| 修 Issue / 实现明确需求 / 写测试 | ✅ 首选 |
| 跨多文件重构、需跑 CI 或 E2E | ✅ |
| 需要本机 Windows 专有工具（如 `iii.exe`、Headroom 代理） | ⚠️ 需在云端单独配置或改方案 |
| 强依赖本机 `agentmemory` REST `:3111` | ⚠️ Cloud 默认无本机记忆服务；见下文「与 cursorEnv 工具链」 |
| 需访问内网/VPC 服务 | ⚠️ 配 Secrets + Tailscale / Cloudflare Tunnel |
| 探索性对话、快速问答 | 本地 Agent 通常更快 |

## 快速开始（用户侧）

### 1. 从 Cursor 桌面端启动

1. 打开 **Agents** 面板（或 `Cmd/Ctrl + Shift + P` → Cloud Agent 相关命令）
2. 选择 **仓库** 与 **分支**（默认多为 `main`）
3. 选择或创建 **Environment**（见下文「环境配置」）
4. 输入任务描述（越具体越好：目标、约束、验收标准）
5. 提交后可在 [dashboard](https://cursor.com/dashboard/cloud-agents) 查看进度、日志与 PR

### 2. 从网页仪表盘启动

1. 打开 [cursor.com/dashboard/cloud-agents](https://cursor.com/dashboard/cloud-agents)
2. 点击 **New Agent**，选择仓库、分支、模型与环境
3. 任务完成后在 Run 页面查看 diff、Artifacts（截图/视频）与 PR 链接

### 3. 通过 Automations 定时/事件触发

在仪表盘配置 Automation（例如：新 Issue、PR 评论、定时任务），绑定同一 Environment，即可无人值守运行 Cloud Agent。详见 [Automations 文档](https://cursor.com/docs/cloud-agent/automations)。

## 环境配置（Environment）

Cloud Agent 的能力上限 largely 取决于 Environment。配置分两层：

| 层 | 内容 | 典型位置 |
|----|------|----------|
| **基础镜像** | OS、系统包、编译器、Docker 等 | Dockerfile / 显式 `image` / `snapshot` |
| **仓库引导** | 依赖安装、代码生成、启动服务 | `install` / `start` / `terminals` |

### 配置来源与优先级

Cursor 按以下顺序解析（**先匹配先生效**）：

1. 仓库内 **`.cursor/environment.json`**（随分支版本化，团队共享）
2. 个人保存的 Environment（仪表盘）
3. 团队保存的 Environment（仪表盘）

> 提交了 `.cursor/environment.json` 的仓库会**覆盖**仪表盘里的个人/团队环境。改环境前先在 Run 详情或 `environment-info` 确认当前 Agent 实际使用的配置源。

### 推荐路径：Agent 引导创建（新手）

1. 打开 [Environments](https://cursor.com/dashboard/cloud-agents#environments) → **Create environment**
2. 连接 GitHub / GitLab / Azure DevOps / Bitbucket，选一个或多个仓库（**多仓库环境**适合前后端分仓）
3. 在 Secrets 中填入安装与运行所需的 API Key、数据库 URL 等
4. 让 Cursor Agent 在共享终端中安装依赖并验证；成功后生成首个 **Build**
5. 将最终配置 **提交到 `.cursor/environment.json`**，方便全团队复用

### 进阶路径：手写 `environment.json`

最小示例（默认镜像 + 安装依赖）：

```json
{
  "name": "my-project",
  "install": "npm ci"
}
```

带自定义 Dockerfile（路径相对于 `.cursor/`）：

```json
{
  "name": "my-project",
  "build": {
    "dockerfile": "Dockerfile",
    "context": ".."
  },
  "user": "ubuntu",
  "install": "./scripts/cloud-agent-install.sh",
  "start": "sudo service docker start",
  "terminals": [
    {
      "name": "dev",
      "command": "npm run dev"
    }
  ]
}
```

`.cursor/Dockerfile` 示例要点：

- 只装**系统级**稳定依赖；**不要 `COPY` 整个仓库**（源码由 Cursor checkout）
- `install` 脚本须**幂等**、**非交互**、能正常退出
- 开发服务器放 `terminals`，不要放 `install`（否则会阻塞 Build 或进程无法持久）

### `install` / `start` / `terminals` 怎么选

| 字段 | 放什么 | 生命周期 |
|------|--------|----------|
| `install` | `npm ci`、代码生成、编译产物、预热缓存 | Build 时执行；新 Pod 从 Build 快照启动时**不会**重跑（除非触发新 Build） |
| `start` | 启动 Docker、恢复每 boot 必需的后台服务 | 每次 Agent 机器启动时执行 |
| `terminals` | dev server、worker、watch 进程（tmux 会话） | Agent 运行期间保持；Agent 可读写日志 |

常见排障信号：

- **Install 一直不结束** → `install` 里跑了前台服务器或交互命令
- **Build 后文件在但服务没了** → 服务只在 `install` 里启动过
- **每次启动都很慢** → 把装依赖挪回 `install`
- **端口占用 / 重复进程** → `start` 脚本缺少幂等检查

完整字段以 [Schema](https://cursor.com/schemas/environment.schema.json) 为准；**不要**在 `environment.json` 里写 `$schema`（当前 Schema 会拒绝未声明字段）。

## Builds（预构建环境）

[Builds](https://cursor.com/docs/cloud-agent/builds) 在后台执行 `install`，把磁盘状态打成快照。新 Agent **从活跃 Build 启动**，避免每次重新 `npm install`。

| 概念 | 说明 |
|------|------|
| Active Build | 当前环境默认使用的成功 Build |
| Failed Build | 不会替换 Active Build；旧 Agent 仍从上次成功 Build 启动 |
| Draft Build | 测试用配置变更；验证通过后再设为 Active |

变更 `install`、Dockerfile 或基础镜像后，在环境页 **Builds** 标签触发新 Build，查看日志，确认通过后再跑生产任务。

## Secrets 与环境变量

在 [Dashboard → Cloud Agents → Secrets](https://cursor.com/dashboard/cloud-agents) 管理：

- **用户/团队级 Secrets**：所有 Cloud Agent 可读（按权限）
- **Environment-scoped Secrets**：仅绑定到特定 Environment 的 Agent 可读（适合 staging 凭证、多仓环境）

原则：

- **永远不要**把 token、密码、私钥写进 `environment.json`、Dockerfile 或 Git
- 单仓多 `.env.local` 时，在 Secrets 用前缀区分（如 `NEXTJS_*`、`CONVEX_*`）
- 需要登录的应用：把用户名/密码/TOTP secret 一并放入 Secrets（TOTP 可用 `oathtool --totp -b "$TOTP_SECRET"`）
- AWS 深度集成：配置 `CURSOR_AWS_ASSUME_IAM_ROLE_ARN` + IAM Trust Policy（见[官方说明](https://cursor.com/docs/cloud-agent/setup#using-aws-iam-roles)）

## Agent 工作流（分支与 PR）

Cloud Agent 完成任务时的典型 Git 流程：

1. 从任务指定的 base 分支（多为 `main`）创建功能分支，命名如 `cursor/<描述>-<后缀>`
2. 实现、测试、提交（逻辑清晰的 commit message）
3. `git push -u origin <branch>`
4. 创建 **Draft PR**（可在任务里要求「直接 Ready for review」）
5. 在 Run 页面提供 walkthrough 证据（终端输出、截图、录屏）

你在 Review 时关注：

- PR diff 是否只包含任务相关改动
- CI 是否通过
- Artifacts 是否证明功能真的跑通（不只「能编译」）

合并策略由你决定；Agent **不会**擅自 merge 或 force push，除非你明确要求。

## `AGENTS.md` 与仓库规则

Cloud Agent 会读取仓库中的 `AGENTS.md` 与 `.cursor/rules/`。官方建议在 `AGENTS.md` 增加独立章节，例如：

```markdown
## Cursor Cloud specific instructions

- 如何启动开发服务器：`npm run dev`（端口 3000）
- 如何跑测试：`npm test`
- E2E：先 `npm run build`，再 `npx playwright test`
- 本仓库不使用本机 Headroom；Cloud 上直连模型 API
```

cursorEnv 仓库本身的规范见根目录 [AGENTS.md](./AGENTS.md)。若你为其他项目写 Cloud 说明，把**仅 Cloud 有效**的命令与路径写进该项目的 `AGENTS.md`，避免与 Windows 本机路径混淆。

## 与 cursorEnv 工具链的关系

cursorEnv 许多组件面向 **Windows 本机**；Cloud Agent 跑在 **Linux 容器**里，需区别对待：

| 组件 | 本机 Cursor | Cloud Agent |
|------|-------------|-------------|
| **Graphify** | `uv tool install` + `graphify update .` | 可在 `install` 中安装；`graphify-out/` 不入库，每环境本地生成 |
| **agentmemory** | REST `:3111` + MCP `agentmemory` | 默认**无**本机 `iii` 引擎；跨会话记忆靠 PR 描述、Wiki、`AGENTS.md`，或自建远端记忆服务 |
| **Headroom** | `127.0.0.1:8787` 代理 | 不适用；Cloud 使用 Cursor 托管模型路由 |
| **RTK** | `.cursorrules` 要求 shell 前缀 `rtk` | Cloud 镜像未必预装 RTK；可写入 `install` 或 Dockerfile |
| **Notion MCP** | IDE 插件 OAuth | Cloud 需在 Environment 配 `NOTION_TOKEN` 等 Secrets，并检查 MCP allowlist |
| **Skills（全局）** | `%USERPROFILE%\.agents\skills\` | 仅当技能在**仓库内**或 `install` 复制到镜像时才可用 |

给 **cursorEnv 自身** 跑 Cloud Agent 时的建议：

- 任务尽量限定在文档、脚本、wiki 变更，避免依赖 Windows 路径
- 在 `AGENTS.md` 标明 Cloud 上可用的验证命令（如 `python -m pytest`、`npm test`）
- 大文档变更后可在任务中要求 Agent 更新 `wiki/log.md`

## 网络与内网访问

默认 Cloud Agent 可访问公网。若环境启用了 **egress 限制**：

- 在 Environment 配置 `egressAllowlist` 或仪表盘网络策略
- 访问 VPC 内服务： [Tailscale userspace networking](https://cursor.com/docs/cloud-agent/setup#running-tailscale) 或 [Cloudflare Tunnel](https://cursor.com/docs/cloud-agent/setup#running-cloudflare-tunnel)
- 复杂 Docker-in-Docker：参考官方 `fuse-overlayfs` + `iptables-legacy` Dockerfile 片段

## Computer Use（GUI 测试）

Cloud Agent 可对 Web/UI 做手动测试（截图、录屏）。要求：

- Environment 基于 **Debian/Ubuntu** 系镜像
- 浏览器路径可通过 `chromeExecutablePath` 指定
- UI 改动任务应在描述中要求「提供 walkthrough 视频/截图」

## 排障清单

| 现象 | 检查 |
|------|------|
| Agent 立即失败 | Environment Build 是否成功；`start` 是否报错 |
| 依赖找不到 | `install` 是否在 Build 日志里成功；lockfile 是否提交 |
| 测试连不上 DB/API | Secrets 是否绑定到正确 Environment；egress 是否放行 |
| MCP 工具不可用 | `mcpServerAllowlist`、Secrets、`needsAuth` 插件是否已在 Cloud 授权 |
| 用了错误的环境配置 | 是否存在 `.cursor/environment.json` 覆盖了仪表盘配置 |
| PR 缺少证据 | 在任务中写明验收标准与「必须录屏/截图」 |

Build 失败时打开环境 **Builds** 日志，定位最早失败层：镜像构建 → checkout → `install` → `start` / `terminals`。

## 常用链接

| 资源 | URL |
|------|-----|
| Cloud Agents 仪表盘 | https://cursor.com/dashboard/cloud-agents |
| 环境列表 | https://cursor.com/dashboard/cloud-agents#environments |
| 官方 Setup | https://cursor.com/docs/cloud-agent/setup |
| Builds | https://cursor.com/docs/cloud-agent/builds |
| Security & Network | https://cursor.com/docs/cloud-agent/security-network |
| Identity / OIDC | https://cursor.com/docs/cloud-agent/identity |
| environment.json Schema | https://cursor.com/schemas/environment.schema.json |

## 相关页面

- [README.md](./README.md) — cursorEnv 总览与文档索引
- [cursor-env-manifest.json](./cursor-env-manifest.json) — 机器可读部署清单
- [AGENTS.md](./AGENTS.md) — 本仓库 Agent 规范与查询优先级
- [wiki/cloud-agent/00-overview.md](./wiki/cloud-agent/00-overview.md) — Wiki 摘要页
- [wiki/index.md](./wiki/index.md) — 知识库目录
