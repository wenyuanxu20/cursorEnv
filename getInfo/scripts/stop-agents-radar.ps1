# Stop local agents-radar digest API on :3355.
$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
$PidFile = Join-Path $GetInfo "logs\agents-radar.pid"

if (Test-Path -LiteralPath $PidFile) {
    $procId = Get-Content -LiteralPath $PidFile | Select-Object -First 1
    if ($procId) {
        Stop-Process -Id ([int]$procId) -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -LiteralPath $PidFile -Force -ErrorAction SilentlyContinue
}

Get-NetTCPConnection -LocalPort 3355 -State Listen -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }

Write-Host "agents-radar stopped."
