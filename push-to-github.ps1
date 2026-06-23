#Requires -Version 5.1
<#
.SYNOPSIS
  创建 GitHub 仓库并将 cursorEnv 推送到远程。

.USAGE
  .\push-to-github.ps1
  .\push-to-github.ps1 -RepoName cursorEnv -Visibility private
  .\push-to-github.ps1 -Owner wenyuanxu20 -SkipCreate   # 仓库已存在时仅 push
#>
param(
    [string]$Owner = "wenyuanxu20",
    [string]$RepoName = "cursorEnv",
    [ValidateSet("public", "private")]
    [string]$Visibility = "private",
    [switch]$SkipCreate
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

function Get-GhExe {
    $cmd = Get-Command gh -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    $default = "C:\Program Files\GitHub CLI\gh.exe"
    if (Test-Path $default) { return $default }
    throw "未找到 gh CLI。请安装: winget install GitHub.cli"
}

$gh = Get-GhExe
& $gh auth status 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "请先登录 GitHub: gh auth login"
    exit 1
}

if (-not (Test-Path ".git")) {
    git init
    git add .
    git commit -m "Add Cursor environment docs and migration manifest"
    git branch -M main
}

$remoteUrl = "https://github.com/$Owner/$RepoName.git"

if (-not $SkipCreate) {
    $exists = & $gh repo view "$Owner/$RepoName" 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "创建仓库 $Owner/$RepoName ($Visibility)..."
        & $gh repo create $RepoName --$Visibility --source=. --remote=origin --description "Cursor dev environment config and migration docs"
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    } else {
        Write-Host "仓库已存在: $remoteUrl"
        git remote remove origin 2>$null
        git remote add origin $remoteUrl
    }
} else {
    git remote remove origin 2>$null
    git remote add origin $remoteUrl
}

git push -u origin main
Write-Host "完成: https://github.com/$Owner/$RepoName"
