#!/usr/bin/env bash
# =============================================
#  Power Menu - Catppuccin Mocha Rofi Script
# =============================================

options="\uf023  Lock\n\uf2f5  Logout\n\uf186  Suspend\n\uf2ea  Reboot\n\uf011  Shutdown"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power" -theme ~/.config/rofi/powermenu.rasi)

case "$chosen" in
    *Lock)
        hyprlock
        ;;
    *Logout)
        hyprctl dispatch exit
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
esac
