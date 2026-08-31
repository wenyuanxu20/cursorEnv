# Start local agents-radar digest API on 127.0.0.1:3355.
# Serves published daily reports (GitHub Pages / jsDelivr). Does not run the upstream LLM pipeline.
param(
    [int]$Port = 3355,
    [switch]$Foreground
)

$ErrorActionPreference = "Stop"
$GetInfo = Split-Path -Parent $PSScriptRoot
$Serve = Join-Path $PSScriptRoot "agents-radar-serve.py"
$Root = Join-Path $GetInfo "agents-radar"
$Logs = Join-Path $GetInfo "logs"
$PidFile = Join-Path $Logs "agents-radar.pid"
$LogFile = Join-Path $Logs "agents-radar.out.log"
$ErrFile = Join-Path $Logs "agents-radar.err.log"
$Health = "http://127.0.0.1:$Port/health"

New-Item -ItemType Directory -Force -Path $Root, $Logs | Out-Null

function Resolve-Python {
    $venvPy = Join-Path $GetInfo "TrendRadar\.venv\Scripts\python.exe"
    if (Test-Path -LiteralPath $venvPy) { return $venvPy }
    foreach ($name in @("py", "python", "python3")) {
        $cmd = Get-Command $name -ErrorAction SilentlyContinue
        if ($cmd) { return $cmd.Source }
    }
    throw "python not found"
}

function Test-Ready {
    try {
        $code = & curl.exe -s -o NUL -w "%{http_code}" --max-time 5 $Health
        return ($code -eq "200")
    } catch {
        return $false
    }
}

if (Test-Ready) {
    Write-Host "agents-radar already up: $Health"
    exit 0
}

$py = Resolve-Python
$env:AGENTS_RADAR_PORT = "$Port"
$env:PYTHONUTF8 = "1"
$env:PYTHONIOENCODING = "utf-8"

if ($Foreground) {
    & $py $Serve
    exit $LASTEXITCODE
}

$proc = Start-Process -FilePath $py -ArgumentList @($Serve) `
    -WorkingDirectory $Root -WindowStyle Hidden -PassThru `
    -RedirectStandardOutput $LogFile -RedirectStandardError $ErrFile
Set-Content -LiteralPath $PidFile -Value $proc.Id -Encoding ascii
Write-Host "started pid $($proc.Id)  log $LogFile"

$deadline = (Get-Date).AddSeconds(25)
while ((Get-Date) -lt $deadline) {
    if (Test-Ready) {
        Write-Host "agents-radar ready: $Health"
        exit 0
    }
    Start-Sleep -Seconds 1
}
Write-Host "health check timed out; see $LogFile"
exit 1
