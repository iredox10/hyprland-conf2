#!/usr/bin/env bash
# =============================================
#  Rofi WiFi Menu - Scan & Connect
# =============================================

# Get the current connection
CURRENT=$(nmcli -t -f NAME connection show --active 2>/dev/null | head -1)

# Scan for networks
nmcli device wifi rescan 2>/dev/null

# List available networks
NETWORKS=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | \
    awk -F: '{
        if ($1 != "" && $1 != "--") {
            lock = ($3 != "") ? "\uf023 " : "\uf09c ";
            signal = $2;
            if (signal > 75) icon = "\uf1eb";
            else if (signal > 50) icon = "\uf1eb";
            else if (signal > 25) icon = "\uf1eb";
            else icon = "\uf1eb";
            printf "%s  %s  %s %s%%\n", icon, $1, lock, signal
        }
    }' | sort -t'%' -k1 -rn | uniq)

# Add options
DISCONNECT="\uf127  Disconnect"
MANUAL="\uf11c  Manual Entry"
OPTIONS="$NETWORKS\n$DISCONNECT\n$MANUAL"

# Show rofi menu
CHOSEN=$(echo -e "$OPTIONS" | rofi -dmenu -i -p "  WiFi ($CURRENT)" -theme ~/.config/rofi/config.rasi)

# Handle selection
if [ -z "$CHOSEN" ]; then
    exit 0
fi

case "$CHOSEN" in
    *Disconnect)
        nmcli device disconnect wlan0 2>/dev/null || nmcli device disconnect wlp1s0 2>/dev/null
        notify-send "WiFi" "Disconnected" -i network-wireless-offline
        ;;
    *"Manual Entry")
        SSID=$(rofi -dmenu -p "SSID" -theme ~/.config/rofi/config.rasi)
        if [ -n "$SSID" ]; then
            PASS=$(rofi -dmenu -p "Password" -password -theme ~/.config/rofi/config.rasi)
            if [ -n "$PASS" ]; then
                nmcli device wifi connect "$SSID" password "$PASS" && \
                    notify-send "WiFi" "Connected to $SSID" -i network-wireless || \
                    notify-send "WiFi" "Failed to connect to $SSID" -i network-wireless-offline
            fi
        fi
        ;;
    *)
        # Extract SSID (second field after the icon)
        SSID=$(echo "$CHOSEN" | sed 's/^[^ ]* *//;s/ *[^ ]* *[0-9]*%$//')

        # Check if already a known network
        KNOWN=$(nmcli -t -f NAME connection show | grep -x "$SSID")
        if [ -n "$KNOWN" ]; then
            nmcli connection up "$SSID" && \
                notify-send "WiFi" "Connected to $SSID" -i network-wireless || \
                notify-send "WiFi" "Failed to connect to $SSID" -i network-wireless-offline
        else
            PASS=$(rofi -dmenu -p "Password for $SSID" -password -theme ~/.config/rofi/config.rasi)
            if [ -n "$PASS" ]; then
                nmcli device wifi connect "$SSID" password "$PASS" && \
                    notify-send "WiFi" "Connected to $SSID" -i network-wireless || \
                    notify-send "WiFi" "Failed to connect to $SSID" -i network-wireless-offline
            fi
        fi
        ;;
esac
