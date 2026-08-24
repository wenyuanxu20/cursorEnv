# Wrapper: start local TrendRadar from the repo scripts/ folder.
$script = Join-Path $PSScriptRoot "..\getInfo\scripts\start-trendradar.ps1"
& $script @args
exit $LASTEXITCODE
