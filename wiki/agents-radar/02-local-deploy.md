# agents-radar · 02 本机部署

## 定义

Windows：启动脚本拉起 stdlib HTTP。阿里云：systemd `getinfo-agents-radar`，Python 用已有 TrendRadar 3.12 venv。都不打开公网端口。

## 关键结论

| 环境 | 怎么起 |
|------|--------|
| Windows | `powershell.exe -File .\getInfo\scripts\start-agents-radar.ps1` |
| 停止 | `stop-agents-radar.ps1` |
| AstrBot 插件 | `install-astrbot-agents-radar.ps1` → 重载插件 → `/radar_bind` |
| 阿里云 | `python ai/cloudsurver/_deploy_agents_radar_aliyun.py` |
| ECS 路径 | `/opt/getInfo/scripts/agents-radar-serve.py` · unit `getinfo-agents-radar` |
| 完整 git clone | **可选**。上游 zip 含全部历史日报（数十 MB），GitHub 在本机/ECS 常被拦；服务不依赖检出 |

整仓 clone 失败时（SSL / SOCKS 超时）不影响部署：日报走 jsDelivr / Pages。

## 证据与来源

- 启动脚本：`getInfo/scripts/start-agents-radar.ps1`
- 阿里云：`ai/cloudsurver/_deploy_agents_radar_aliyun.py`
- 上游：https://github.com/duanyytop/agents-radar

## 相关页面

- [00 · 总览](00-overview.md)
- [01 · 用法](01-usage.md)
- [03 · 自动调用与推送](03-auto-rule.md)
