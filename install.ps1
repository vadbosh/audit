<#
Install the audit skill — Windows.  Linux / macOS: use install.sh

The skill is three Markdown files and nothing else: no binary, no PATH entry,
no runtime. Installing it is a copy into each assistant's skills directory.

    .\install.ps1                 install into every assistant found
    .\install.ps1 -DryRun         print what would happen, change nothing
    .\install.ps1 -SkillsDir D    install into D instead of auto-detecting

Idempotent: re-running replaces only what changed. A file it overwrites is
copied to <file>.bak.<timestamp> ONLY when that content is not already in the
source repository — a hand edit is the one thing git cannot give back.
Nothing outside $HOME is touched.
#>
[CmdletBinding()]
param(
    [switch]$DryRun,
    [string]$SkillsDir = ''
)

$ErrorActionPreference = 'Stop'
$Src   = Split-Path -Parent $MyInvocation.MyCommand.Path
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$Home_ = $env:USERPROFILE

function Say  { param($m) Write-Host $m }
function Ok   { param($m) Write-Host $m -ForegroundColor Green }
function Warn { param($m) Write-Host $m -ForegroundColor Yellow }
function Tilde { param($p) $p -replace [regex]::Escape($Home_), '~' }

# Is this exact content already in the repository's object database? Then it is
# one `git checkout` away and a backup of it is worth nothing.
function In-GitHistory {
    param($Path)
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) { return $false }
    $sha = & git -C $Src hash-object $Path 2>$null
    if (-not $sha) { return $false }
    & git -C $Src cat-file -e $sha 2>$null
    return ($LASTEXITCODE -eq 0)
}

function Install-File {
    param($From, $To)
    if ((Test-Path $To) -and
        ((Get-FileHash $From).Hash -eq (Get-FileHash $To).Hash)) {
        Say "    = $(Tilde $To)"
        return
    }
    if ($DryRun) { Say "    would write $(Tilde $To)"; return }
    $dir = Split-Path -Parent $To
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    if (Test-Path $To) {
        if (In-GitHistory $To) {
            Say "    ~ $(Tilde $To)"
        } else {
            Copy-Item $To "$To.bak.$Stamp"
            Say "    ~ $(Tilde $To)  (backup .bak.$Stamp — edited by hand, not in git)"
        }
    } else {
        Say "    + $(Tilde $To)"
    }
    Copy-Item $From $To -Force
}

# Only assistants already present are written to — creating a config tree for
# one the person does not have would just litter their home.
function Get-SkillDirs {
    if ($SkillsDir) { return @($SkillsDir) }
    $candidates = @(
        (Join-Path $Home_ '.claude\skills'),
        (Join-Path $env:APPDATA 'opencode\skills'),
        (Join-Path $Home_ '.codex\skills')
    )
    $candidates | Where-Object { Test-Path (Split-Path -Parent $_) }
}

Say '── audit ──'
if ($DryRun) { Warn '  dry run — nothing will be written' }

$dirs = @(Get-SkillDirs)
if ($dirs.Count -eq 0) {
    Warn '  no assistant directory found — nothing installed.'
    Warn '  Point at one yourself: .\install.ps1 -SkillsDir <path>'
    exit 1
}

# Ask the source what it ships rather than listing files here: a fourth
# reference page added to the skill and forgotten in this list would be
# missing from every install with nothing to say so.
$shipped = Get-ChildItem -Path (Join-Path $Src 'skills\audit') -Recurse -File |
           Where-Object { $_.Name -notlike '*.bak.*' }

foreach ($dir in $dirs) {
    Say "  $(Tilde $dir)"
    foreach ($f in $shipped) {
        $rel = $f.FullName.Substring((Join-Path $Src 'skills\audit').Length + 1)
        Install-File $f.FullName (Join-Path $dir "audit\$rel")
    }
}

Say '── verify ──'
$rc = 0
foreach ($dir in $dirs) {
    $skill = Join-Path $dir 'audit\SKILL.md'
    if ($DryRun) { Say "  would verify $(Tilde $skill)"; continue }
    if ((Test-Path $skill) -and (Select-String -Path $skill -Pattern '^name: audit$' -Quiet)) {
        Ok "  ok — $(Tilde (Split-Path -Parent $skill))"
    } else {
        Warn "  FAILED — $(Tilde $skill) is not the audit skill"
        $rc = 1
    }
}

Say ''
Say "  In your assistant: say 'audit <what>' or '/audit <what>'."
Say '  It writes review-YYYY-MM-DD-<object>.md and changes nothing else.'
exit $rc
