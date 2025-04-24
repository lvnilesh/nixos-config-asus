#! /bin/bash
# Script for adjusting display brightness and gamma
# This script assumes that you have two monitors connected via DP-0 and DP-4
# run `xrandr --verbose` or just `xrandr` to find the detail about the monitors you have connected.

# Ensure input is a valid number and convert it to a decimal
if [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 1 && $1 <= 10 )); then
  [ "$1" = 10 ] && percent="1" || percent="0.$1"
else
  echo "Usage: $0 <brightness level (1-10)> [night]"
  exit 1
fi

# Ensure brightness is never lower than 0.1
(( $(echo "$percent < 0.1" | bc -l) )) && percent="0.1"

# Adjust brightness
xrandr --output DP-4 --brightness "$percent"
xrandr --output DP-0 --brightness "$percent"

# Adjust gamma if "night" mode is passed
if [ "$2" = "night" ]; then
  xrandr --output DP-4 --brightness "$percent" --gamma 1.0:0.95:0.85
  xrandr --output DP-0 --brightness "$percent" --gamma 1.0:0.95:0.85
else
  xrandr --output DP-4 --brightness "$percent" --gamma 1.0:1.0:1.0
  xrandr --output DP-0 --brightness "$percent" --gamma 1.0:1.0:1.0
fi

# Display current settings
xrandr --verbose | grep -E "Brightness|Gamma" | tail -n2

# Optional fun message
[ "$1" != 10 ] && echo "Stayin' up late, huh? Or maybe just pretending to be a hacker?" | lolcat