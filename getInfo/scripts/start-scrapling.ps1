# Install Scrapling under cursorEnv/getInfo and optionally start HTTP MCP.
# Pin: scrapling[all]==0.4.15  Python 3.12 via uv
# STDIO MCP (Cursor default): getInfo/scrapling/.venv/Scripts/scrapling-mcp.exe
# HTTP MCP (optional -Http): http://127.0.0.1:3344/mcp  (--no-auth, localhost only)
param(
    [int]$HealthTimeoutSec = 60,
    [switch]$SkipBrowsers,
    [switch]$SkipSmoke,
    [switch]$Http,
    [int]$HttpPort = 3344
)

$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $GetInfo "env.example"))) {
    $GetInfo = Join-Path (Split-Path -Parent $PSScriptRoot) "getInfo"
}
$Src = Join-Path $GetInfo "scrapling"
$Logs = Join-Path $GetInfo "logs"
$Uv = Join-Path $env:USERPROFILE ".local\bin\uv.exe"
$McpHttp = "http://127.0.0.1:$HttpPort/mcp"
# Clash mixed port accepts HTTP CONNECT; SOCKS5 makes uv TLS handshake eof on pypi.org.
# Tsinghua simple index lagged 0.4.15 on 2026-08-24, so do not pin this version to tuna.
$HttpProxy = "http://127.0.0.1:7897"

$env:Path = "$env:USERPROFILE\.local\bin;" + $env:Path

function Get-ScraplingCmd {
    $candidates = @(
        (Join-Path $Src ".venv\Scripts\scrapling.exe"),
        (Join-Path $Src ".venv\Scripts\scrapling-mcp.exe")
    )
    foreach ($p in $candidates) {
        if (Test-Path -LiteralPath $p) { return $p }
    }
    return $null
}

function Test-McpReady {
    try {
        $code = & curl.exe -s -o NUL -w "%{http_code}" --max-time 5 `
            -H "Accept: application/json, text/event-stream" $McpHttp
        return ($code -match '^(200|400|405|406)$')
    } catch {
        return $false
    }
}

function Wait-Mcp {
    param([int]$Seconds)
    $deadline = (Get-Date).AddSeconds($Seconds)
    while ((Get-Date) -lt $deadline) {
        if (Test-McpReady) {
            Write-Host "Scrapling MCP ready: $McpHttp"
            return $true
        }
        Write-Host "Waiting for $McpHttp ..."
        Start-Sleep -Seconds 3
    }
    return $false
}

if (-not (Test-Path -LiteralPath $Uv)) {
    throw "uv not found at $Uv. Install uv, then re-run."
}
if (-not (Test-Path -LiteralPath (Join-Path $Src "pyproject.toml"))) {
    throw "Missing $Src\pyproject.toml"
}

Write-Host "uv sync scrapling[all]==0.4.15 (Python 3.12, PyPI via HTTP proxy)..."
$oldProxy = @{
    ALL_PROXY = $env:ALL_PROXY
    HTTPS_PROXY = $env:HTTPS_PROXY
    HTTP_PROXY = $env:HTTP_PROXY
}
# uv + socks5://127.0.0.1:7897 → tls handshake eof; HTTP CONNECT on the same port works.
Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue
$env:HTTPS_PROXY = $HttpProxy
$env:HTTP_PROXY = $HttpProxy
Push-Location $Src
try {
    & $Uv sync --python 3.12
    if ($LASTEXITCODE -ne 0) {
        throw "uv sync from PyPI failed ($LASTEXITCODE). Use HTTP proxy http://127.0.0.1:7897 (not socks5). Tsinghua currently lags 0.4.15."
    }
} finally {
    Pop-Location
    if ($oldProxy.ALL_PROXY) { $env:ALL_PROXY = $oldProxy.ALL_PROXY } else { Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue }
    if ($oldProxy.HTTPS_PROXY) { $env:HTTPS_PROXY = $oldProxy.HTTPS_PROXY } else { Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue }
    if ($oldProxy.HTTP_PROXY) { $env:HTTP_PROXY = $oldProxy.HTTP_PROXY } else { Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue }
}

$scrapling = Get-ScraplingCmd
if (-not $scrapling) {
    throw "scrapling executable not found under $Src\.venv\Scripts"
}

if (-not $SkipBrowsers) {
    Write-Host "scrapling install (Chromium / stealth browsers; may take several minutes)..."
    $oldProxy = @{
        ALL_PROXY = $env:ALL_PROXY
        HTTPS_PROXY = $env:HTTPS_PROXY
        HTTP_PROXY = $env:HTTP_PROXY
    }
    Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue
    $env:HTTPS_PROXY = $HttpProxy
    $env:HTTP_PROXY = $HttpProxy
    try {
        & $Uv --directory $Src run scrapling install
        if ($LASTEXITCODE -ne 0) {
            Write-Host "scrapling install with proxy failed; retrying without proxy..."
            if ($oldProxy.ALL_PROXY) { $env:ALL_PROXY = $oldProxy.ALL_PROXY } else { Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue }
            if ($oldProxy.HTTPS_PROXY) { $env:HTTPS_PROXY = $oldProxy.HTTPS_PROXY } else { Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue }
            if ($oldProxy.HTTP_PROXY) { $env:HTTP_PROXY = $oldProxy.HTTP_PROXY } else { Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue }
            & $Uv --directory $Src run scrapling install
            if ($LASTEXITCODE -ne 0) { throw "scrapling install failed ($LASTEXITCODE)" }
        }
    } finally {
        if ($oldProxy.ALL_PROXY) { $env:ALL_PROXY = $oldProxy.ALL_PROXY } else { Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue }
        if ($oldProxy.HTTPS_PROXY) { $env:HTTPS_PROXY = $oldProxy.HTTPS_PROXY } else { Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue }
        if ($oldProxy.HTTP_PROXY) { $env:HTTP_PROXY = $oldProxy.HTTP_PROXY } else { Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue }
    }
}

if (-not $SkipSmoke) {
    $smoke = Join-Path $PSScriptRoot "scrapling-scrape.ps1"
    Write-Host "Smoke: Fetcher GET https://example.com"
    & $smoke -Url "https://example.com"
    if ($LASTEXITCODE -ne 0) { throw "scrapling smoke scrape failed ($LASTEXITCODE)" }
}

if ($Http) {
    if (Test-McpReady) {
        Write-Host "Scrapling HTTP MCP already running: $McpHttp"
    } else {
        New-Item -ItemType Directory -Force -Path $Logs | Out-Null
        $outLog = Join-Path $Logs "scrapling-mcp.out.log"
        $errLog = Join-Path $Logs "scrapling-mcp.err.log"
        $mcpExe = Join-Path $Src ".venv\Scripts\scrapling-mcp.exe"
        if (-not (Test-Path -LiteralPath $mcpExe)) {
            $mcpExe = Join-Path $Src ".venv\Scripts\scrapling.exe"
            $argList = @("mcp", "--http", "--no-auth", "--host", "127.0.0.1", "--port", "$HttpPort")
        } else {
            $argList = @("--http", "--no-auth", "--host", "127.0.0.1", "--port", "$HttpPort")
        }
        $p = Start-Process -FilePath $mcpExe -ArgumentList $argList -PassThru -WindowStyle Hidden `
            -RedirectStandardOutput $outLog -RedirectStandardError $errLog
        Set-Content -LiteralPath (Join-Path $Logs "scrapling-mcp.pid") -Value $p.Id
        Write-Host "Started HTTP MCP pid=$($p.Id) port=$HttpPort"
        if (-not (Wait-Mcp -Seconds $HealthTimeoutSec)) {
            Write-Host "HTTP MCP did not become ready. Logs: $errLog"
            Get-Content -LiteralPath $errLog -Tail 40 -ErrorAction SilentlyContinue
            throw "Scrapling HTTP MCP failed to listen on $HttpPort"
        }
    }
}

Write-Host "Scrapling ready."
Write-Host "  venv: $Src\.venv"
Write-Host "  STDIO MCP: $Src\.venv\Scripts\scrapling-mcp.exe  (Cursor key scrapling)"
if ($Http) { Write-Host "  HTTP MCP: $McpHttp (--no-auth, localhost)" }
exit 0
