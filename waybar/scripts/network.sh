#!/bin/bash

# List of common terminal emulators
TERMINALS=(alacritty kitty foot wezterm st lxterminal xfce4-terminal urxvt xterm)

# Find the first terminal that exists
for term in "${TERMINALS[@]}"; do
    if command -v "$term" >/dev/null 2>&1; then
        TERMINAL="$term"
        break
    fi
done

# Function to launch nmtui in a terminal
run_nmtui() {
    if [ -n "$TERMINAL" ]; then
        "$TERMINAL" -e nmtui &
    else
        # No terminal found; fallback to just running nmtui (might fail on Wayland)
        nmtui &
    fi
}

# Try common network manager GUI commands
if command -v nm-connection-editor >/dev/null 2>&1; then
    nm-connection-editor &
elif command -v plasma-nm >/dev/null 2>&1; then
    plasma-nm &
elif command -v networkmanager-dmenu >/dev/null 2>&1; then
    networkmanager-dmenu &
elif command -v nmtui >/dev/null 2>&1; then
    run_nmtui
else
    notify-send "Network Manager" "No network manager GUI found!"
fi
