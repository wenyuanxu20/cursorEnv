# UZI Skill 调研与部署笔记

- 日期：2026-07-15
- 上游：https://github.com/wbh604/UZI-Skill
- 决策：与 Caveman/Ponytail 一致，用 `npx skills add … -g` 全局安装，跨 headroom 子项目复用；整仓克隆到 `my-project/github/UZI-Skill` 作为 CLI 运行时。
- 坑：本机 `npx skills add wbh604/UZI-Skill` 经 SOCKS 时 git schannel TLS 失败；改用 `http://127.0.0.1:7897` + `git -c http.proxy=… clone` 后本地路径安装成功。
- 安装结果：5 skills → `~\.agents\skills\`；`pip install -r requirements.txt`（清华源）成功；`run.py --help` 正常。
