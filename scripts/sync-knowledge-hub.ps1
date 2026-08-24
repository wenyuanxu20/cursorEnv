# Mirror current project wiki/graphify into my-project/knowledge-hub
param(
    [string]$Project = "cursorEnv",
    [switch]$FromHub
)
$script = "C:\Users\xwy12\Desktop\my-project\knowledge-hub\sync.ps1"
if (-not (Test-Path -LiteralPath $script)) {
    throw "knowledge-hub sync.ps1 not found: $script"
}
if ($FromHub) {
    & $script -Project $Project -FromHub
} else {
    & $script -Project $Project
}
