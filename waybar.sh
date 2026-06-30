#!/usr/bin/env bash
# Waybar auto-restart wrapper
# If waybar crashes, it restarts automatically after 2 seconds
# All output suppressed to prevent terminal spam

while true; do
    waybar &>/dev/null
    sleep 2
done
