<#
.SYNOPSIS
  Idempotent LLM wiki + graphify bootstrap for my-project subfolders.
#>
param(
  [string]$WorkspaceRoot = "C:\Users\xwy12\Desktop\my-project",
  [string[]]$Projects = @(),
  [switch]$SkipGraphify,
  [switch]$ForceGraphify
)

$ErrorActionPreference = "Stop"
$today = Get-Date -Format "yyyy-MM-dd"
$pageTemplateSrc = Join-Path $PSScriptRoot "..\schema\page-template.md"

$defaultProjects = @(
  "ai", "backtest", "diary", "EE", "exam", "Fate", "finance", "frontEnd",
  "github", "Quant-Research", "record", "travel", "vibe-trading", "zjuilearn"
)
if ($Projects.Count -eq 0) { $Projects = $defaultProjects }

$blurbs = @{
  "ai"             = "AI Chat / OpenClaw / classroom booking apps and ops docs"
  "backtest"       = "Backtest and quant experiment code/notes"
  "diary"          = "Diary / personal journal frontend app"
  "EE"             = "Electrical engineering notes and documents"
  "exam"           = "Exam / study materials"
  "Fate"           = "Fate-related code and runtime assets"
  "finance"        = "Finance / investment pages and data"
  "frontEnd"       = "Frontend practice and static pages"
  "github"         = "Local GitHub clone collection (sub-repos may have own wiki)"
  "Quant-Research" = "Quant research, strategies, and data analysis"
  "record"         = "Records / notes materials"
  "travel"         = "Travel notes and pages"
  "vibe-trading"   = "Trading research, strategies, and docs site"
  "zjuilearn"      = "ZJU iLearn related fullstack app"
}

function Ensure-Dir([string]$Path) {
  if (-not (Test-Path $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
    return "created"
  }
  return "exists"
}

function Write-IfMissing([string]$Path, [string]$Content) {
  if (Test-Path $Path) {
    $existing = Get-Content -Raw -LiteralPath $Path -ErrorAction SilentlyContinue
    if ($null -ne $existing -and $existing.Trim().Length -gt 0) {
      return "skipped-nonempty"
    }
  }
  $parent = Split-Path -Parent $Path
  if ($parent -and -not (Test-Path $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }
  $utf8 = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($Path, $Content, $utf8)
  return "wrote"
}

$results = @()

foreach ($name in $Projects) {
  $root = Join-Path $WorkspaceRoot $name
  if (-not (Test-Path $root)) {
    Write-Host "[SKIP] $name - path missing"
    $results += [PSCustomObject]@{ Project = $name; Wiki = "missing-path"; Graphify = "n/a" }
    continue
  }

  Write-Host ""
  Write-Host "==== $name ===="
  $actions = @()

  $actions += "raw=$(Ensure-Dir (Join-Path $root 'raw'))"
  $actions += "wiki=$(Ensure-Dir (Join-Path $root 'wiki'))"
  $actions += "schema=$(Ensure-Dir (Join-Path $root 'schema'))"

  $blurb = if ($blurbs.ContainsKey($name)) { $blurbs[$name] } else { "Project knowledge base" }

  $agents = @"
# $name Knowledge Base Agent Spec

This repo is the LLM wiki for ``my-project/$name``.

## Page template

Every page should include:

1. **Definition** - what this topic is
2. **Actionable conclusions** - prefer tables
3. **Evidence / sources** - paths under ``raw/`` or in-repo files
4. **Related pages** - wiki links

## Source rules

- Prefer real in-repo file paths for config/code claims
- Separate verified facts from inferences

## Update policy

1. Put new materials in ``raw/``, then ingest into ``wiki/`` and append ``wiki/log.md``
2. After code changes: ``graphify update .`` (AST-only, no API cost)
3. After large doc changes: ``graphify extract . --cluster-only``

## Query priority

1. ``graphify query "<question>"`` (needs ``graphify-out/graph.json``)
2. ``wiki/index.md`` -> topic pages
3. ``README.md`` / ``raw/``

## Naming

- Topic pages: ``wiki/NN-*.md`` or ``wiki/<topic>/NN-*.md``
"@

  $index = @"
# $name Knowledge Index

> $blurb

Prefer ``graphify query "<question>"`` for code/structure questions (graph at ``graphify-out/``).

## Overview

| Page | Content |
|------|---------|
| [00 - Project overview](00-overview.md) | Positioning, entry points, wiki status |

## Raw sources

Put ingestible materials in ``raw/``, then ask an Agent to ingest and update this index.

## Changelog

See [wiki/log.md](log.md)
"@

  $overview = @"
# 00 - $name Project Overview

## Definition

$blurb

This page is the LLM wiki entry for ``my-project/$name``.

## Actionable conclusions

| Item | Value |
|------|-------|
| Path | ``$root`` |
| Headroom project id | ``$name`` (if listed in ``cursorEnv/headroom-projects.json``) |
| Wiki | ``wiki/`` |
| Knowledge graph | ``graphify-out/`` (``graphify update .``) |
| Raw sources | ``raw/`` |

## Evidence / sources

- Root files such as ``README.md`` (if present)
- Materials under ``raw/`` after ingest

## Related pages

- [Index](index.md)
- [Changelog](log.md)
"@

  $log = @"
# Wiki Changelog

Newest first.

## $today - Initialize LLM wiki scaffold

**Sources**
- ``cursorEnv/scripts/bootstrap-llm-wiki-graphify.ps1``
- LLM wiki bootstrap rule (idempotent; do not overwrite non-empty files)

**Created / updated**
- ``raw/``, ``wiki/``, ``schema/``
- ``AGENTS.md``, ``wiki/index.md``, ``wiki/log.md``, ``wiki/00-overview.md``
- ``schema/page-template.md`` (if missing)

**Notes**
- First pass leaves ``raw/`` empty until materials are added
- Graph initialized/refreshed with ``graphify update .`` (AST-only)
"@

  $actions += "AGENTS.md=$(Write-IfMissing (Join-Path $root 'AGENTS.md') $agents)"
  $actions += "wiki/index.md=$(Write-IfMissing (Join-Path $root 'wiki\index.md') $index)"
  $actions += "wiki/00-overview.md=$(Write-IfMissing (Join-Path $root 'wiki\00-overview.md') $overview)"
  $actions += "wiki/log.md=$(Write-IfMissing (Join-Path $root 'wiki\log.md') $log)"

  $schemaDest = Join-Path $root "schema\page-template.md"
  if (-not (Test-Path $schemaDest) -and (Test-Path $pageTemplateSrc)) {
    Copy-Item -LiteralPath $pageTemplateSrc -Destination $schemaDest -Force
    $actions += "schema/page-template.md=copied"
  } elseif (Test-Path $schemaDest) {
    $actions += "schema/page-template.md=exists"
  } else {
    $fallback = @"
# Page title

## Definition

(One sentence)

## Actionable conclusions

| Item | Value / action |
|------|----------------|
| ... | ... |

## Evidence / sources

- ``raw/...``

## Related pages

- [Index](../index.md)
"@
    $actions += "schema/page-template.md=$(Write-IfMissing $schemaDest $fallback)"
  }

  $gitkeep = Join-Path $root "raw\.gitkeep"
  if (-not (Test-Path $gitkeep)) {
    [System.IO.File]::WriteAllText($gitkeep, "", (New-Object System.Text.UTF8Encoding $false))
    $actions += "raw/.gitkeep=wrote"
  }

  Write-Host ($actions -join "; ")

  $graphStatus = "skipped"
  if (-not $SkipGraphify) {
    $graphJson = Join-Path $root "graphify-out\graph.json"
    Write-Host "[graphify] update $root ..."
    Push-Location $root
    try {
      & graphify update . 2>&1 | Out-Host
      if (($LASTEXITCODE -eq 0) -and (Test-Path $graphJson)) {
        $graphStatus = "ok"
      } else {
        $graphStatus = "failed-exit-$LASTEXITCODE"
      }
    } catch {
      $graphStatus = "error: $($_.Exception.Message)"
      Write-Host $graphStatus
    } finally {
      Pop-Location
    }
  }

  $results += [PSCustomObject]@{
    Project  = $name
    Wiki     = ($actions -join " | ")
    Graphify = $graphStatus
  }
}

Write-Host ""
Write-Host "======== SUMMARY ========"
$results | Format-Table -AutoSize -Wrap
$outJson = Join-Path $PSScriptRoot "bootstrap-llm-wiki-graphify.last.json"
$results | ConvertTo-Json -Depth 3 | Set-Content -LiteralPath $outJson -Encoding UTF8
Write-Host "Wrote $outJson"