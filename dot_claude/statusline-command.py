#!/usr/bin/env python3
"""Claude Code statusLine: model | ctx remaining | 5h remaining | 7d remaining.
Reads the status JSON from stdin (schema: model.display_name, context_window.*,
rate_limits.five_hour/.seven_day.used_percentage). No jq on this box, so pure stdlib.
"""
import sys, json

def color(remaining):
    # higher remaining = better
    if remaining is None:
        return "90"          # grey
    if remaining >= 50:
        return "32"          # green
    if remaining >= 20:
        return "33"          # yellow
    return "31"              # red

def paint(code, text):
    return f"\033[{code}m{text}\033[0m"

try:
    data = json.load(sys.stdin)
except Exception:
    print("")
    sys.exit(0)

seg = []

model = (data.get("model") or {}).get("display_name")
if model:
    seg.append(paint("35", model))   # magenta

# context remaining for current chat
cw = data.get("context_window") or {}
rem = cw.get("remaining_percentage")
if rem is None and cw.get("used_percentage") is not None:
    rem = 100 - cw["used_percentage"]
if rem is not None:
    rem = round(rem)
    seg.append(paint(color(rem), f"ctx {rem}%"))

# rate limits: remaining = 100 - used
rl = data.get("rate_limits") or {}
for key, label in (("five_hour", "5h"), ("seven_day", "7d")):
    win = rl.get(key) or {}
    used = win.get("used_percentage")
    if used is not None:
        r = round(100 - used)
        seg.append(paint(color(r), f"{label} {r}%"))

sep = paint("90", " · ")
sys.stdout.write(sep.join(seg))
