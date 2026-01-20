#!/usr/bin/env bash

# --- Configuration ---
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR_TODO="$HOME/.local/share/todo-fuzzel"

# Script names
KEYBINDS_SCRIPT="keybinds.sh"
SUPERGFX_SCRIPT="supergfxctl.sh"
TODO_SCRIPT="todo-fuzzel.sh"

# Colors for output
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Uninstallation Logic ---

echo -e "${YELLOW}--- Fuzzel Scripts Uninstaller ---${NC}"

remove_script() {
    local script_path="$INSTALL_DIR/$1"
    if [ -f "$script_path" ]; then
        rm -v "$script_path"
    else
        echo "Script not found: $script_path"
    fi
}

# Remove the scripts
remove_script "$KEYBINDS_SCRIPT"
remove_script "$SUPERGFX_SCRIPT"
remove_script "$TODO_SCRIPT"

# Remove the todo list's config directory
if [ -d "$CONFIG_DIR_TODO" ]; then
    read -p "Do you want to delete the todo list data at $CONFIG_DIR_TODO? [y/N] " -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rfv "$CONFIG_DIR_TODO"
        echo "Removed todo list data."
    else
        echo "Skipped removal of todo list data."
    fi
fi

echo -e "\n${YELLOW}--- Uninstallation Complete ---${NC}"
echo "Remember to remove the keybinds from your Hyprland configuration."
echo
