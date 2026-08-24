# Stop Scrapling HTTP MCP on :3344 if the start script launched it.
$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
$Logs = Join-Path $GetInfo "logs"
$HttpPort = 3344

$pidFile = Join-Path $Logs "scrapling-mcp.pid"
if (Test-Path -LiteralPath $pidFile) {
    $procId = Get-Content -LiteralPath $pidFile | Select-Object -First 1
    if ($procId) {
        Stop-Process -Id ([int]$procId) -Force -ErrorAction SilentlyContinue
    }
    Remove-Item -LiteralPath $pidFile -Force -ErrorAction SilentlyContinue
}

Get-NetTCPConnection -LocalPort $HttpPort -State Listen -ErrorAction SilentlyContinue |
    ForEach-Object { Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue }

Write-Host "Scrapling HTTP MCP stopped (STDIO MCP is started by Cursor on demand)."
