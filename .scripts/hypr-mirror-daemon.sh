#!/usr/bin/env bash

# Hyprland automatic mirror daemon with notifications
# Toggles between mirror and extend modes automatically based on external display connection.

set -e

notify() {
    local message="$1"
    notify-send -a "HyprMirror" -t 2500 "${message}"
    echo "${message}"
}

LAPTOP=$(hyprctl monitors | grep -oE '^Monitor eDP-[0-9]+' | head -n1 | awk '{print $2}')
if [[ -z "${LAPTOP}" ]]; then
    notify "HyprMirror" "❌ No internal laptop screen (eDP) found."
    exit 1
fi

STATE_FILE="/tmp/hypr_mirror_state"

apply_extend_mode() {
    local external="$1"
    notify "🔄 Switching to EXTEND mode"
    hyprctl keyword monitor "${external},5120x2880,auto,2"
    hyprctl keyword monitor "${LAPTOP},preferred,auto,1"
    echo "extend" > "${STATE_FILE}"
    hyprctl reload
}

apply_single_mode() {
    notify "🔄 Switching to SINGLE mode"
    hyprctl keyword monitor "${LAPTOP},preferred,auto,1"
    echo "extend" > "${STATE_FILE}"
    hyprctl reload
}

apply_mirror_mode() {
    local external="$1"
    notify "🪞 Switching to MIRROR mode"
    hyprctl keyword monitor "${external},5120x2880,0x0,2"
    hyprctl keyword monitor "${LAPTOP},5120x2880,0x0,2,mirror,${external}"
    echo "mirror" > "${STATE_FILE}"
    hyprctl reload
}

get_external_monitor() {
    hyprctl monitors | grep -oE '^Monitor (DP|HDMI|USB|ANX|typec|unknown)-[0-9]+' | awk '{print $2}' | grep -v "${LAPTOP}" | head -n1
}

toggle_manual() {
    local external
    external=$(get_external_monitor)
    if [[ -z "${external}" ]]; then
        apply_single_mode
        return
    fi

    local current
    current=$(cat "${STATE_FILE}" 2>/dev/null || echo "extend")

    if [[ "${current}" == "mirror" ]]; then
        apply_extend_mode "${external}"
    else
        apply_mirror_mode "${external}"
    fi
}

# If run with 'toggle', do just one toggle
if [[ "$1" == "toggle" ]]; then
    toggle_manual
    exit 0
fi

# --- Daemon mode ---
# notify "🖥️ HyprMirror Daemon started"
# echo "extend" > "$STATE_FILE"

# # Watch for monitor add/remove events via Hyprland socket
# SOCK="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# if [[ ! -S "$SOCK" ]]; then
#     notify "❌ Hyprland socket not found. Exiting."
#     exit 1
# fi

# socat -u UNIX-CONNECT:"$SOCK" - | while read -r line; do
#     if [[ "$line" == *"monitoradded"* ]]; then
#         external=$(get_external_monitor)
#         [[ -n "$external" ]] && apply_mirror_mode "$external"
#     elif [[ "$line" == *"monitordeleted"* ]]; then
#         apply_extend_mode ""
#     fi
# done
