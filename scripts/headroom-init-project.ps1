# Headroom 单项目初始化：注入 .cursorrules（RTK）+ 创建 .headroom/ + 输出 Cursor Base URL
# 用法: .\scripts\headroom-init-project.ps1 [-ProjectPath C:\path\to\project] [-Port 8787] [-SkipRtk]

param(
    [string]$ProjectPath = (Get-Location).Path,
    [int]$Port = 8787,
    [switch]$SkipRtk
)

$ErrorActionPreference = "Stop"

$pythonScripts = Join-Path $env:APPDATA "Python\Python314\Scripts"
if (Test-Path $pythonScripts) {
    $env:Path = "$pythonScripts;$env:Path"
}

$headroom = Get-Command headroom -ErrorAction SilentlyContinue
if (-not $headroom) {
    Write-Error "headroom CLI not found. Run: pip install `"headroom-ai[proxy]`""
}

$ProjectPath = (Resolve-Path $ProjectPath).Path
$projectName = Split-Path $ProjectPath -Leaf

Push-Location $ProjectPath
try {
    $wrapArgs = @("wrap", "cursor", "--prepare-only", "--port", "$Port")
    if ($SkipRtk) { $wrapArgs += "--no-rtk" }
    & headroom @wrapArgs | Out-Host

    $headroomDir = Join-Path $ProjectPath ".headroom"
    if (-not (Test-Path $headroomDir)) {
        New-Item -ItemType Directory -Path $headroomDir -Force | Out-Null
    }

    $marker = Join-Path $headroomDir "project.json"
    @{
        project = $projectName
        initialized_at = (Get-Date).ToString("o")
        proxy_port = $Port
    } | ConvertTo-Json | Set-Content -Path $marker -Encoding UTF8

    $encoded = [uri]::EscapeDataString($projectName)
    $openai = "http://127.0.0.1:$Port/p/$encoded/v1"
    $anthropic = "http://127.0.0.1:$Port/p/$encoded"

    Write-Host ""
    Write-Host "=== Headroom configured: $projectName ===" -ForegroundColor Green
    Write-Host "  Path: $ProjectPath"
    Write-Host "  OpenAI Base URL:    $openai"
    Write-Host "  Anthropic Base URL: $anthropic"
    Write-Host ""
    Write-Host "Cursor: Settings > Models > Override OpenAI Base URL"
    Write-Host "  Set to: $openai"
    Write-Host ""
}
finally {
    Pop-Location
}
