#!/bin/bash

# Get current brightness level
current_brightness=$(xrandr --verbose | grep -m 1 -i brightness | awk '{print $2}')

# Define step size for brightness change
step=0.1

# Adjust brightness based on argument
if [ "$1" = "up" ]; then
  new_brightness=$(echo "$current_brightness + $step" | bc)
elif [ "$1" = "down" ]; then
  new_brightness=$(echo "$current_brightness - $step" | bc)
else
  echo "Usage: $0 up|down"
  exit 1
fi

# Ensure brightness stays within 0.1 to 1.0 range
if (( $(echo "$new_brightness < 0.1" | bc -l) )); then
  new_brightness=0.1
elif (( $(echo "$new_brightness > 1.0" | bc -l) )); then
  new_brightness=1.0
fi

# Apply new brightness value
xrandr --output DP-4 --brightness "$new_brightness"
xrandr --output DP-0 --brightness "$new_brightness"

# Optional: Display new brightness
echo "Brightness set to: $new_brightness"