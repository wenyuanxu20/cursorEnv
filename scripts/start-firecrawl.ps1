# Wrapper: start local Firecrawl from the repo scripts/ folder.
$script = Join-Path $PSScriptRoot "..\getInfo\scripts\start-firecrawl.ps1"
& $script @args
exit $LASTEXITCODE
