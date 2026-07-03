# 批量为 my-project 下所有子项目配置 Headroom（RTK + .headroom/ + 映射表）
# 用法: .\scripts\headroom-map-subprojects.ps1 [-WorkspaceRoot C:\Users\xwy12\Desktop\my-project]

param(
    [string]$WorkspaceRoot = "C:\Users\xwy12\Desktop\my-project",
    [int]$Port = 8787,
    [switch]$SkipRtk
)

$ErrorActionPreference = "Stop"
$hubDir = Resolve-Path (Join-Path $PSScriptRoot "..")

$initScript = Join-Path $hubDir "scripts\headroom-init-project.ps1"
if (-not (Test-Path $initScript)) {
    Write-Error "headroom-init-project.ps1 not found"
}

$manifestPath = Join-Path $hubDir "headroom-projects.json"
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

$results = @()
foreach ($entry in $manifest.projects) {
    $projPath = Join-Path $WorkspaceRoot $entry.path
    if (-not (Test-Path $projPath)) {
        Write-Warning "Skip (missing): $($entry.path)"
        continue
    }
    Write-Host "`n--- $($entry.id) ---" -ForegroundColor Cyan
    $args = @{
        ProjectPath = $projPath
        Port = $Port
    }
    if ($SkipRtk) { $args.SkipRtk = $true }
    & $initScript @args

    $encoded = [uri]::EscapeDataString($entry.id)
    $results += [PSCustomObject]@{
        id = $entry.id
        path = $projPath
        openai_base_url = "http://127.0.0.1:$Port/p/$encoded/v1"
        anthropic_base_url = "http://127.0.0.1:$Port/p/$encoded"
        category = $entry.category
    }
}

$outPath = Join-Path $hubDir "headroom-projects.resolved.json"
$results | ConvertTo-Json -Depth 4 | Set-Content $outPath -Encoding UTF8
Write-Host "`nResolved map written: $outPath" -ForegroundColor Green
Write-Host "Configured $($results.Count) subprojects."
