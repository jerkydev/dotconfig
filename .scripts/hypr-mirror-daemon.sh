#!/usr/bin/env bash

# Hyprland daemon. Deactivates laptop's screen when an external monitor is connected.

set -e

notify() {
    local message="$1"
    notify-send -a "HyprMonitorWatcher" -t 2500 "${message}"
    echo "${message}"
}

get_external_monitor() {
    hyprctl monitors | grep -oE '^Monitor (DP|HDMI|USB|ANX|typec|unknown)-[0-9]+' | awk '{print $2}' | head -n1
}

disable_monitor() {
    hyprctl keyword monitor "eDP-1,disable"
}

enable_monitor() {
    hyprctl keyword monitor "eDP-1,preferred,auto,1"
}

if [[ -n $(get_external_monitor) ]]; then
    disable_monitor
fi

SOCK="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

if [[ ! -S "${SOCK}" ]]; then
    notify "❌ Hyprland socket not found. Exiting."
    exit 1
fi

socat -u UNIX-CONNECT:"${SOCK}" - | while read -r line; do
    if [[ "${line}" == *"monitoraddedv2"* && -n $(get_external_monitor) ]]; then
        disable_monitor
    elif [[ "${line}" == *"monitorremovedv2"* && -z $(get_external_monitor) ]]; then
        enable_monitor
    fi
done
