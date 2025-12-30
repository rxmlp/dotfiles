#!/usr/bin/env bash 
set -euo pipefail
trap 'echo "Error on line $LINENO: command \"$BASH_COMMAND\" failed"; exit 1' ERR

# Default mode is 'now'
MODE="now"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        now)
            MODE="now"
            shift
            ;;
        wait)
            MODE="wait"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Define the autostart config file path
AUTOSTART="$HOME/.config/autostart.conf"

# Create the directory if it doesn't exist
mkdir -p "$(dirname "$AUTOSTART")"

# Create an empty autostart config file if it doesn't exist
if [ ! -f "$AUTOSTART" ]; then
    touch "$AUTOSTART"
    echo "Created empty autostart config file: $AUTOSTART"
fi

# Wait for Waybar
if [[ "$MODE" == "wait" ]]; then
    TIMEOUT=10
    echo "Waiting for Waybar to start ($TIMEOUT s timeout)..."
    waited=0

    while ! pgrep -x "waybar" > /dev/null; do
        sleep 0.1
        waited=$((waited + 1))

        if [ $waited -ge $((TIMEOUT * 10)) ]; then
            echo "Timeout: Waybar not found after $TIMEOUT seconds, proceeding anyway..."
            break
        fi
    done

    if pgrep -x "waybar" > /dev/null; then
        echo "Waybar is running, proceeding with autostart..."
    fi
fi

# Wait for internet connection to avoid apps (eg browsers) complaining
nm-online -q

# Read each line from the autostart config file and execute it as a command
while IFS= read -r command; do
    # Skip empty lines and comments
    [[ -z "$command" || "$command" =~ ^[[:space:]]*# ]] && continue

    # Execute the command in the background, suppress all output, and disown it
    $command > /dev/null 2>&1 &
    disown
done < "$AUTOSTART"
