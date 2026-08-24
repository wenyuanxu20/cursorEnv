# Start local Firecrawl (self-host) under cursorEnv/getInfo.
# Pins Firecrawl v2.11.162. API: http://127.0.0.1:3002 (auth off).
param(
    [int]$HealthTimeoutSec = 600
)

$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $GetInfo "env.example"))) {
    $GetInfo = Join-Path (Split-Path -Parent $PSScriptRoot) "getInfo"
}
$Src = Join-Path $GetInfo "firecrawl"
$Example = Join-Path $GetInfo "env.example"
$EnvFile = Join-Path $Src ".env"
$Pin = "v2.11.162"
$Repo = "https://github.com/firecrawl/firecrawl.git"
$Api = "http://127.0.0.1:3002"
$Desktop = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
$Proxy = "socks5://127.0.0.1:7897"

function Test-DockerReady {
    docker info --format "{{.ServerVersion}}" 2>$null | Out-Null
    return ($LASTEXITCODE -eq 0)
}

function Wait-Docker {
    param([int]$Seconds = 180)
    if (Test-DockerReady) { return }
    if (Test-Path -LiteralPath $Desktop) {
        Start-Process -FilePath $Desktop
        Write-Host "Starting Docker Desktop..."
    } else {
        throw "Docker Desktop not found. Install Docker Desktop, then re-run this script."
    }
    $deadline = (Get-Date).AddSeconds($Seconds)
    while ((Get-Date) -lt $deadline) {
        Start-Sleep -Seconds 5
        if (Test-DockerReady) {
            Write-Host "Docker is ready."
            return
        }
    }
    throw "Docker daemon did not become ready within ${Seconds}s. Open Docker Desktop and retry."
}

function New-PostgresPassword {
    $bytes = New-Object byte[] 24
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
    $rng.GetBytes($bytes)
    return ([Convert]::ToBase64String($bytes) -replace '[+/=]', 'A')
}

function Ensure-Checkout {
    if (-not (Test-Path -LiteralPath (Join-Path $Src "docker-compose.yaml"))) {
        Write-Host "Cloning Firecrawl $Pin..."
        New-Item -ItemType Directory -Force -Path $GetInfo | Out-Null
        $oldProxy = @{
            ALL_PROXY   = $env:ALL_PROXY
            HTTPS_PROXY = $env:HTTPS_PROXY
            HTTP_PROXY  = $env:HTTP_PROXY
        }
        $env:ALL_PROXY = $Proxy
        $env:HTTPS_PROXY = $Proxy
        $env:HTTP_PROXY = $Proxy
        try {
            git clone --depth 1 --branch $Pin $Repo $Src
            if ($LASTEXITCODE -ne 0) { throw "git clone failed ($LASTEXITCODE)" }
        } finally {
            if ($oldProxy.ALL_PROXY) { $env:ALL_PROXY = $oldProxy.ALL_PROXY } else { Remove-Item Env:ALL_PROXY -ErrorAction SilentlyContinue }
            if ($oldProxy.HTTPS_PROXY) { $env:HTTPS_PROXY = $oldProxy.HTTPS_PROXY } else { Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue }
            if ($oldProxy.HTTP_PROXY) { $env:HTTP_PROXY = $oldProxy.HTTP_PROXY } else { Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue }
        }
    }
}

function Ensure-Env {
    if (-not (Test-Path -LiteralPath $EnvFile)) {
        if (-not (Test-Path -LiteralPath $Example)) {
            throw "Missing $Example"
        }
        $text = Get-Content -LiteralPath $Example -Raw
        $text = $text -replace "replace-with-at-least-32-random-characters", (New-PostgresPassword)
        $utf8 = New-Object System.Text.UTF8Encoding $false
        [System.IO.File]::WriteAllText($EnvFile, $text, $utf8)
        Write-Host "Wrote $EnvFile (POSTGRES_PASSWORD generated; file is gitignored)."
    }
}

function Ensure-Override {
    $srcOverride = Join-Path $GetInfo "docker-compose.override.yaml"
    $dstOverride = Join-Path $Src "docker-compose.override.yaml"
    if (Test-Path -LiteralPath $srcOverride) {
        Copy-Item -LiteralPath $srcOverride -Destination $dstOverride -Force
    }
}

function Ensure-Images {
    $pairs = @(
        @("ghcr.nju.edu.cn/firecrawl/firecrawl:latest", "ghcr.io/firecrawl/firecrawl:latest"),
        @("ghcr.nju.edu.cn/firecrawl/playwright-service:latest", "ghcr.io/firecrawl/playwright-service:latest"),
        @("ghcr.nju.edu.cn/firecrawl/nuq-postgres:latest", "ghcr.io/firecrawl/nuq-postgres:latest")
    )
    foreach ($p in $pairs) {
        docker image inspect $p[1] 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) { continue }
        docker image inspect $p[0] 2>$null | Out-Null
        if ($LASTEXITCODE -eq 0) {
            docker tag $p[0] $p[1]
            Write-Host "Tagged $($p[0]) -> $($p[1])"
        }
    }
}

function Test-ApiReady {
    try {
        $r = Invoke-RestMethod -Uri "$Api/v0/health/readiness" -TimeoutSec 5
        return ($r.status -eq "ok")
    } catch {
        return $false
    }
}

Wait-Docker
Ensure-Checkout
Ensure-Env
Ensure-Override
Ensure-Images

if (Test-ApiReady) {
    Write-Host "Firecrawl already running at $Api"
    exit 0
}

Write-Host "Starting Firecrawl Compose (api + playwright + redis + rabbitmq + postgres; skip FoundationDB)."
Push-Location $Src
try {
    $services = @("api", "playwright-service", "redis", "rabbitmq", "nuq-postgres")
    docker compose --env-file $EnvFile up -d --no-build @services
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Prebuilt images missing; falling back to compose --build..."
        docker compose --env-file $EnvFile up -d --build @services
    }
    if ($LASTEXITCODE -ne 0) { throw "docker compose up failed ($LASTEXITCODE)" }
} finally {
    Pop-Location
}

$deadline = (Get-Date).AddSeconds($HealthTimeoutSec)
while ((Get-Date) -lt $deadline) {
    if (Test-ApiReady) {
        Write-Host "Firecrawl API ready: $Api"
        Write-Host "MCP: ~/.cursor/mcp.json key firecrawl -> FIRECRAWL_API_URL=$Api"
        exit 0
    }
    Write-Host "Waiting for $Api/v0/health/readiness ..."
    Start-Sleep -Seconds 8
}

Write-Host "API did not become ready. Recent compose status:"
Push-Location $Src
docker compose ps --all
docker compose logs --tail=80 api
Pop-Location
exit 1
