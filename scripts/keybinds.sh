#!/bin/bash

# Configuration
KEYBINDS_FILE="$HOME/.config/hypr/hyprland/keybinds.conf"

# --- Function to format keybindings and launch fuzzel ---
show_keybinds() {
    if [ ! -f "$KEYBINDS_FILE" ]; then
        notify-send "Error" "Keybindings file not found at $KEYBINDS_FILE"
        exit 1
    fi

    (
        echo "--- Hyprland Keybindings ---"
        echo "KEY COMBINATION              | DISPATCHER + ARGUMENTS"
        echo "-----------------------------|----------------------------------------"

        # Use grep -E to capture ALL bind types
        grep -E '^(bind[a-z]*|submap) =' "$KEYBINDS_FILE" | awk '
            {
                # --- 1. Cleanup and Normalization ---
                
                # Strip Comments
                sub(/#.*$/, "", $0)
                
                # Trim leading/trailing whitespace
                gsub(/^[[:space:]]+|[[:space:]]+$/, "", $0)
                
                # Remove the initial "bind..." prefix (e.g., "bind = ", "bindl = ", etc.)
                line = $0
                sub(/^(bind[a-z]*|submap)[[:space:]]*=[[:space:]]*/, "", line)

                # Define the pattern of known command words
                DISPATCHERS = "(execr?|global|submap|killactive|fullscreen|togglefloating|movewindow|resizewindow|movefocus|workspace|movetoworkspace|cyclenext|changegroupactive|togglegroup|moveoutofgroup|lockactivegroup|pin|centerwindow|splitratio)"
                PATTERN = ",[[:space:]]*" DISPATCHERS
                
                # --- 2. Split the line based on the first dispatcher ---
                
                KEY_MODS = ""
                FULL_ACTION = ""
                
                # Find the position of the first dispatcher keyword
                if (match(line, PATTERN, arr)) {
                    # KEY_MODS is everything BEFORE the match
                    KEY_MODS = substr(line, 1, RSTART - 1)
                    
                    # FULL_ACTION is everything FROM the match onwards
                    FULL_ACTION = substr(line, RSTART + 1)
                } else {
                    # Fallback for simple keybinds that might be misformatted
                    if (match(line, /,/, arr)) {
                        KEY_MODS = substr(line, 1, RSTART - 1)
                        FULL_ACTION = substr(line, RSTART + 1)
                    } else {
                        next # Skip lines that don t look like keybinds
                    }
                }

                # --- 3. Clean and Process KEY_MODS (FINAL LOGIC) ---
                
                # Remove all commas
                gsub(/,/, "", KEY_MODS)
                
                # Key/Modifier Simplification
                gsub(/Super/, "󰖳", KEY_MODS)
                gsub(/SPACE/, "󱁐", KEY_MODS)
                gsub(/Space/, "󱁐", KEY_MODS)
                gsub(/Shift/, "󰘶", KEY_MODS)
                gsub(/Backslash/, "\\", KEY_MODS)
                gsub(/Escape/, "Esc", KEY_MODS)
                gsub(/Period/, ".", KEY_MODS)
                gsub(/Comma/, ",", KEY_MODS)
                
                # ----------------------------------------------------
                # FIX for "extra pluses":
                # Normalize all existing separators (+ and whitespace) to a pipe symbol (|)
                gsub(/[\+[:space:]]+/, "|", KEY_MODS)
                
                # Remove leading/trailing pipes
                gsub(/^\||\|$/, "", KEY_MODS)
                
                # Replace the single pipe separator with a clean " + "
                gsub(/\|/, " + ", KEY_MODS)
                # ----------------------------------------------------
                
                # Final cleanup of any lingering multiple spaces
                gsub(/ {2,}/, " ", KEY_MODS)


                # --- 4. Clean and Process FULL_ACTION ---
                
                # Remove "global" and "exec" tags (including the leading comma that started the split)
                gsub(/global[[:space:]]*/, "", FULL_ACTION)
                gsub(/exec[[:space:]]*/, "", FULL_ACTION)
                gsub(/^[[:space:]]*,[[:space:]]*/, "", FULL_ACTION)
                
                # Final cleanup of all extra spaces
                gsub(/  */, " ", FULL_ACTION)
                sub(/^ /, "", FULL_ACTION)
                sub(/ $/, "", FULL_ACTION)

                # Print the formatted line
                printf "%-28s | %s\n", KEY_MODS, FULL_ACTION
            }'
    ) | fuzzel \
        --dmenu \
        --prompt="HYPR KEYBINDS" \
        --width=60 \
        --lines=25 
        --config="$HOME/.config/fuzzel/fuzzel.ini"
}

show_keybinds
