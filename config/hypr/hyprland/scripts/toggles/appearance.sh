#!/usr/bin/env bash
set -euo pipefail

# Configuration
readonly HYPRSETTINGS="${HLC}/hyprsettings.conf"
readonly ALLOWED_VARS="border,opacity"

# Error handler
error_exit() {
    echo "Error: $1" >&2
    exit 1
}

# Usage information
usage() {
    echo "Usage: $0 {toggle|on|off} <variable_name>" >&2
    echo "Allowed variables: $ALLOWED_VARS" >&2
    exit 1
}

# Validate inputs
[[ $# -eq 2 ]] || usage

readonly ACTION="$1"
readonly VARIABLE="$2"

# Validate variable is allowed
IFS=',' read -ra allowed_arr <<< "$ALLOWED_VARS"
if ! printf '%s\n' "${allowed_arr[@]}" | grep -qx "$VARIABLE"; then
    error_exit "'$VARIABLE' is not allowed. Allowed variables: $ALLOWED_VARS"
fi

# Ensure config file exists
touch "$HYPRSETTINGS"

# Initialize variable in config if missing (with $ prefix)
if ! grep -q "^\$$VARIABLE =" "$HYPRSETTINGS"; then
    {
        echo "# Toggles $VARIABLE"
        echo "\$$VARIABLE ="
    } >> "$HYPRSETTINGS"
fi

# Get current value
get_value() {
    grep "^\$$VARIABLE =" "$HYPRSETTINGS" | sed 's/.*= *//' || echo ""
}

# Set value functions
set_on() {
    sed -i "s|^\$$VARIABLE =.*|\$$VARIABLE = 1|" "$HYPRSETTINGS"
}

set_off() {
    sed -i "s|^\$$VARIABLE =.*|\$$VARIABLE =|" "$HYPRSETTINGS"
}

# Main logic
current=$(get_value)

case "$ACTION" in
    toggle)
        [[ "$current" == "1" ]] && set_off || set_on
        ;;
    on)
        set_on
        ;;
    off)
        set_off
        ;;
    *)
        usage
        ;;
esac

# Output final status
final_value=$(get_value)
echo "✔️  \$$VARIABLE = ${final_value:-<empty>}"
