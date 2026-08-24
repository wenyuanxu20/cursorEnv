# Fetch a URL with local Scrapling HTTP Fetcher (MCP fallback).
param(
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [ValidateSet("http", "dynamic", "stealthy")]
    [string]$Mode = "http"
)

$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
if (-not (Test-Path -LiteralPath (Join-Path $GetInfo "env.example"))) {
    $GetInfo = Join-Path (Split-Path -Parent $PSScriptRoot) "getInfo"
}
$Src = Join-Path $GetInfo "scrapling"
$Smoke = Join-Path $Src "smoke.py"
$Uv = Join-Path $env:USERPROFILE ".local\bin\uv.exe"
$env:Path = "$env:USERPROFILE\.local\bin;" + $env:Path

if (-not (Test-Path -LiteralPath $Uv)) {
    throw "uv not found at $Uv"
}
if (-not (Test-Path -LiteralPath $Smoke)) {
    throw "Missing $Smoke"
}

& $Uv --directory $Src run python $Smoke $Url $Mode
exit $LASTEXITCODE
