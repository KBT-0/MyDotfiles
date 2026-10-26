#!/usr/bin/env bash
# Claude Code hook: notify only when Claude is really waiting on you.
# Claude Code writes the returned terminalSequence to the terminal itself (no /dev/tty needed).
input=$(cat)
q() { jq -r "$1 // empty" <<<"$input"; }

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
    # Agent-type work or a one-shot wakeup will resume the turn: not waiting on you.
    # Shell/monitor tasks and recurring crons may never end (dev server, /loop), so they don't suppress.
    [ "$(jq '[(.background_tasks // [])[] | select(.type | test("subagent|workflow|teammate|cloud session|MCP task"))]
      + [(.session_crons // [])[] | select(.recurring | not)] | length' <<<"$input")" = 0 ] || exit 0
    what="Cevabını bekliyor"; body=$(q .last_assistant_message) ;;
  PreToolUse) what="Soru soruyor"; body=$(q '.tool_input.questions[0].question') ;;
  *) what="İzin bekliyor"; body=$(q .message) ;;
esac

title="Claude · $(basename "$(q .cwd)") — $what"
body=$(printf '%s' "$body" | tr '\n\t' '  ' | tr -d '\000-\037'); body=${body:0:140}

if [ -n "$KITTY_WINDOW_ID" ]; then
  # Looking at this window already: no popup, no sound. kitty's own o=unfocused also hid it from a
  # sibling tab, so ask kitty over its socket instead (kitty started without it: always notify).
  # The same id replaces this session's previous notification.
  [ -n "$KITTY_LISTEN_ON" ] && kitty @ ls --match "id:$KITTY_WINDOW_ID" 2>/dev/null |
    jq -e 'any(.[].tabs[].windows[]; .is_focused)' >/dev/null && exit 0
  # f/n/p=icon: shown as "Claude" with the Claude icon instead of kitty's (g caches the icon in kitty).
  b64() { base64 | tr -d '\n'; }
  seq=$(printf '\033]99;i=%s:d=0:o=always:a=focus:f=%s:n=%s:g=claude-notify-icon;%s\033\\\033]99;i=%s:d=0:p=body;%s\033\\' \
    "$id" "$(printf Claude | b64)" "$(printf claude | b64)" "$title" "$id" "$body")
  icon="$HOME/.claude/notify-icon.png"
  [ -f "$icon" ] && seq+=$(printf '\033]99;i=%s:d=0:p=icon:e=1;%s\033\\' "$id" "$(b64 <"$icon")")
  seq+=$(printf '\033]99;i=%s:d=1;\033\\' "$id")
elif [ "$TERM_PROGRAM" = ghostty ] || [ "$TERM_PROGRAM" = WarpTerminal ]; then
  seq=$(printf '\033]777;notify;%s;%s\007' "${title//;/,}" "${body//;/,}")
else
  # Windows Terminal, WezTerm, iTerm2
  seq=$(printf '\033]9;%s: %s\007' "$title" "$body")
fi
# Bare BEL marks the tab (kitty bell_on_tab, Windows Terminal tab bell icon).
emit "$seq$(printf '\a')"

sound="$HOME/.claude/notify.wav"
for p in pw-play paplay afplay; do
  command -v "$p" >/dev/null && { (nohup "$p" "$sound" >/dev/null 2>&1 &); break; }
done
exit 0
