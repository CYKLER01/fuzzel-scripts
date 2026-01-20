#!/usr/bin/env bash
#
# Script: supergfx-switcher.sh
# Description: Uses fuzzel to provide a dmenu-style selection for
#              switching between SuperGFX modes (Integrated, Hybrid, AsusMuxDgpu).
#
# Dependencies: supergfxctl, fuzzel, notify-send

# --- Configuration ---

# List of available modes as defined by supergfxctl
MODES=("Integrated" "Hybrid" "AsusMuxDgpu")

# Notification timeout in milliseconds
NOTIFICATION_TIMEOUT=3000

# --- Script Logic ---

# 0. Get the current GPU mode and clean up the output (trims newline/whitespace)
# supergfxctl -g outputs the current mode (e.g., "Integrated").
CURRENT_MODE=$(supergfxctl -g 2>/dev/null | tr -d '\n' | tr -d ' ')

# 1. Use fuzzel to present the mode options.
# The prompt now includes the current mode.
SELECTION=$(printf "%s\n" "${MODES[@]}" | fuzzel \
    --dmenu \
    --prompt="GPU Mode (Current: $CURRENT_MODE):" \
    --lines="${#MODES[@]}" \
    --width=35 2>/dev/null
)

# 2. Check if the selection was cancelled or empty.
if [ -z "$SELECTION" ]; then
    notify-send -t "$NOTIFICATION_TIMEOUT" "SuperGFX Switch" "Mode selection cancelled."
    exit 0
fi

# 3. Execute the supergfxctl command.
# First, check if the selected mode is the current mode to avoid redundant action.
if [ "$SELECTION" = "$CURRENT_MODE" ]; then
    notify-send "SuperGFX Switch NO-OP" "GPU is already in $SELECTION mode."
    exit 0
fi

# Attempt to switch the mode
# FIX: Use '--mode=' syntax to explicitly pass the argument, which is the correct flag for this tool.
if OUTPUT=$(supergfxctl --mode="$SELECTION" 2>&1); then
    # Success
    
    # 3a. Inform the user that the switch was successful.
    notify-send "SuperGFX Switch SUCCESS" "Switched to $SELECTION mode. Restart required to apply changes."

    # 3b. PROMPT FOR REBOOT: Use fuzzel for a simple yes/no confirmation dialog.
    REBOOT_CHOICE=$(printf "Reboot Now\nLater" | fuzzel \
        --dmenu \
        --prompt="Restart system to apply $SELECTION mode?" \
        --lines=2 \
        --width=35 2>/dev/null
    )

    if [ "$REBOOT_CHOICE" = "Reboot Now" ]; then
        notify-send "System Restart" "Initiating system reboot..."
        # Execute the reboot command. Requires appropriate system privileges.
        systemctl reboot
    elif [ "$REBOOT_CHOICE" = "Later" ]; then
        notify-send "Reboot Delayed" "The $SELECTION mode change will take effect after your next manual reboot."
    fi
    
    # Optional: Log the switch command and output
    # echo "$(date): Successfully switched to $SELECTION" >> /tmp/supergfx_switch.log

else
    # Failure
    # Send a high-priority notification with the error details
    notify-send -u critical -t 7000 "SuperGFX Switch FAILED!" "Mode: $SELECTION\nError: $OUTPUT"
    
    # Optional: Log the error
    # echo "$(date): Failed to switch to $SELECTION. Error: $OUTPUT" >> /tmp/supergfx_switch.log
fi

