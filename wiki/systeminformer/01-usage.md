# System Informer · 01 用法

## 定义

在 Windows 上用 System Informer 查看后台进程、结束无用项、查文件占用。不要把它当成一键 Debloat。

## 关键结论

| 意图 | 动作 |
|------|------|
| 看谁占 CPU/内存 | 打开进程页，按 CPU 或 Private Bytes 排序 |
| 这是什么程序 | 右键 → Properties：路径、签名、父进程 |
| 结束第三方后台 | 选中进程 → Terminate；先确认数字签名和路径 |
| 杀了又起来 | 记下服务名/启动项，改到 Optimizer 或服务启动类型，不要只 Terminate |
| 文件被占用删不掉 | Find Handles or DLLs，搜文件名 |
| 看网络连接 | 管理员启动后用 Network 页（ExtendedTools 插件） |
| 不要动 | `csrss.exe`、`lsass.exe`、`smss.exe`、核心 `svchost.exe` 服务 |

启动：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File C:\Users\xwy12\Desktop\my-project\cursorEnv\scripts\start-systeminformer.ps1 -RunAsAdmin
```

已在跑则脚本直接退出 0，不重复开窗口。

## 证据与来源

- 便携包 `amd64/README.txt`：直接运行 `SystemInformer.exe`；磁盘/网络插件需管理员
- 根指南：`SYSTEMINFORMER.md`

## 相关页面

- [00 · 总览](00-overview.md)
- [02 · 本机部署](02-local-deploy.md)
