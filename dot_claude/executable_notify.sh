#!/usr/bin/env bash
# Claude Code hook: notify only when Claude is really waiting on you.
# Claude Code writes the returned terminalSequence to the terminal itself (no /dev/tty needed).
input=$(cat)
q() { jq -r "$1 // empty" <<<"$input"; }

# Background sessions (claude --bg daemon) have no terminal you look at: stay silent.
[ "$CLAUDE_CODE_SESSION_KIND" = bg ] && exit 0

event=$(q .hook_event_name)
id=$(q .session_id | tr -cd 'a-zA-Z0-9-')
emit() { jq -nc --arg seq "$1" '{terminalSequence: $seq}'; }

# Kitty: close this session's notification once you answer.
if [ "$event" = UserPromptSubmit ]; then
  [ -n "$KITTY_WINDOW_ID" ] && emit "$(printf '\033]99;i=%s:p=close;\033\\' "$id")"
  exit 0
fi

case "$event" in
  Stop)
    # Any background task or scheduled wakeup will resume the turn: not waiting on you.
    # shortcut: a never-ending task (dev server, /loop) also silences this for its session; questions and permission prompts still notify.
    [ "$(jq '(.background_tasks // []) + (.session_crons // []) | length' <<<"$input")" = 0 ] || exit 0
    what="Cevabını bekliyor"; body=$(q .last_assistant_message) ;;
  PreToolUse) what="Soru soruyor"; body=$(q '.tool_input.questions[0].question') ;;
  *) what="İzin bekliyor"; body=$(q .message) ;;
esac

title="Claude · $(basename "$(q .cwd)") — $what"
body=$(printf '%s' "$body" | tr '\n\t' '  ' | tr -d '\000-\037'); body=${body:0:140}

if [ -n "$KITTY_WINDOW_ID" ]; then
  # o=unfocused: kitty drops the popup when you are looking at this window (any tab, any workspace).
  # s=: kitty plays the sound itself, only when it really shows the popup (libcanberra looks the
  # name up in ~/.local/share/sounds/freedesktop/stereo/claude-notify.wav). Same id replaces the
  # session's previous notification. f/n: shown as "Claude" with the Claude icon; n is a file path.
  # Never inline the icon data (p=icon): Claude Code silently drops a terminalSequence that large.
  b64() { base64 | tr -d '\n'; }
  seq=$(printf '\033]99;i=%s:d=0:o=unfocused:a=focus:s=%s:f=%s:n=%s;%s\033\\\033]99;i=%s:d=0:p=body;%s\033\\' \
    "$id" "$(printf claude-notify | b64)" "$(printf Claude | b64)" "$(printf %s "$HOME/.claude/notify-icon.png" | b64)" "$title" "$id" "$body")
  seq+=$(printf '\033]99;i=%s:d=1;\033\\' "$id")
  emit "$seq$(printf '\a')"
  exit 0
elif [ "$TERM_PROGRAM" = ghostty ] || [ "$TERM_PROGRAM" = WarpTerminal ]; then
  seq=$(printf '\033]777;notify;%s;%s\007' "${title//;/,}" "${body//;/,}")
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
