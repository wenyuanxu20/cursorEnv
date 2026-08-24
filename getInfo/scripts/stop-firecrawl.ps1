# Stop the local Firecrawl Compose stack under getInfo/firecrawl.
$ErrorActionPreference = "Stop"
$Src = Join-Path (Split-Path -Parent $PSScriptRoot) "firecrawl"
if (-not (Test-Path -LiteralPath (Join-Path $Src "docker-compose.yaml"))) {
    throw "Firecrawl checkout missing: $Src"
}
Push-Location $Src
try {
    docker compose down
} finally {
    Pop-Location
}
