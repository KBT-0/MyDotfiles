#!/usr/bin/env bash
# Claude Code status line for Linux/macOS; same layout as statusline.ps1 on Windows.
#   Line 1: model · effort │ dir │ branch* │ #PR
#   Line 2: context bar % │ 5h % left · 7d % left │ cache │ $cost │ +added -removed

export LC_ALL=C
input=$(cat)
command -v jq >/dev/null 2>&1 || { echo "statusline: jq not found on PATH"; exit 0; }

# One jq call; \x1f (not tab) keeps empty fields in place.
IFS=$'\x1f' read -r model effort cwd session ctx five five_reset week week_reset pr cache_seen cache_warm cache_hit cost added removed < <(
    jq -r '[.model.display_name, .effort.level, (.workspace.current_dir // .cwd), .session_id,
        (.context_window.used_percentage // 0),
        .rate_limits.five_hour.used_percentage, .rate_limits.five_hour.resets_at,
        .rate_limits.seven_day.used_percentage, .rate_limits.seven_day.resets_at,
        .pr.number, .prompt_cache.caching_observed, .prompt_cache.warm, (.prompt_cache.hit_ratio // 0),
        .cost.total_cost_usd, .cost.total_lines_added, .cost.total_lines_removed]
        | map(. // "" | tostring) | join("\u001f")' <<<"$input"
)

e=$'\e'
paint() { printf '%s' "$e[${1}m$2$e[0m"; }
level() { if [ "$1" -ge 80 ]; then echo 31; elif [ "$1" -ge 50 ]; then echo 33; else echo 32; fi; }
int() { printf '%.0f' "${1:-0}"; }
reset_in() {
    local left=$(( ${1:-0} - $(date +%s) ))
    [ "$left" -le 0 ] && { echo 0m; return; }
    if [ "$left" -ge 86400 ]; then echo "$(( left / 86400 ))d$(( left % 86400 / 3600 ))h"
    elif [ "$left" -ge 3600 ]; then echo "$(( left / 3600 ))h$(( left % 3600 / 60 ))m"
    else echo "$(( left / 60 ))m"; fi
}
join() { local out="$1"; shift; for part in "$@"; do out+=" $(paint 2 '│') $part"; done; printf '%s\n' "$out"; }

# Git is the slow part; cache it for 5s per session.
cache="${TMPDIR:-/tmp}/claude-statusline-git-$session"
mtime=$(stat -c %Y "$cache" 2>/dev/null || stat -f %m "$cache" 2>/dev/null || echo 0)
if [ $(( $(date +%s) - mtime )) -lt 5 ]; then
    git=$(cat "$cache")
else
    git=$(git -C "$cwd" branch --show-current 2>/dev/null)
    [ -n "$git" ] && [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ] && git+="*"
    printf '%s' "$git" > "$cache"
fi

dir=${cwd%/}; dir=${dir##*/}; [ -n "$dir" ] || dir=/
line1=("$(paint '1;36' "$model")${effort:+ $(paint 2 "· $effort")}" "$(paint 34 " $dir")")
[ -n "$git" ] && line1+=("$(paint 35 " $git")")
[ -n "$pr" ] && line1+=("$(paint 33 "#$pr")")

ctx=$(int "$ctx")
filled=$(( (ctx + 5) / 10 ))
bar=""
for i in 1 2 3 4 5 6 7 8 9 10; do if [ "$i" -le "$filled" ]; then bar+="█"; else bar+="░"; fi; done
line2=("$(paint "$(level "$ctx")" "$bar") $ctx%")

limits=""
if [ -n "$five" ]; then
    five=$(int "$five")
    limits="$(paint "$(level "$five")" "5h $five%")$(paint 2 "  $(reset_in "$five_reset")")"
fi
if [ -n "$week" ]; then
    week=$(int "$week")
    limits+="${limits:+ · }$(paint "$(level "$week")" "7d $week%")$(paint 2 "  $(reset_in "$week_reset")")"
fi
[ -n "$limits" ] && line2+=("$limits")

if [ "$cache_seen" = "true" ]; then
    if [ "$cache_warm" = "true" ]; then line2+=("$(paint 32 "cache $(int "$(awk "BEGIN{print $cache_hit*100}")")%")")
    else line2+=("$(paint 2 'cache cold')"); fi
fi

[ -n "$cost" ] && line2+=("$(paint 33 "💰\$$(printf '%.2f' "$cost")")")
{ [ -n "$added" ] || [ -n "$removed" ]; } && line2+=("$(paint 32 "+${added:-0}") $(paint 31 "-${removed:-0}")")

join "${line1[@]}"
join "${line2[@]}"
