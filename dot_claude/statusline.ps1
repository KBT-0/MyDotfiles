# Claude Code status line for native Windows (PowerShell 7, no jq/bash needed).
#   Line 1: model · effort   dir   branch*   #PR
#   Line 2: context bar %   5h % ↻left · 7d % ↻left   cache   $cost   +added -removed

$ErrorActionPreference = 'SilentlyContinue'
[Console]::OutputEncoding = [Text.Encoding]::UTF8
$d = [Console]::In.ReadToEnd() | ConvertFrom-Json
$e = [char]27

function Paint([string] $Code, [string] $Text) { "$e[${Code}m$Text$e[0m" }
function Level([double] $Pct) { if ($Pct -ge 80) { '31' } elseif ($Pct -ge 50) { '33' } else { '32' } }
function ResetIn($Epoch) {
    $left = [DateTimeOffset]::FromUnixTimeSeconds([long]$Epoch) - [DateTimeOffset]::Now
    if ($left.TotalSeconds -le 0) { return '0m' }
    if ($left.TotalDays -ge 1) { return '{0}d{1}h' -f [int][Math]::Floor($left.TotalDays), $left.Hours }
    if ($left.TotalHours -ge 1) { return '{0}h{1}m' -f [int][Math]::Floor($left.TotalHours), $left.Minutes }
    '{0}m' -f $left.Minutes
}

$cwd = $d.workspace.current_dir ?? $d.cwd
$sep = Paint '2' '│'

# Git is the slow part; cache it for 5s per session.
$cache = Join-Path $env:TEMP "claude-statusline-git-$($d.session_id)"
$item = Get-Item -LiteralPath $cache
if ($item -and ((Get-Date) - $item.LastWriteTime).TotalSeconds -lt 5) {
    $git = Get-Content -LiteralPath $cache -Raw
} else {
    $git = git -C $cwd branch --show-current 2>$null
    if ($git -and (git -C $cwd status --porcelain 2>$null)) { $git += '*' }
    Set-Content -LiteralPath $cache -Value "$git" -NoNewline
}

$line1 = @(Paint '1;36' $d.model.display_name)
if ($d.effort.level) { $line1[0] += ' ' + (Paint '2' "· $($d.effort.level)") }
$line1 += Paint '34' " $(Split-Path $cwd -Leaf)"
if ($git) { $line1 += Paint '35' " $git" }
if ($d.pr.number) { $line1 += Paint '33' "#$($d.pr.number)" }

$ctx = [double]($d.context_window.used_percentage ?? 0)
$filled = [int][Math]::Round($ctx / 10)
$line2 = @((Paint (Level $ctx) (('█' * $filled) + ('░' * (10 - $filled)))) + " $([int]$ctx)%")

$five = $d.rate_limits.five_hour
$week = $d.rate_limits.seven_day
if ($five -or $week) {
    $limits = @()
    if ($five) { $limits += (Paint (Level $five.used_percentage) "5h $([int]$five.used_percentage)%") + (Paint '2' " ↻$(ResetIn $five.resets_at)") }
    if ($week) { $limits += (Paint (Level $week.used_percentage) "7d $([int]$week.used_percentage)%") + (Paint '2' " ↻$(ResetIn $week.resets_at)") }
    $line2 += $limits -join ' · '
}

$pc = $d.prompt_cache
if ($pc.caching_observed) {
    $line2 += if ($pc.warm) { Paint '32' "cache $([int]($pc.hit_ratio * 100))%" } else { Paint '2' 'cache cold' }
}

if ($null -ne $d.cost.total_cost_usd) { $line2 += Paint '33' ('💰$' + ([double]$d.cost.total_cost_usd).ToString('0.00', [Globalization.CultureInfo]::InvariantCulture)) }

$added = $d.cost.total_lines_added
$removed = $d.cost.total_lines_removed
if ($added -or $removed) { $line2 += (Paint '32' "+$added") + ' ' + (Paint '31' "-$removed") }

$line1 -join " $sep "
$line2 -join " $sep "
