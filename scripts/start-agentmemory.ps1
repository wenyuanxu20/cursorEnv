# Start agentmemory (Windows): needs iii.exe on PATH and ports 3111/3112/3113/49134 free.
$ErrorActionPreference = "Stop"
$env:CI = "1"
$env:Path = "$env:USERPROFILE\.local\bin;$env:USERPROFILE\.agentmemory\bin;$env:APPDATA\npm;" + $env:Path

# Optional: reuse local proxy for engine/npm fetches
if (-not $env:ALL_PROXY) {
  $env:ALL_PROXY = "socks5://127.0.0.1:7897"
  $env:HTTPS_PROXY = $env:ALL_PROXY
  $env:HTTP_PROXY = $env:ALL_PROXY
}

if (-not (Get-Command iii -ErrorAction SilentlyContinue)) {
  Write-Error "iii.exe not found. Place it at $env:USERPROFILE\.local\bin\iii.exe (v0.11.2)."
}

$health = $null
try {
  $health = Invoke-RestMethod -Uri "http://127.0.0.1:3111/agentmemory/livez" -TimeoutSec 2
} catch {}

if ($health -and $health.status -eq "ok") {
  Write-Host "agentmemory already running on :3111 (viewer :3113)"
  exit 0
}

Write-Host "Starting agentmemory..."
agentmemory --verbose
