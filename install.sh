#!/usr/bin/env bash

# --- Configuration ---
INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR_TODO="$HOME/.local/share/todo-fuzzel"
TODO_CACHE_FILE="$CONFIG_DIR_TODO/todo.cache"
SCRIPT_SOURCE_DIR="$(pwd)/scripts"

# Script names
KEYBINDS_SCRIPT="keybinds.sh"
SUPERGFX_SCRIPT="supergfxctl.sh"
TODO_SCRIPT="todo-fuzzel.sh"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# --- Helper Functions ---

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a single script
install_script() {
    local script_name="$1"
    local source_path="$SCRIPT_SOURCE_DIR/$script_name"
    local install_path="$INSTALL_DIR/$script_name"

    if [ -f "$source_path" ]; then
        echo -e "Installing ${YELLOW}$script_name${NC}..."
        cp "$source_path" "$install_path"
        chmod +x "$install_path"
        echo -e "${GREEN}✓ Installed $script_name to $install_path${NC}"
    else
        echo -e "${RED}✗ Source file for $script_name not found!${NC}"
    fi
}

# --- Installation Logic ---

install_keybinds() {
    if ! command_exists fuzzel; then
        echo -e "${RED}✗ Dependency 'fuzzel' is not installed. Aborting keybinds script installation.${NC}"
        return 1
    fi
    install_script "$KEYBINDS_SCRIPT"
}

install_supergfx() {
    if ! command_exists fuzzel || ! command_exists supergfxctl || ! command_exists notify-send; then
        echo -e "${RED}✗ A dependency (fuzzel, supergfxctl, or notify-send) is not installed. Aborting supergfxctl script installation.${NC}"
        return 1
    fi
    install_script "$SUPERGFX_SCRIPT"
}

install_todo() {
    if ! command_exists fuzzel; then
        echo -e "${RED}✗ Dependency 'fuzzel' is not installed. Aborting todo script installation.${NC}"
        return 1
    fi
    install_script "$TODO_SCRIPT"
    # Create config directory and cache file for the todo script
    if [ ! -d "$CONFIG_DIR_TODO" ]; then
        mkdir -p "$CONFIG_DIR_TODO"
        echo -e "  Created config directory: $CONFIG_DIR_TODO"
    fi
    if [ ! -f "$TODO_CACHE_FILE" ]; then
        touch "$TODO_CACHE_FILE"
        echo -e "  Created todo cache file: $TODO_CACHE_FILE"
    fi
}

# --- Main Menu ---

echo -e "${GREEN}--- Fuzzel Scripts Installer ---${NC}"
echo "This script will install the selected scripts to ${INSTALL_DIR}."
echo 

# Create install directory if it doesn't exist
mkdir -p "$INSTALL_DIR"

PS3="Please enter your choice: "
options=(
    "Install all scripts"
    "Install Keybinds script"
    "Install Supergfxctl script"
    "Install Todo script"
    "Quit"
)

select opt in "${options[@]}"; do
    case "$opt" in
        "Install all scripts")
            echo -e "\n${YELLOW}Installing all scripts...${NC}"
            install_keybinds
            install_supergfx
            install_todo
            break
            ;;
        "Install Keybinds script")
            install_keybinds
            break
            ;;
        "Install Supergfxctl script")
            install_supergfx
            break
            ;;
        "Install Todo script")
            install_todo
            break
            ;;
        "Quit")
            echo "Installation cancelled."
            break
            ;;
        *)
            echo "Invalid option $REPLY"
            ;;
    esac
done

echo -e "\n${GREEN}--- Installation Complete ---${NC}"
echo "To use the scripts, you can run them from the terminal or add them to your Hyprland config."
echo "See the README.md for example keybinds."
echo 
