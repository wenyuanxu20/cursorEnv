# Install AstrBot agents-radar plugin (Windows). Does not deploy to Aliyun.
param(
    [string]$AstrBotRoot = ""
)

$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
$CursorEnv = Split-Path -Parent $GetInfo
if (-not $AstrBotRoot) {
    $AstrBotRoot = Join-Path (Split-Path -Parent $CursorEnv) "ai\AstrBot"
}
$AstrBotRoot = (Resolve-Path -LiteralPath $AstrBotRoot).Path
$PluginSrc = Join-Path $AstrBotRoot "extras\astrbot_plugin_agents_radar"
$PluginDst = Join-Path $AstrBotRoot "data\plugins\astrbot_plugin_agents_radar"

if (-not (Test-Path -LiteralPath $PluginSrc)) {
    throw "Missing plugin source: $PluginSrc"
}

New-Item -ItemType Directory -Force -Path (Split-Path $PluginDst) | Out-Null
if (Test-Path -LiteralPath $PluginDst) {
    Remove-Item -LiteralPath $PluginDst -Recurse -Force
}
Copy-Item -LiteralPath $PluginSrc -Destination $PluginDst -Recurse -Force
Write-Host "plugin -> $PluginDst"

$start = Join-Path $PSScriptRoot "start-agents-radar.ps1"
& powershell.exe -NoProfile -ExecutionPolicy Bypass -File $start
Write-Host "Done. Reload AstrBot plugins, then /radar_bind"
