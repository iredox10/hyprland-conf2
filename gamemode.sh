#!/usr/bin/env bash
HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl --batch "\
        keyword animations:enabled 0;\
        keyword decoration:drop_shadow 0;\
        keyword decoration:blur:enabled 0;\
        keyword general:gaps_in 0;\
        keyword general:gaps_out 0;\
        keyword general:border_size 1;\
        keyword decoration:rounding 0"
    notify-send "Game Mode" "Animations & Blur Disabled" -u normal -i "system-run"
else
    hyprctl --batch "\
        keyword animations:enabled 1;\
        keyword decoration:drop_shadow 1;\
        keyword decoration:blur:enabled 1;\
        keyword general:gaps_in 5;\
        keyword general:gaps_out 10;\
        keyword general:border_size 2;\
        keyword decoration:rounding 10"
    notify-send "Game Mode" "Animations & Blur Restored" -u normal -i "system-run"
fi
