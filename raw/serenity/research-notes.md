# Serenity Skill 调研与部署笔记

- 日期：2026-07-15
- 上游：https://github.com/muxuuu/serenity-skill
- 决策：与 Caveman/Ponytail/UZI 一致，全局装到 `~\.agents\skills\`，跨 headroom 子项目复用；整仓克隆到 `my-project/github/serenity-skill`。
- 坑：`npx skills add muxuuu/serenity-skill -g -a cursor --copy -y`（含 `--full-depth`）本机只落下 `SKILL.md`，缺 `references/`/`scripts/`；按上游 README 手动 `Copy-Item` 完整包后 `validate_skill.py` 通过。
- 安装结果：1 skill → `~\.agents\skills\serenity-skill`（19 文件）；`python scripts/validate_skill.py` → OK。
- 安全扫描（skills.sh）：Gen Safe / Socket 0 / Snyk Med Risk — 使用前自行审阅 scripts。
