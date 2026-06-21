#!/usr/bin/env bash
# Waybar auto-restart wrapper
# If waybar crashes, it restarts automatically after 2 seconds

while true; do
    waybar
    sleep 2
done
