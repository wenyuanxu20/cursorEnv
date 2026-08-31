# Wire cursorEnv getInfo into local AstrBot (plugin + Agent workspace MCP/rule).
# Does not deploy to Aliyun ECS. Does not start getInfo services.
param(
    [string]$AstrBotRoot = "",
    [switch]$SkipPlugin,
    [switch]$SkipMcp
)

$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
$CursorEnv = Split-Path -Parent $GetInfo
if (-not $AstrBotRoot) {
    $AstrBotRoot = Join-Path (Split-Path -Parent $CursorEnv) "ai\AstrBot"
}
$AstrBotRoot = (Resolve-Path -LiteralPath $AstrBotRoot).Path

$PluginSrc = Join-Path $AstrBotRoot "extras\astrbot_plugin_getinfo"
$PluginDst = Join-Path $AstrBotRoot "data\plugins\astrbot_plugin_getinfo"
$RuleSrc = Join-Path $CursorEnv ".cursor\rules\firecrawl-web-fetch.mdc"
$RuleDstDir = Join-Path $AstrBotRoot ".cursor\rules"
$McpSrc = Join-Path $GetInfo "astrbot-mcp.windows.json"
$McpDst = Join-Path $AstrBotRoot ".cursor\mcp.json"

if (-not (Test-Path -LiteralPath $PluginSrc)) {
    throw "Missing plugin source: $PluginSrc"
}
if (-not (Test-Path -LiteralPath $RuleSrc)) {
    throw "Missing rule: $RuleSrc"
}

New-Item -ItemType Directory -Force -Path $RuleDstDir | Out-Null
Copy-Item -LiteralPath $RuleSrc -Destination (Join-Path $RuleDstDir "firecrawl-web-fetch.mdc") -Force
Write-Host "rule -> $RuleDstDir\firecrawl-web-fetch.mdc"

if (-not $SkipPlugin) {
    New-Item -ItemType Directory -Force -Path (Split-Path $PluginDst) | Out-Null
    if (Test-Path -LiteralPath $PluginDst) {
        Remove-Item -LiteralPath $PluginDst -Recurse -Force
    }
    Copy-Item -LiteralPath $PluginSrc -Destination $PluginDst -Recurse -Force
    Write-Host "plugin -> $PluginDst"
}

if (-not $SkipMcp) {
    $incoming = Get-Content -LiteralPath $McpSrc -Raw -Encoding UTF8 | ConvertFrom-Json
    $merged = @{ mcpServers = @{} }
    if (Test-Path -LiteralPath $McpDst) {
        $existing = Get-Content -LiteralPath $McpDst -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($existing.mcpServers) {
            $existing.mcpServers.PSObject.Properties | ForEach-Object {
                $merged.mcpServers[$_.Name] = $_.Value
            }
        }
    }
    $incoming.mcpServers.PSObject.Properties | ForEach-Object {
        $merged.mcpServers[$_.Name] = $_.Value
    }
    $json = $merged | ConvertTo-Json -Depth 8
    New-Item -ItemType Directory -Force -Path (Split-Path $McpDst) | Out-Null
    [System.IO.File]::WriteAllText($McpDst, $json)
    Write-Host "mcp -> $McpDst (Windows local; do not copy to Aliyun as-is)"
}

function Test-Url([string]$Url) {
    try {
        $code = & curl.exe -s -o NUL -w "%{http_code}" --max-time 5 $Url
        return $code
    } catch {
        return "err"
    }
}

$fc = Test-Url "http://127.0.0.1:3002/v0/health/readiness"
$tr = Test-Url "http://127.0.0.1:3333/mcp"
Write-Host "Firecrawl readiness HTTP $fc  (expect 200; else start-firecrawl.ps1)"
Write-Host "TrendRadar MCP HTTP $tr      (expect 200/400/406; else start-trendradar.ps1)"
Write-Host "Done. Reload AstrBot plugins or restart AstrBot, then /getinfo_ping"
