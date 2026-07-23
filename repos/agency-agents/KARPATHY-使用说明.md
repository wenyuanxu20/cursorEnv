# Karpathy 指南（项目内使用说明）

本仓库已完成 `forrestchang/andrej-karpathy-skills` 的项目级部署，包含以下文件：

- `.cursor/rules/karpathy-guidelines.mdc`（Cursor 项目规则，自动生效）
- `CLAUDE.md`（可复用的根指令文件）
- `CURSOR.md`（Cursor 使用说明）

## 在当前仓库如何生效

1. 用 Cursor 打开本仓库根目录。
2. Cursor 会读取 `.cursor/rules/karpathy-guidelines.mdc`。
3. 因为配置了 `alwaysApply: true`，规则会自动参与对话与编码流程。

## 何时建议修改

- 你希望更贴合团队风格（例如测试策略、提交规范、语言偏好）。
- 你要加入项目特有约束（例如目录边界、API 兼容策略、代码审查要求）。

建议仅在 `.cursor/rules/karpathy-guidelines.mdc` 上做增量修改，并与 `CLAUDE.md` 保持一致，避免多处规则冲突。
