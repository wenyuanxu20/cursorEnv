# Bottleneck Hunter 调研与部署笔记

- 日期：2026-07-15
- 上游：https://github.com/xbtlin/ai-berkshire · skill：`bottleneck-hunter`
- 发现页：https://skills.sh/xbtlin/ai-berkshire/bottleneck-hunter
- 决策：与 Serenity/UZI 一致，`-g` 全局装 Cursor；整仓 clone 到 `github/ai-berkshire` 供 `tools/` 使用。
- 坑：直连/`schannel` clone 失败；`http.sslBackend=openssl` + `http://127.0.0.1:7897` 成功。CLI 只复制 `SKILL.md`（该 skill 即为单文件工作流）。
- 安装结果：`~\.agents\skills\bottleneck-hunter`（SKILL.md + LICENSE + RUNTIME.md）；整仓 depth-1 clone 完成。
