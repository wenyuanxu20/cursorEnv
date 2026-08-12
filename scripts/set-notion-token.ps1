#Requires -Version 5.1
<#
.SYNOPSIS
  Set user-level NOTION_TOKEN for Cursor MCP server notion-token (runtime id: user-notion-token).

.DESCRIPTION
  Does not print the token. Restart Cursor after running so MCP picks up the env var.
  Create a Personal Access Token at Notion Developers (Notion API capability).
#>
param(
  [Parameter(Mandatory = $false)]
  [string]$Token
)

$ErrorActionPreference = "Stop"

if (-not $Token) {
  $secure = Read-Host -Prompt "Paste Notion PAT (ntn_... or secret_...)" -AsSecureString
  $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  try {
    $Token = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
  } finally {
    [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
  }
}

$Token = ($Token -or "").Trim()
if (-not $Token) {
  throw "Empty token."
}
if ($Token -notmatch '^(ntn_|secret_)') {
  Write-Warning "Token does not start with ntn_ or secret_. Continuing anyway."
}

[Environment]::SetEnvironmentVariable("NOTION_TOKEN", $Token, "User")
$env:NOTION_TOKEN = $Token
Write-Host "NOTION_TOKEN set for User scope (length=$($Token.Length)). Restart Cursor, then check MCP server user-notion-token."
