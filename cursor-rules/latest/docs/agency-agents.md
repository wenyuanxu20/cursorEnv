# Agency Agents 从 0 开始使用指南

这份文档面向你当前这个 Cursor 项目，目标是用最少步骤把 `agency-agents` 真正用起来，而不是只把规则文件放进项目里。  
文档已按“新手优先”优化：**默认先自动帮你选 agent，你也可以随时手动指定。**

## 1. 你当前已经完成了什么

当前项目路径：

`C:\Users\xwy12\Desktop\my-project\github\agency-agents`

已经完成的部署内容：

- 已克隆官方仓库到当前目录
- 已生成 Cursor 规则目录：`.cursor/rules`
- 已生成全部 agent 对应的 `.mdc` 规则文件

这意味着你现在已经可以在 Cursor 里直接调用这些 agent。

## 2. 我为你预设的常用 agent 组合

为了避免 162 个规则全部一起生效，我给你整理成了 3 个主力常驻 agent + 4 个按需调用 agent。

### 常驻主力

这 3 个 agent 已经设置为 `alwaysApply: true`：

- `software-architect`
  - 用途：做技术方案、模块边界、系统设计、长期可维护性判断
  - 适合：后端、前端、全栈、重构、框架选型

- `ui-designer`
  - 用途：界面一致性、视觉设计、组件体系、样式质量
  - 适合：页面、组件、样式、设计系统

- `reality-checker`
  - 用途：质量把关、上线前审视、避免“看起来可以其实不行”
  - 适合：代码完成后复查、交付前检查、发现隐藏风险

### 按需调用

下面这些没有设为常驻，但我给它们补了适配范围，建议需要时显式使用：

- `frontend-developer`
  - 用途：React/Vue/前端组件与性能优化

- `backend-architect`
  - 用途：接口、数据库、后端服务、稳定性与安全性

- `ux-architect`
  - 用途：交互结构、信息架构、布局与 UX 技术落地

- `evidence-collector`
  - 用途：偏 QA 的证据式检查，强调截图/验证/复核

## 2.1 新手默认规则：先自动选 agent（你可覆盖）

当你提问题时，默认走下面这套规则：

1. **你没有写 `@agent`**  
   我先自动判断任务类型，**在回答开头明确写出选中的 agent**（主 agent + 备选 agent + 理由），然后直接继续执行。

2. **你写了 `@agent`**  
   以你指定为准（手动优先）。如果明显不匹配，我会先提醒风险，再按你的选择执行。

3. **你想自己选但不确定**  
   你可以说“先推荐，我来选”，我会先给 2-3 个候选和理由，再等你拍板。

### 自动判断映射（简版）

- 方案设计 / 架构拆分 / 重构边界 -> `@software-architect`
- 前端实现 / 组件重构 / 页面性能 -> `@frontend-developer`
- 后端接口 / 数据库 / 稳定性策略 -> `@backend-architect`
- 视觉样式 / UI 一致性 -> `@ui-designer`
- 交互流程 / 信息架构 / 可用性 -> `@ux-architect`
- 测试证据 / 缺陷清单 / 验收复核 -> `@evidence-collector`
- 上线判断 / 风险评审 / 最终把关 -> `@reality-checker`

### 自动选择后的回答格式（必须可见）

当系统自动选择 agent 时，回答开头必须出现这一行：

```text
主Agent: @frontend-developer | 备选: @software-architect | 理由: 你的问题是页面组件重构，优先前端实现专家。
```

如果你手动指定了 agent，则标注：

```text
主Agent: @backend-architect（手动指定）
```

## 3. 在 Cursor 里怎么调用（自动优先，手动可控）

你有 3 种调用方式：

### 方式 A：自动模式（推荐新手）

不写 `@agent`，直接描述问题：

```text
我要做一个登录页，先帮我自动选择最合适的 agent，再开始。
```

```text
这个功能报错了，你先判断该用哪个 agent 来处理，然后直接修。
```

### 方式 B：手动模式（你自己决定）

最直接的方式是在对话里显式提及 agent。

示例：

```text
@software-architect 帮我设计这个模块的目录结构和边界。
```

```text
@frontend-developer 把这个页面重构成可复用组件，并优化性能。
```

```text
@ui-designer 重新整理这个页面的视觉层级、间距和按钮样式。
```

```text
@ux-architect 帮我把这个页面的信息架构和交互流程理顺。
```

```text
@backend-architect 为这个功能设计 API、数据库表和错误处理策略。
```

```text
@evidence-collector 从 QA 角度检查这个页面，列出问题。
```

```text
@reality-checker 判断这个功能是否真的可以上线，并说明风险。
```

### 方式 C：半自动模式（先推荐再选择）

```text
先推荐最适合的 2 个 agent，并说明理由，我来选一个执行。
```

## 4. 推荐使用方式

不要一上来就同时点很多 agent。最稳的工作流是：

1. 先用“自动模式”让系统判断主 agent
2. 方案阶段优先 `@software-architect`
3. UI 页面相关任务交给 `@ui-designer` 或 `@ux-architect`
4. 实现时按方向使用 `@frontend-developer` 或 `@backend-architect`
5. 完成后用 `@evidence-collector` 和 `@reality-checker` 做复查

你可以把它理解成一个简单链路：

`方案 -> 设计 -> 实现 -> 质保`

## 5. 一个最实用的新手工作流

假设你要从 0 做一个功能，比如“新增一个登录页”。

你可以这样用：

### 第一步：先定方案

```text
@software-architect 我准备做一个登录页，请先给我一个最小可行方案，包括页面职责、接口边界、状态流转和异常场景。
```

### 第二步：补设计与交互

```text
@ui-designer 基于这个登录页方案，输出一个简洁专业的 UI 方向，包括布局、配色、按钮、输入框和错误提示风格。
```

```text
@ux-architect 帮我补充登录页的信息层级、交互流程、表单校验和移动端体验建议。
```

### 第三步：进入实现

如果是前端：

```text
@frontend-developer 根据当前代码结构直接实现登录页，并保持组件可复用。
```

如果同时涉及接口：

```text
@backend-architect 为登录页设计对应的登录接口、错误码和数据库/会话策略。
```

### 第四步：做验收

```text
@evidence-collector 站在 QA 角度检查这个登录页，列出具体问题和验证建议。
```

```text
@reality-checker 评估这个登录页是否可以交付，指出仍然存在的风险和缺口。
```

## 6. 什么时候该用哪个 agent

### 软件开发专家

优先用：

- `@software-architect`

实现落地时补充用：

- `@frontend-developer`
- `@backend-architect`

适用问题：

- “这个功能怎么拆模块？”
- “现在目录结构合理吗？”
- “这个接口应该怎么设计？”
- “这段代码要不要重构？”

### UX/UI 与创意设计专家

优先用：

- `@ui-designer`

交互/结构层面补充用：

- `@ux-architect`

适用问题：

- “这个页面为什么看着乱？”
- “组件样式怎么统一？”
- “移动端布局怎么调整？”
- “这个交互流程是否顺手？”

### 质保专家

优先用：

- `@reality-checker`

更细的 QA 复查：

- `@evidence-collector`

适用问题：

- “这个功能真的能上线吗？”
- “还有哪些隐藏问题？”
- “有没有测试盲区？”

## 7. 如何查看和修改规则

所有 Cursor agent 规则都在：

`.\.cursor\rules\`

每个 agent 都对应一个 `.mdc` 文件，例如：

- `.cursor/rules/software-architect.mdc`
- `.cursor/rules/ui-designer.mdc`
- `.cursor/rules/reality-checker.mdc`

一个规则最重要的 3 个字段是：

```yaml
description: 规则说明
globs: 生效文件范围
alwaysApply: 是否常驻生效
```

### 如果你觉得常驻规则太多

把对应文件中的：

```yaml
alwaysApply: true
```

改回：

```yaml
alwaysApply: false
```

### 如果你想让某个 agent 只在特定文件生效

修改 `globs`，例如：

```yaml
globs: "**/*.{tsx,jsx}"
```

## 8. 从官方仓库重新生成规则

官方 README 给出的标准方式是：

```bash
./scripts/convert.sh --tool cursor
./scripts/install.sh --tool cursor
```

但这两个脚本是 bash 脚本，在 Windows 原生 PowerShell 环境里通常需要：

- Git Bash
- 或 WSL

如果以后你装好了 Git Bash / WSL，就可以直接用官方脚本重新生成。

官方说明参考：

- [Agency Agents README](https://github.com/msitarzewski/agency-agents?tab=readme-ov-file#-multi-tool-integrations)
- [Cursor Integration](https://github.com/msitarzewski/agency-agents?tab=readme-ov-file#cursor)

## 9. 给你的最短上手步骤

如果你只想立刻开始，用这 4 句就够了：

1. 在 Cursor 中打开你的项目代码
2. 先问 `@software-architect` 要方案
3. 页面相关让 `@ui-designer` 或 `@ux-architect` 补设计
4. 完成后让 `@reality-checker` 帮你做上线前检查

## 10. 我给你的建议

你当前最适合的使用方式不是“记住全部 agent”，而是先固定这套组合：

- 架构：`@software-architect`
- 前端实现：`@frontend-developer`
- 后端实现：`@backend-architect`
- 视觉设计：`@ui-designer`
- 交互体验：`@ux-architect`
- QA：`@evidence-collector`
- 最终把关：`@reality-checker`

先把这 7 个用熟，基本就够覆盖绝大多数开发任务了。

## 11. 可直接复制的“自动路由”提示词

如果你希望每次都先自动决定 agent，可以直接固定使用这句：

```text
你先根据我的问题自动判断最合适的 agency agent，并在回答开头写明：主Agent / 备选 / 理由，然后直接执行。若我显式写了 @agent，则按我指定执行，并标注“手动指定”。
```

如果你想保留最终决策权，用这句：

```text
你先根据问题推荐 2-3 个最合适的 agency agent，并给出理由，等我选定后再执行。
```

## 12. Cursor 规则自动备份

所有新增或更新的 `.cursor/rules/*.mdc` 会自动备份到：

- 规则：`cursor-rules/latest/rules/`
- 文档：`cursor-rules/latest/docs/`
- 日志：`cursor-rules/backup-log.md`

全局规则（`C:\Users\xwy12\.cursor\rules\`）同样会备份，并额外保存 `--global` 副本。
