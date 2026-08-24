# Wrapper: install / start local Scrapling from the repo scripts/ folder.
$script = Join-Path $PSScriptRoot "..\getInfo\scripts\start-scrapling.ps1"
& $script @args
exit $LASTEXITCODE
