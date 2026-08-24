# Start TrendRadar under cursorEnv/getInfo.
# Prefer Docker Compose; if Hub mirror fails, fall back to uv (HTTP MCP :3333 + one crawl).
# Web (docker): http://127.0.0.1:8080   MCP: http://127.0.0.1:3333/mcp
param(
    [int]$HealthTimeoutSec = 240,
    [switch]$SkipCrawl
)

$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $GetInfo "env.example"))) {
    $GetInfo = Join-Path (Split-Path -Parent $PSScriptRoot) "getInfo"
}
$Src = Join-Path $GetInfo "TrendRadar"
$ComposeDir = Join-Path $Src "docker"
$Logs = Join-Path $GetInfo "logs"
$Repo = "https://github.com/sansan0/TrendRadar.git"
$Web = "http://127.0.0.1:8080"
$Mcp = "http://127.0.0.1:3333/mcp"
$Uv = Join-Path $env:USERPROFILE ".local\bin\uv.exe"
$Desktop = "C:\Program Files\Docker\Docker\Docker Desktop.exe"

$env:Path = "$env:USERPROFILE\.local\bin;" + $env:Path
# uv sync uses Tsinghua; do not force SOCKS onto PyPI (tls handshake eof).
# Docker pull may still use the daemon mirror.

function Test-DockerReady {
    docker info --format "{{.ServerVersion}}" 2>$null | Out-Null
    return ($LASTEXITCODE -eq 0)
}

function Ensure-Checkout {
    if (-not (Test-Path -LiteralPath (Join-Path $Src "pyproject.toml"))) {
        Write-Host "Cloning TrendRadar..."
        New-Item -ItemType Directory -Force -Path $GetInfo | Out-Null
        git clone --depth 1 $Repo $Src
    }
}

function Test-McpReady {
    try {
        $code = & curl.exe -s -o NUL -w "%{http_code}" --max-time 5 `
            -H "Accept: application/json, text/event-stream" $Mcp
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
            Write-Host "TrendRadar MCP ready: $Mcp"
            return $true
        }
        Write-Host "Waiting for $Mcp ..."
        Start-Sleep -Seconds 4
    }
    return $false
}

function Start-DockerStack {
    if (-not (Test-DockerReady)) { return $false }
    if (-not (Test-Path -LiteralPath (Join-Path $ComposeDir "docker-compose.yml"))) { return $false }
    Write-Host "Trying Docker Compose (wantcat/trendradar + trendradar-mcp)..."
    Push-Location $ComposeDir
    try {
        docker compose --env-file .env pull
        if ($LASTEXITCODE -ne 0) { return $false }
        docker compose --env-file .env up -d
        if ($LASTEXITCODE -ne 0) { return $false }
    } catch {
        Write-Host "Docker path failed: $($_.Exception.Message)"
        return $false
    } finally {
        Pop-Location
    }
    return (Wait-Mcp -Seconds $HealthTimeoutSec)
}

function Start-UvStack {
    if (-not (Test-Path -LiteralPath $Uv)) {
        throw "uv not found at $Uv. Install uv, then re-run."
    }
    Write-Host "Falling back to uv local deploy..."
    Push-Location $Src
    try {
        & $Uv sync --python 3.12 --index-url https://pypi.tuna.tsinghua.edu.cn/simple --trusted-host pypi.tuna.tsinghua.edu.cn
        if ($LASTEXITCODE -ne 0) { throw "uv sync failed ($LASTEXITCODE)" }
    } finally {
        Pop-Location
    }

    New-Item -ItemType Directory -Force -Path $Logs | Out-Null
    $outLog = Join-Path $Logs "trendradar-mcp.out.log"
    $errLog = Join-Path $Logs "trendradar-mcp.err.log"
    $p = Start-Process -FilePath $Uv -ArgumentList @(
        "--directory", $Src,
        "run", "python", "-m", "mcp_server.server",
        "--transport", "http",
        "--host", "127.0.0.1",
        "--port", "3333"
    ) -PassThru -WindowStyle Hidden -RedirectStandardOutput $outLog -RedirectStandardError $errLog
    Set-Content -LiteralPath (Join-Path $Logs "trendradar-mcp.pid") -Value $p.Id
    Write-Host "Started uv MCP pid=$($p.Id)"

    if (-not (Wait-Mcp -Seconds $HealthTimeoutSec)) {
        Write-Host "MCP HTTP did not become ready. Logs: $errLog"
        Get-Content -LiteralPath $errLog -Tail 40 -ErrorAction SilentlyContinue
        throw "uv MCP failed to listen on 3333"
    }

    if (-not $SkipCrawl) {
        Write-Host "Running one crawl (uv run python -m trendradar)..."
        $env:PYTHONUTF8 = "1"
        $env:PYTHONIOENCODING = "utf-8"
        Push-Location $Src
        try {
            & $Uv run python -m trendradar
        } finally {
            Pop-Location
        }
    }
    return $true
}

Ensure-Checkout
if (Test-McpReady) {
    Write-Host "TrendRadar MCP already running: $Mcp"
    exit 0
}

$ok = Start-DockerStack
if (-not $ok) {
    Write-Host "Docker Hub pull/up unavailable; using uv."
    $ok = Start-UvStack
}

if ($ok) {
    Write-Host "MCP: ~/.cursor/mcp.json key trendradar -> $Mcp"
    if (Test-DockerReady) {
        $webCode = & curl.exe -s -o NUL -w "%{http_code}" --max-time 3 $Web
        if ($webCode -match '^(200|301|302)$') { Write-Host "Web UI: $Web" }
    }
    exit 0
}

exit 1
