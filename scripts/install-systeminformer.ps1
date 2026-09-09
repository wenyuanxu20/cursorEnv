# Install System Informer (portable) into cursorEnv/tools/systeminformer.
# Pin: winsiderss/systeminformer v4.0.26241.138 (GitHub Releases bin.zip).
# SHA256 verified. Does not clone the Visual Studio source tree.
param(
    [string]$Version = "4.0.26241.138",
    [string]$ExpectedSha256 = "3e12cc4f1ffa1cc34ab9202a9dfe410724cb8b68aaf2efa43c01d3705b27219e",
    [string]$InstallRoot = "",
    [switch]$Force,
    [switch]$Start,
    [switch]$RunAsAdmin,
    [switch]$SkipProxy
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
if (-not $InstallRoot) {
    $InstallRoot = Join-Path $RepoRoot "tools\systeminformer"
}

$Tag = "v$Version"
$ZipName = "systeminformer-$Version-bin.zip"
$Url = "https://github.com/winsiderss/systeminformer/releases/download/$Tag/$ZipName"
$HttpProxy = "http://127.0.0.1:7897"
$StatePath = Join-Path $InstallRoot "install-state.json"

function Get-SiArchFolder {
    switch ($env:PROCESSOR_ARCHITECTURE) {
        "AMD64" { return "amd64" }
        "ARM64" { return "arm64" }
        default { return "i386" }
    }
}

function Get-SiExePath {
    param([string]$Root, [string]$ArchFolder)
    $candidate = Join-Path $Root "$ArchFolder\SystemInformer.exe"
    if (Test-Path -LiteralPath $candidate) { return $candidate }
    return $null
}

function Save-SiState {
    param(
        [string]$Root,
        [string]$Ver,
        [string]$Sha,
        [string]$ArchFolder,
        [string]$Exe,
        [string]$SourceUrl
    )
    $state = [ordered]@{
        version     = $Ver
        tag         = "v$Ver"
        sha256      = $Sha
        arch        = $ArchFolder
        exe         = $Exe
        sourceUrl   = $SourceUrl
        installedAt = (Get-Date).ToString("o")
    }
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    $state | ConvertTo-Json | Set-Content -LiteralPath $StatePath -Encoding UTF8
}

function Start-Si {
    param([string]$Exe, [switch]$Elevated)
    $running = Get-Process -Name "SystemInformer" -ErrorAction SilentlyContinue
    if ($running) {
        Write-Host "System Informer already running (PID $($running.Id -join ', '))"
        return
    }
    if ($Elevated) {
        Start-Process -FilePath $Exe -Verb RunAs
        Write-Host "Started elevated: $Exe"
    } else {
        Start-Process -FilePath $Exe
        Write-Host "Started: $Exe"
        Write-Host "Disk/Network plugins and the kernel driver need Administrator. Re-run with -RunAsAdmin if needed."
    }
}

$ArchFolder = Get-SiArchFolder
$existingExe = Get-SiExePath -Root $InstallRoot -ArchFolder $ArchFolder
$sameVersion = $false
if ((Test-Path -LiteralPath $StatePath) -and $existingExe) {
    try {
        $prev = Get-Content -LiteralPath $StatePath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($prev.version -eq $Version -and $prev.sha256 -eq $ExpectedSha256) {
            $sameVersion = $true
        }
    } catch {}
}

if ($sameVersion -and -not $Force) {
    Write-Host "System Informer $Version already installed: $existingExe"
    if ($Start) { Start-Si -Exe $existingExe -Elevated:$RunAsAdmin }
    Write-Host "OK"
    exit 0
}

New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null
$ZipPath = Join-Path $InstallRoot $ZipName

Write-Host "Downloading $Url"
$curlArgs = @("-fL", "--retry", "3", "-o", $ZipPath, $Url)
if (-not $SkipProxy) {
    $curlArgs = @("--proxy", $HttpProxy) + $curlArgs
}
& curl.exe @curlArgs
if ($LASTEXITCODE -ne 0) {
    if (-not $SkipProxy) {
        Write-Host "Proxy download failed; retrying without proxy..."
        & curl.exe -fL --retry 3 -o $ZipPath $Url
    }
    if ($LASTEXITCODE -ne 0) {
        throw "Download failed (exit $LASTEXITCODE): $Url"
    }
}

$hash = (Get-FileHash -LiteralPath $ZipPath -Algorithm SHA256).Hash.ToLowerInvariant()
$want = $ExpectedSha256.ToLowerInvariant()
if ($hash -ne $want) {
    Remove-Item -LiteralPath $ZipPath -Force -ErrorAction SilentlyContinue
    throw "SHA256 mismatch for $ZipName. expected=$want actual=$hash"
}
Write-Host "SHA256 OK $hash"

foreach ($leaf in @("amd64", "i386", "arm64")) {
    $dir = Join-Path $InstallRoot $leaf
    if (Test-Path -LiteralPath $dir) {
        Remove-Item -LiteralPath $dir -Recurse -Force
    }
}

Expand-Archive -LiteralPath $ZipPath -DestinationPath $InstallRoot -Force
Remove-Item -LiteralPath $ZipPath -Force

$exe = Get-SiExePath -Root $InstallRoot -ArchFolder $ArchFolder
if (-not $exe) {
    throw "Extracted zip but missing $ArchFolder\SystemInformer.exe under $InstallRoot"
}

Save-SiState -Root $InstallRoot -Ver $Version -Sha $hash -ArchFolder $ArchFolder -Exe $exe -SourceUrl $Url
Write-Host "Installed System Informer $Version"
Write-Host "exe: $exe"
Write-Host "Run as Administrator for services, disk/network I/O, and the optional kernel driver."

if ($Start) {
    Start-Si -Exe $exe -Elevated:$RunAsAdmin
}

Write-Host "OK"
