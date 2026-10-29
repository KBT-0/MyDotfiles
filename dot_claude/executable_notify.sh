#!/usr/bin/env bash
# Claude Code hook: notify only when Claude is really waiting on you.
# Claude Code writes the returned terminalSequence to the terminal itself (no /dev/tty needed).
input=$(cat)
q() { jq -r "$1 // empty" <<<"$input"; }

# No terminal you look at (daemon-spawned bg/worker/teammate sessions have a pty but no
# terminal emulator around it): no popup could reach you, so stay silent, no sound either.
[ -n "$KITTY_WINDOW_ID$TERM_PROGRAM$WT_SESSION$TMUX" ] || exit 0

event=$(q .hook_event_name)
id=$(q .session_id | tr -cd 'a-zA-Z0-9-')
emit() { jq -nc --arg seq "$1" '{terminalSequence: $seq}'; }

# Kitty: close this session's notification once you answer.
if [ "$event" = UserPromptSubmit ]; then
  [ -n "$KITTY_WINDOW_ID" ] && emit "$(printf '\033]99;i=%s:p=close;\033\\' "$id")"
  [ "$TERM_PROGRAM" = Apple_Terminal ] && command -v terminal-notifier >/dev/null &&
    (terminal-notifier -remove "claude-$id" >/dev/null 2>&1 &)
  exit 0
fi

case "$event" in
  Stop)
    # Any background task or scheduled wakeup will resume the turn: not waiting on you.
    # shortcut: a never-ending task (dev server, /loop) also silences this for its session; questions and permission prompts still notify.
    [ "$(jq '(.background_tasks // []) + (.session_crons // []) | length' <<<"$input")" = 0 ] || exit 0
    what="Cevabını bekliyor"; body=$(q .last_assistant_message) ;;
  # A question is also a "permission prompt" to Claude Code (6 s later): remember it, skip that echo.
  PreToolUse) touch "${TMPDIR:-/tmp}/claude-question-$id"; what="Soru soruyor"; body=$(q '.tool_input.questions[0].question') ;;
  *) [ -n "$(find "${TMPDIR:-/tmp}/claude-question-$id" -newermt '-15 seconds' 2>/dev/null)" ] && exit 0
     what="İzin bekliyor"; body=$(q .message) ;;
esac

title="Claude · $(basename "$(q .cwd)") — $what"
body=$(printf '%s' "$body" | tr '\n\t' '  ' | tr -d '\000-\037'); body=${body:0:140}

if [ -n "$KITTY_WINDOW_ID" ]; then
  # o=unfocused: kitty drops the popup when you are looking at this window (any tab, any workspace).
  # s=: kitty plays the sound itself, only when it really shows the popup (libcanberra looks the
  # name up in ~/.local/share/sounds/freedesktop/stereo/claude-notify.wav). Same id replaces the
  # session's previous notification. f/n: shown as "Claude" with the Claude icon; n is a file path.
  # No a=focus: it yanked you to the terminal from another workspace.
  # Never inline the icon data (p=icon): Claude Code silently drops a terminalSequence that large.
  b64() { base64 | tr -d '\n'; }
  seq=$(printf '\033]99;i=%s:d=0:o=unfocused:s=%s:f=%s:n=%s;%s\033\\\033]99;i=%s:d=0:p=body;%s\033\\' \
    "$id" "$(printf claude-notify | b64)" "$(printf Claude | b64)" "$(printf %s "$HOME/.claude/notify-icon.png" | b64)" "$title" "$id" "$body")
  seq+=$(printf '\033]99;i=%s:d=1;\033\\' "$id")
  emit "$seq$(printf '\a')"
  exit 0
elif [ "$TERM_PROGRAM" = ghostty ] || [ "$TERM_PROGRAM" = WarpTerminal ]; then
  seq=$(printf '\033]777;notify;%s;%s\007' "${title//;/,}" "${body//;/,}")
elif [ "$TERM_PROGRAM" = Apple_Terminal ]; then
  # Like kitty's o=unfocused: stay silent when Terminal is in front showing this session's tab.
  tty=; p=$PPID
  while [ "${p:-1}" -gt 1 ]; do
    tty=$(ps -o tty= -p "$p" | tr -d ' '); [ "$tty" != '??' ] && break
    p=$(ps -o ppid= -p "$p" | tr -d ' ')
  done
  front=$(osascript -e 'tell application "Terminal" to if frontmost then return tty of selected tab of front window' 2>/dev/null)
  [ -n "$front" ] && [ "$front" = "/dev/$tty" ] && exit 0
  # Apple Terminal ignores OSC 9/777: post through Notification Center.
  if command -v terminal-notifier >/dev/null && [[ $tty == ttys* ]]; then
    # Click brings this session's tab forward; -group makes the next one replace it, like kitty's i=.
    focus="osascript -e 'tell application \"Terminal\"' -e 'activate' -e 'repeat with w in windows' -e 'try' -e 'repeat with t in tabs of w' -e 'if tty of t is \"/dev/$tty\" then' -e 'set selected tab of w to t' -e 'set index of w to 1' -e 'end if' -e 'end repeat' -e 'end try' -e 'end repeat' -e 'end tell'"
    (terminal-notifier -title "$title" -message "$body" -group "claude-$id" -execute "$focus" >/dev/null 2>&1 &)
  else
    # Argv, so no AppleScript injection. A click here opens Script Editor, not the tab.
    (osascript -e 'on run a' -e 'display notification (item 2 of a) with title (item 1 of a)' -e 'end run' "$title" "$body" >/dev/null 2>&1 &)
  fi
  seq=""
else
  # Windows Terminal, WezTerm, iTerm2
  seq=$(printf '\033]9;%s: %s\007' "$title" "$body")
fi
# Bare BEL marks the tab (Windows Terminal tab bell icon).
emit "$seq$(printf '\a')"

sound="$HOME/.claude/notify.wav"
for p in pw-play paplay afplay; do
  command -v "$p" >/dev/null && { (nohup "$p" "$sound" >/dev/null 2>&1 &); break; }
done
exit 0
