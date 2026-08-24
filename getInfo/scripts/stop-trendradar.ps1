# Stop TrendRadar: Docker Compose if present, else the uv HTTP MCP on :3333.
$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
$ComposeDir = Join-Path $GetInfo "TrendRadar\docker"
$Logs = Join-Path $GetInfo "logs"

$composeYml = Join-Path $ComposeDir "docker-compose.yml"
if (Test-Path -LiteralPath $composeYml) {
    $running = docker ps -q --filter "name=trendradar" 2>$null
    if ($running) {
        Push-Location $ComposeDir
        try { docker compose --env-file .env down } finally { Pop-Location }
    }
}

$pidFile = Join-Path $Logs "trendradar-mcp.pid"
if (Test-Path -LiteralPath $pidFile) {
    $procId = Get-Content -LiteralPath $pidFile | Select-Object -First 1
    if ($procId) {
        Stop-Process -Id ([int]$procId) -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -LiteralPath $pidFile -Force -ErrorAction SilentlyContinue
}

Get-NetTCPConnection -LocalPort 3333 -State Listen -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }

Write-Host "TrendRadar stopped."
