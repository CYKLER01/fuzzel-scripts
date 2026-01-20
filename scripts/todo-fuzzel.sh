#!/usr/bin/env sh

# --- Configuration ---
CONFIG_DIR="$HOME/.local/share/todo-fuzzel"
CACHE_FILE="$CONFIG_DIR/todo.cache"
TEMP_FILE="$CONFIG_DIR/todo.tmp"

# Ensure the configuration directory exists
mkdir -p "$CONFIG_DIR"
# Ensure the cache file exists
touch "$CACHE_FILE"

# --- Main Logic ---

# Read cache file contents
cache_contents="$(cat "$CACHE_FILE")"
# Get line count for fuzzel
cache_lines="$(echo "$cache_contents" | wc -l)"
[ -s "$CACHE_FILE" ] || cache_lines=0

# Get input from the user via fuzzel
selection="$(echo "$cache_contents" | fuzzel --dmenu -l "$cache_lines" 2>/dev/null)"

# Exit if no selection is made (e.g., user presses Esc)
[ -z "$selection" ] && exit 1

# If the selection already exists in the cache file, remove it.
# Otherwise, add it.
if grep -Fxq "$selection" "$CACHE_FILE"; then
    # Use grep -v to filter out the selected line and write to a temporary file
    grep -vFx "$selection" "$CACHE_FILE" > "$TEMP_FILE"
    # Overwrite the original cache file with the temporary file
    mv "$TEMP_FILE" "$CACHE_FILE"
else
    # Append the new selection to the cache file
    echo "$selection" >> "$CACHE_FILE"
fi
