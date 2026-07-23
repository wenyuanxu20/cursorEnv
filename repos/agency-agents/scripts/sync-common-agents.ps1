[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$TargetProject,

    [string]$SourceRulesDir,

    [switch]$Force,

    [switch]$Clean
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($SourceRulesDir)) {
    $SourceRulesDir = Join-Path $PSScriptRoot "..\.cursor\rules"
}

$commonAgents = @(
    "project-manager-orchestrator.mdc",
    "software-architect.mdc",
    "frontend-developer.mdc",
    "backend-architect.mdc",
    "ui-designer.mdc",
    "ux-architect.mdc",
    "evidence-collector.mdc",
    "reality-checker.mdc"
)

function Write-Info {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([string]$Message)
    Write-Host "[OK]   $Message" -ForegroundColor Green
}

function Write-WarnLine {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

$resolvedTarget = [System.IO.Path]::GetFullPath($TargetProject)
$resolvedSource = [System.IO.Path]::GetFullPath((Resolve-Path $SourceRulesDir).Path)
$targetRulesDir = Join-Path $resolvedTarget ".cursor\rules"

if (-not (Test-Path $resolvedTarget)) {
    throw "Target project does not exist: $resolvedTarget"
}

if (-not (Test-Path $resolvedSource)) {
    throw "Source rules directory does not exist: $resolvedSource"
}

$missingAgents = @()
foreach ($agent in $commonAgents) {
    $agentPath = Join-Path $resolvedSource $agent
    if (-not (Test-Path $agentPath)) {
        $missingAgents += $agent
    }
}

if ($missingAgents.Count -gt 0) {
    throw "Missing source rule files: $($missingAgents -join ', ')"
}

New-Item -ItemType Directory -Force -Path $targetRulesDir | Out-Null

Write-Info "Source rules: $resolvedSource"
Write-Info "Target project: $resolvedTarget"
Write-Info "Target rules dir: $targetRulesDir"

if ($Clean) {
    Write-Info "Cleaning previously synced common agents in target project"
    foreach ($agent in $commonAgents) {
        $targetFile = Join-Path $targetRulesDir $agent
        if (Test-Path $targetFile) {
            Remove-Item -LiteralPath $targetFile -Force
            Write-Ok "Removed $agent"
        }
    }
}

$copied = 0
foreach ($agent in $commonAgents) {
    $sourceFile = Join-Path $resolvedSource $agent
    $targetFile = Join-Path $targetRulesDir $agent

    if ((Test-Path $targetFile) -and (-not $Force)) {
        Write-WarnLine "Skipped existing $agent (use -Force to overwrite)"
        continue
    }

    Copy-Item -LiteralPath $sourceFile -Destination $targetFile -Force
    Write-Ok "Synced $agent"
    $copied++
}

Write-Host ""
Write-Ok "Done. Synced $copied common agent rule(s)."
Write-Host "Common agents:" -ForegroundColor White
$commonAgents | ForEach-Object { Write-Host " - $_" }
Write-Host ""
Write-Host "You can now use them in Cursor, for example:" -ForegroundColor White
Write-Host "  @project-manager-orchestrator Plan the task and route the right agents."
Write-Host "  @software-architect Analyze this module structure."
Write-Host "  @ui-designer Improve this page visual hierarchy."
Write-Host "  @reality-checker Check if this feature is ready to ship."
