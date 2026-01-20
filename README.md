# Fuzzel Scripts for Hyprland

A collection of useful Fuzzel-based scripts for Hyprland users. This collection includes a keybinding-cheatsheet, a `supergfxctl` mode switcher, and a simple todo-list manager.

## Features

*   **Keybind Viewer**: A script to parse your Hyprland keybinds configuration and display it in a searchable Fuzzel menu.
*   **Supergfxctl Switcher**: A Fuzzel menu to easily switch between `supergfxctl` power modes (e.g., Integrated, Hybrid, dGPU) and prompts for a reboot.
*   **Todo List**: A simple and fast Fuzzel-based todo list. Add items by typing, and remove them by selecting them.

## Dependencies

Before you install, make sure you have the following dependencies installed:

*   **fuzzel**: The launcher that all these scripts are based on.
*   **Hyprland**: The window manager (for the keybinds script).
*   **supergfxctl**: (Optional) Only required for the `supergfxctl` switcher.
*   **notify-send**: For sending desktop notifications.

## Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/fuzzel-scripts.git
    cd fuzzel-scripts
    ```

2.  **Run the installation script:**
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
    The script will ask you which scripts you want to install.

## Usage

After installation, you can run the scripts from your terminal. For the best experience, add them to your `hyprland.conf` with keybindings.

### Keybind Viewer (`keybinds.sh`)

This script will display your Hyprland keybindings in a Fuzzel menu.

**Configuration:**

The script will look for your keybindings file at `~/.config/hypr/hyprland/keybinds.conf`.

### Supergfxctl Switcher (`supergfxctl.sh`)

This script will show a Fuzzel menu to switch your GPU mode.

**Dependencies:** `supergfxctl`, `fuzzel`, `notify-send`

### Todo List (`todo-fuzzel.sh`)

A Fuzzel-based todo list.

*   Type a new task and press Enter to add it.
*   Select an existing task and press Enter to remove it.

**Configuration:**

The todo list is stored in `~/.local/share/todo-fuzzel/todo.cache`.

## Hyprland Keybinds

To launch these scripts with keybindings, add the following to your `hyprland.conf`:

```conf
# Fuzzel Scripts
bind = SUPER, T, exec, ~/.local/bin/todo-fuzzel.sh
bind = SUPER, G, exec, ~/.local/bin/supergfxctl.sh
bind = SUPER_CTRL, K, exec, ~/.local/bin/keybinds.sh
```

## Uninstallation

To remove the scripts and configuration files, run the `uninstall.sh` script from within the project directory:

```bash
./uninstall.sh
```

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
