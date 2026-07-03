# 启动 Headroom 本地代理（用户级，无需管理员）
# 用法: .\scripts\headroom-start-proxy.ps1 [-Port 8787] [-Memory]

param(
    [int]$Port = 8787,
    [switch]$Memory,
    [switch]$NoWait
)

$ErrorActionPreference = "Stop"

$pythonScripts = Join-Path $env:APPDATA "Python\Python314\Scripts"
if (Test-Path $pythonScripts) {
    $env:Path = "$pythonScripts;$env:Path"
}

$healthUrl = "http://127.0.0.1:$Port/readyz"
try {
    $r = Invoke-WebRequest -Uri $healthUrl -UseBasicParsing -TimeoutSec 2
    if ($r.StatusCode -eq 200) {
        Write-Host "Headroom proxy already running: http://127.0.0.1:$Port" -ForegroundColor Green
        return
    }
} catch {
    # not running
}

$hubDir = Resolve-Path (Join-Path $PSScriptRoot "..")
$logDir = Join-Path $env:USERPROFILE ".headroom\logs"
New-Item -ItemType Directory -Path $logDir -Force | Out-Null
$logFile = Join-Path $logDir "proxy-$Port.log"

$proxyArgs = "proxy --port $Port --host 127.0.0.1"
if ($Memory) { $proxyArgs += " --memory" }

$cmd = "headroom $proxyArgs *> `"$logFile`""
Start-Process -FilePath "powershell.exe" `
    -ArgumentList "-NoProfile", "-WindowStyle", "Hidden", "-Command", $cmd `
    -WorkingDirectory $hubDir

if ($NoWait) {
    Write-Host "Started Headroom proxy in background (log: $logFile)"
    return
}

$deadline = (Get-Date).AddSeconds(45)
while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 1
    try {
        $r = Invoke-WebRequest -Uri $healthUrl -UseBasicParsing -TimeoutSec 2
        if ($r.StatusCode -eq 200) {
            Write-Host "Headroom proxy ready: http://127.0.0.1:$Port" -ForegroundColor Green
            Write-Host "Dashboard: http://127.0.0.1:$Port/dashboard"
            return
        }
    } catch { }
}
Write-Warning "Proxy start timeout. Check log: $logFile"
