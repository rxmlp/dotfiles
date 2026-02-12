#!/bin/bash

# Read RGB values from /tmp/papirus-folders
COLOR_FILE="/tmp/papirus-folders"

if [ ! -f "$COLOR_FILE" ]; then
    echo "Error: Color file not found: $COLOR_FILE"
    exit 1
fi

# Read RGB values (format: "R G B")
read r g b < "$COLOR_FILE"

if [ -z "$r" ] || [ -z "$g" ] || [ -z "$b" ]; then
    echo "Error: Could not parse RGB values from $COLOR_FILE"
    exit 1
fi

echo "RGB: ($r, $g, $b)"

# Find which channel is max
max_val=$r
max_channel="r"
if [ $g -gt $max_val ]; then
    max_val=$g
    max_channel="g"
fi
if [ $b -gt $max_val ]; then
    max_val=$b
    max_channel="b"
fi

# Find min
min_val=$r
if [ $g -lt $min_val ]; then
    min_val=$g
fi
if [ $b -lt $min_val ]; then
    min_val=$b
fi

delta=$((max_val - min_val))

# Calculate hue based on which channel is max (using integer math scaled by 1000)
if [ $delta -eq 0 ]; then
    hue=0
elif [ "$max_channel" = "r" ]; then
    # Hue = 60 * ((g - b) / delta)
    hue=$(( (60 * 1000 * (g - b)) / delta / 1000 ))
elif [ "$max_channel" = "g" ]; then
    # Hue = 60 * (((b - r) / delta) + 2)
    hue=$(( (60 * 1000 * (b - r)) / delta / 1000 + 120 ))
else  # blue
    # Hue = 60 * (((r - g) / delta) + 4)
    hue=$(( (60 * 1000 * (r - g)) / delta / 1000 + 240 ))
fi

# Normalize to 0-360
while [ $hue -lt 0 ]; do
    hue=$((hue + 360))
done
while [ $hue -ge 360 ]; do
    hue=$((hue - 360))
done

# Calculate saturation (scaled to percentage)
if [ $max_val -eq 0 ]; then
    saturation=0
else
    saturation=$(( (delta * 100) / max_val ))
fi

# Calculate lightness (scaled to percentage)
lightness=$(( ((max_val + min_val) * 100) / 510 ))

echo "Hue: $hue°"
echo "Saturation: $saturation%"
echo "Lightness: $lightness%"

# Map hue to Papirus color
# Handle greyscale first (saturation < 15%)
if [ $saturation -lt 15 ]; then
    if [ $lightness -lt 25 ]; then
        COLOR="black"
    elif [ $lightness -gt 75 ]; then
        COLOR="white"
    else
        COLOR="grey"
    fi
else
    # Color mapping based on hue ranges
    if [ $hue -ge 345 ] || [ $hue -lt 15 ]; then
        COLOR="red"
    elif [ $hue -ge 15 ] && [ $hue -lt 35 ]; then
        COLOR="deeporange"
    elif [ $hue -ge 35 ] && [ $hue -lt 50 ]; then
        COLOR="orange"
    elif [ $hue -ge 50 ] && [ $hue -lt 70 ]; then
        COLOR="yellow"
    elif [ $hue -ge 70 ] && [ $hue -lt 150 ]; then
        COLOR="green"
    elif [ $hue -ge 150 ] && [ $hue -lt 170 ]; then
        COLOR="teal"
    elif [ $hue -ge 170 ] && [ $hue -lt 200 ]; then
        COLOR="cyan"
    elif [ $hue -ge 200 ] && [ $hue -lt 240 ]; then
        COLOR="blue"
    elif [ $hue -ge 240 ] && [ $hue -lt 270 ]; then
        COLOR="indigo"
    elif [ $hue -ge 270 ] && [ $hue -lt 300 ]; then
        COLOR="violet"
    elif [ $hue -ge 300 ] && [ $hue -lt 330 ]; then
        COLOR="magenta"
    else  # 330-345
        COLOR="pink"
    fi
fi

echo "Selected Papirus color: $COLOR"
echo ""
echo "Applying color..."
papirus-folders -C "$COLOR"

echo "Done! Folder icons updated to $COLOR"
