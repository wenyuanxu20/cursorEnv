# 切换 Cursor 当前子项目的 Headroom Base URL（复制到剪贴板 + 打印说明）
# 用法: .\scripts\headroom-switch-cursor-project.ps1 ai
#       .\scripts\headroom-switch-cursor-project.ps1   # 从当前目录推断项目名

param(
    [string]$ProjectId,
    [int]$Port = 8787
)

$ErrorActionPreference = "Stop"

if (-not $ProjectId) {
    $ProjectId = Split-Path (Get-Location) -Leaf
}

$hubDir = Resolve-Path (Join-Path $PSScriptRoot "..")
$manifestPath = Join-Path $hubDir "headroom-projects.resolved.json"
if (Test-Path $manifestPath) {
    $projects = Get-Content $manifestPath -Raw | ConvertFrom-Json
} else {
    $manifestPath = Join-Path $hubDir "headroom-projects.json"
    $manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json
    $projects = $manifest.projects
}

$entry = $projects | Where-Object { $_.id -eq $ProjectId }
if (-not $entry) {
    Write-Error "Project '$ProjectId' not found. Available: $($projects.id -join ', ')"
}

$openai = $entry.openai_base_url
if (-not $openai) {
    $encoded = [uri]::EscapeDataString($ProjectId)
    $openai = "http://127.0.0.1:$Port/p/$encoded/v1"
    $anthropic = "http://127.0.0.1:$Port/p/$encoded"
} else {
    $anthropic = $entry.anthropic_base_url
}

Set-Clipboard -Value $openai

Write-Host ""
Write-Host "=== Switch to subproject: $ProjectId ===" -ForegroundColor Cyan
Write-Host "  OpenAI Base URL (copied to clipboard):"
Write-Host "    $openai"
Write-Host "  Anthropic Base URL:"
Write-Host "    $anthropic"
Write-Host ""
Write-Host "Cursor: Settings > Models > Override OpenAI Base URL > paste"
Write-Host "Ensure proxy is running: .\scripts\headroom-start-proxy.ps1"
Write-Host ""
