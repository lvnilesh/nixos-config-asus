#!/usr/bin/env bash
# File: brightness-control.sh
# Description: Controls monitor brightness via DDC with 5% increments

# The I2C bus for your ASUS monitor
# You can find the bus number using `ddcutil detect`
# or `ddcutil capabilities` command

# ddcutil detect | grep -B 1 "card1-DP-3" | grep "I2C bus" | awk '{print $3}' | cut -d'-' -f2
# ddcutil detect | grep -B 1 "card0-DP-2" | grep "I2C bus" | awk '{print $3}' | cut -d'-' -f2
# ddcutil --bus=17 getvcp 10
# ddcutil --bus=17 setvcp 10 37

BUS=17

# Function to get current brightness
get_current_brightness() {
    # Extract current brightness value from ddcutil output
    local current_value=$(ddcutil --bus=$BUS getvcp 10 | grep -oP 'current value = *\K[0-9]+')
    echo "$current_value"
}

# Ensure ddcutil is available
if ! command -v ddcutil &> /dev/null; then
    echo "Error: ddcutil not found. Please install it first."
    exit 1
fi

# Check if the monitor is accessible
if ! ddcutil --bus=$BUS capabilities &> /dev/null; then
    echo "Error: Cannot communicate with monitor on bus $BUS."
    exit 1
fi

# Get the action from command line argument
ACTION=$1
CURRENT=$(get_current_brightness)

# Default step size
STEP=5

# Handle different actions
case "$ACTION" in
    up)
        # Increase brightness by step size
        NEW_VALUE=$(( CURRENT + STEP ))
        # Cap at 100
        if [ "$NEW_VALUE" -gt 100 ]; then
            NEW_VALUE=100
        fi
        ;;
    down)
        # Decrease brightness by step size
        NEW_VALUE=$(( CURRENT - STEP ))
        # Floor at 0
        if [ "$NEW_VALUE" -lt 0 ]; then
            NEW_VALUE=0
        fi
        ;;
    set)
        # Set absolute brightness value
        if [ -n "$2" ] && [ "$2" -ge 0 ] && [ "$2" -le 100 ]; then
            NEW_VALUE=$2
        else
            echo "Error: Invalid brightness value. Use a number between 0 and 100."
            exit 1
        fi
        ;;
    get)
        # Just print current brightness
        echo "Current brightness: $CURRENT"
        exit 0
        ;;
    *)
        echo "Usage: $0 [up|down|set VALUE|get]"
        echo "  up     - Increase brightness by 5%"
        echo "  down   - Decrease brightness by 5%"
        echo "  set N  - Set brightness to N% (0-100)"
        echo "  get    - Display current brightness"
        exit 1
        ;;
esac

# Apply the new brightness value
ddcutil --bus=$BUS setvcp 10 $NEW_VALUE

# Print confirmation
echo "Brightness set to $NEW_VALUE%"