# Claude Code hook (Windows): notify only when Claude is really waiting on you.
# Claude Code writes the returned terminalSequence to the terminal itself.
# Windows consoles default to an OEM code page; hook JSON is UTF-8 both ways.
[Console]::InputEncoding = [Console]::OutputEncoding = [Text.UTF8Encoding]::new($false)
$in = [Console]::In.ReadToEnd() | ConvertFrom-Json
if ($in.hook_event_name -eq 'UserPromptSubmit') { exit 0 }
# No terminal you look at (daemon-spawned sessions): stay silent.
if (-not ($env:WT_SESSION -or $env:TERM_PROGRAM)) { exit 0 }

switch ($in.hook_event_name) {
    'Stop' {
        # Any background task or scheduled wakeup will resume the turn: not waiting on you.
        if (@($in.background_tasks | Where-Object { $_ }).Count + @($in.session_crons | Where-Object { $_ }).Count -gt 0) { exit 0 }
        $what = 'Cevabını bekliyor'; $body = $in.last_assistant_message
    }
    # A question is also a "permission prompt" to Claude Code (6 s later): remember it, skip that echo.
    'PreToolUse' { New-Item -Force (Join-Path $env:TEMP "claude-question-$($in.session_id)") | Out-Null; $what = 'Soru soruyor'; $body = $in.tool_input.questions[0].question }
    default {
        $stamp = Join-Path $env:TEMP "claude-question-$($in.session_id)"
        if ((Test-Path $stamp) -and (Get-Item $stamp).LastWriteTime -gt (Get-Date).AddSeconds(-15)) { exit 0 }
        $what = 'İzin bekliyor'; $body = $in.message
    }
}

$title = "Claude · $(Split-Path -Leaf $in.cwd) — $what"
$body = ("$body" -replace '[\x00-\x1f]', ' ')
if ($body.Length -gt 140) { $body = $body.Substring(0, 140) }

$e = [char]27; $bel = [char]7
@{ terminalSequence = "$e]9;${title}: $body$bel$bel" } | ConvertTo-Json -Compress

$wav = Join-Path $HOME '.claude/notify.wav'
if (Test-Path $wav) { (New-Object Media.SoundPlayer $wav).PlaySync() }
