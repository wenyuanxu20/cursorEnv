# Scrape a URL via local Firecrawl HTTP API (MCP fallback).
param(
    [Parameter(Mandatory = $true)]
    [string]$Url,
    [string]$Api = "http://127.0.0.1:3002",
    [int]$TimeoutMs = 60000
)

$ErrorActionPreference = "Stop"
$bodyObj = @{
    url      = $Url
    formats  = @("markdown")
    timeout  = $TimeoutMs
}
$bodyPath = Join-Path $env:TEMP "firecrawl-scrape.json"
[System.IO.File]::WriteAllText($bodyPath, ($bodyObj | ConvertTo-Json -Compress))
$curlTimeout = [Math]::Ceiling(($TimeoutMs / 1000) + 15)
& curl.exe --fail-with-body --silent --show-error --max-time $curlTimeout `
    -X POST "$Api/v2/scrape" `
    -H "Content-Type: application/json" `
    --data-binary "@$bodyPath"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
