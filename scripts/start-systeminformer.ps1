# Launch the portable System Informer installed by install-systeminformer.ps1.
param(
    [switch]$RunAsAdmin,
    [switch]$InstallIfMissing
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$InstallRoot = Join-Path $RepoRoot "tools\systeminformer"
$StatePath = Join-Path $InstallRoot "install-state.json"

function Get-SiArchFolder {
    switch ($env:PROCESSOR_ARCHITECTURE) {
        "AMD64" { return "amd64" }
        "ARM64" { return "arm64" }
        default { return "i386" }
    }
}

$exe = $null
if (Test-Path -LiteralPath $StatePath) {
    try {
        $state = Get-Content -LiteralPath $StatePath -Raw -Encoding UTF8 | ConvertFrom-Json
        if ($state.exe -and (Test-Path -LiteralPath $state.exe)) {
            $exe = $state.exe
        }
    } catch {}
}
if (-not $exe) {
    $exe = Join-Path $InstallRoot "$(Get-SiArchFolder)\SystemInformer.exe"
    if (-not (Test-Path -LiteralPath $exe)) { $exe = $null }
}

if (-not $exe) {
    $pf = @(
        "${env:ProgramFiles}\SystemInformer\SystemInformer.exe",
        "${env:ProgramFiles(x86)}\SystemInformer\SystemInformer.exe"
    )
    foreach ($p in $pf) {
        if ($p -and (Test-Path -LiteralPath $p)) { $exe = $p; break }
    }
}

if (-not $exe) {
    if ($InstallIfMissing) {
        & (Join-Path $PSScriptRoot "install-systeminformer.ps1") -Start -RunAsAdmin:$RunAsAdmin
        exit $LASTEXITCODE
    }
    throw "System Informer not found. Run scripts\install-systeminformer.ps1 first."
}

$running = Get-Process -Name "SystemInformer" -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "System Informer already running (PID $($running.Id -join ', '))"
    Write-Host "exe: $exe"
    exit 0
}

if ($RunAsAdmin) {
    Start-Process -FilePath $exe -Verb RunAs
    Write-Host "Started elevated: $exe"
} else {
    Start-Process -FilePath $exe
    Write-Host "Started: $exe"
    Write-Host "Re-run with -RunAsAdmin for disk/network plugins and the kernel driver."
}
