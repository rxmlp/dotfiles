#!/usr/bin/env sh

# Function to get the last login time
get_last_login_time() {
    last_login=$(lastlog -u $USER | awk '{print $5,$6}')
    echo $last_login
}

# Function to get the last update time for a package
get_last_update_time() {
    package=$1
    log_entry=$(grep -i "$package" /var/log/pacman.log | tail -1)
    if [[ -n $log_entry ]]; then
        date_string=$(echo $log_entry | cut -d']' -f1 | cut -c2-)
        last_update=$(date -d "$date_string" +%s)
        echo $last_update
    else
        echo ""
    fi
}

# Get the last login time
last_login_time=$(get_last_login_time)
day=$(echo $last_login_time | cut -d' ' -f1)
time=$(echo $last_login_time | cut -d' ' -f2)

# Convert last login time to seconds since epoch
last_login_time_seconds=$(date -d "$(date +%Y-%m-%d) - $day days $time" +%s)

# Get the last update time for hyprland-git
package="hyprland-git"
last_update_time=$(get_last_update_time $package)

# Check if the package was upgraded in the last session
if [[ -n $last_update_time ]]; then
    if [[ $last_update_time -gt $last_login_time_seconds ]]; then
        hyprpm update
    else
        exit
    fi
fi