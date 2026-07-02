#!/bin/bash
if pgrep -x "wvkbd-mobintl" > /dev/null; then
    pkill -x "wvkbd-mobintl"
elif pgrep -x "wvkbd" > /dev/null; then
    pkill -x "wvkbd"
else
    # Try wvkbd-mobintl first, then fallback to wvkbd
    if command -v wvkbd-mobintl >/dev/null 2>&1; then
        wvkbd-mobintl -L 300 &
    elif command -v wvkbd >/dev/null 2>&1; then
        wvkbd -L 300 &
    else
        notify-send "On-Screen Keyboard" "wvkbd is not installed. Please install wvkbd." -u critical
    fi
fi
