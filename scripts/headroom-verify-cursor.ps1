# Verify Cursor is routing LLM traffic through Headroom proxy
# Usage: .\scripts\headroom-verify-cursor.ps1 [-ProjectId cursorEnv]

param(
    [string]$ProjectId = "cursorEnv",
    [int]$Port = 8787
)

$ErrorActionPreference = "Stop"
$expectedOpenAi = "http://127.0.0.1:$Port/p/$([uri]::EscapeDataString($ProjectId))/v1"
$expectedAnthropic = "http://127.0.0.1:$Port/p/$([uri]::EscapeDataString($ProjectId))"

Write-Host "=== Headroom x Cursor verification ===" -ForegroundColor Cyan
Write-Host "Expected OpenAI Base URL:    $expectedOpenAi"
Write-Host "Expected Anthropic Base URL: $expectedAnthropic"
Write-Host ""

# 1. Proxy health
try {
    $health = Invoke-RestMethod "http://127.0.0.1:$Port/health" -TimeoutSec 3
    Write-Host "[OK] Proxy running (v$($health.version), uptime $([math]::Round($health.uptime_seconds))s)" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Proxy not reachable on port $Port" -ForegroundColor Red
    Write-Host "       Run: .\scripts\headroom-start-proxy.ps1 -Memory"
    exit 1
}

# 2. Cursor state DB
$db = "$env:APPDATA\Cursor\User\globalStorage\state.vscdb"
if (-not (Test-Path $db)) {
    Write-Host "[WARN] Cursor state DB not found: $db" -ForegroundColor Yellow
    exit 0
}

$py = @"
import sqlite3, json, sys
path = r'$db'
conn = sqlite3.connect(path)
cur = conn.cursor()
key = 'src.vs.platform.reactivestorage.browser.reactiveStorageServiceImpl.persistentStorage.applicationUser'
cur.execute('SELECT value FROM ItemTable WHERE key = ?', (key,))
row = cur.fetchone()
if not row:
    print('NO_APPLICATION_USER')
    sys.exit(0)
text = row[0].decode('utf-8', errors='replace') if isinstance(row[0], bytes) else str(row[0])
obj = json.loads(text)
fields = {
    'openAIBaseUrl': obj.get('openAIBaseUrl'),
    'anthropicBaseUrl': obj.get('anthropicBaseUrl'),
    'useOpenAIKey': obj.get('useOpenAIKey'),
    'useClaudeKey': obj.get('useClaudeKey'),
    'useAnthropicKey': obj.get('useAnthropicKey'),
    'agentBackendPreference': (obj.get('composerState') or {}).get('agentBackendPreference'),
}
print(json.dumps(fields, ensure_ascii=False))
conn.close()
"@

$cursorJson = python -c $py 2>$null
if (-not $cursorJson) {
    Write-Host "[WARN] Could not read Cursor state DB" -ForegroundColor Yellow
    exit 0
}

$cursor = $cursorJson | ConvertFrom-Json
Write-Host "--- Cursor settings (from state.vscdb) ---"
Write-Host "openAIBaseUrl:          $($cursor.openAIBaseUrl)"
Write-Host "anthropicBaseUrl:       $($cursor.anthropicBaseUrl)"
Write-Host "useOpenAIKey:           $($cursor.useOpenAIKey)"
Write-Host "useClaudeKey:           $($cursor.useClaudeKey)"
Write-Host "useAnthropicKey:        $($cursor.useAnthropicKey)"
Write-Host "agentBackendPreference: $($cursor.agentBackendPreference)"
Write-Host ""

if ($cursor.openAIBaseUrl -eq $expectedOpenAi) {
    Write-Host "[OK] OpenAI Base URL matches project '$ProjectId'" -ForegroundColor Green
} elseif ($cursor.openAIBaseUrl) {
    Write-Host "[WARN] OpenAI Base URL set but different project/path" -ForegroundColor Yellow
    Write-Host "       Current: $($cursor.openAIBaseUrl)"
} else {
    Write-Host "[FAIL] OpenAI Base URL not set" -ForegroundColor Red
    Write-Host "       Run: .\scripts\headroom-switch-cursor-project.ps1 $ProjectId"
}

if ($cursor.useOpenAIKey -eq $true) {
    Write-Host "[OK] useOpenAIKey enabled (BYOK path active)" -ForegroundColor Green
} else {
    Write-Host "[FAIL] useOpenAIKey is false — Cursor subscription models bypass Headroom" -ForegroundColor Red
    Write-Host "       Enable OpenAI API Key in Settings > Models"
}

# 3. Proxy traffic
try {
    $stats = Invoke-RestMethod "http://127.0.0.1:$Port/stats?cached=1" -TimeoutSec 5
    $api = $stats.summary.api_requests
    $saved = $stats.tokens.saved
    Write-Host ""
    Write-Host "--- Proxy traffic ---"
    Write-Host "LLM api_requests: $api"
    Write-Host "tokens saved:     $saved"
    if ($api -gt 0) {
        Write-Host "[OK] LLM traffic detected through proxy" -ForegroundColor Green
    } else {
        Write-Host "[INFO] No LLM requests yet — send a chat after enabling BYOK" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARN] Could not read /stats" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Dashboard: http://127.0.0.1:$Port/dashboard"
