#!/run/current-system/sw/bin/zsh
# Log everything to file
exec > /tmp/monitor-check.log 2>&1

echo "=== Monitor check script running at $(date) ==="

# Ensure DISPLAY is set
export DISPLAY=:0
export XAUTHORITY=/home/cloudgenius/.Xauthority

# Define monitor variables
MONITOR_ATEM="HDMI-1"  # 4K monitor (HDMI)
MONITOR_RETINA="DP-4"    # 5K monitor (DisplayPort)
MONITOR_HUION="DP-2"  # 1080p monitor (DisplayPort)

# Create a cache file to store previous monitor state
CACHE_FILE="/tmp/monitor-state.cache"
CURRENT_STATE=$(xrandr | grep " connected " | sort)

# Check if cache file exists and compare states
if [ -f "$CACHE_FILE" ]; then
    PREVIOUS_STATE=$(cat "$CACHE_FILE")
    
    # If state hasn't changed, exit early
    if [ "$CURRENT_STATE" = "$PREVIOUS_STATE" ]; then
        echo "No monitor configuration change detected, exiting."
        exit 0
    fi
    
    echo "Monitor configuration change detected!"
    echo "Previous: $PREVIOUS_STATE"
    echo "Current: $CURRENT_STATE"
else
    echo "No previous state found, assuming first run."
fi

# Save current state to cache
echo "$CURRENT_STATE" > "$CACHE_FILE"

# Reset monitor configuration
xrandr --output $MONITOR_ATEM --off
xrandr --output $MONITOR_RETINA --off
xrandr --output $MONITOR_HUION --off

# Set up the 1080p monitor
xrandr --output $MONITOR_HUION --auto 

# Mirror the 4K monitor to the 1080p monitor
xrandr --output $MONITOR_ATEM --auto --same-as $MONITOR_HUION --scale 1x1

# Check if DP-4 is connected
DP4_CONNECTED=$(echo "$CURRENT_STATE" | grep "$MONITOR_RETINA connected" | wc -l)
echo "DP-4 connected status: $DP4_CONNECTED"

# If DP-4 is connected, set it up to the right
if [ "$DP4_CONNECTED" -eq "1" ]; then
    echo "DP-4 is connected, positioning it to the right"
    xrandr --output $MONITOR_RETINA --auto --right-of $MONITOR_HUION --primary
    
    # Try to find DP-4 bus for DDC control
    DP4_BUS=$(ddcutil detect | grep -B 1 "card1-DP-3" | grep "I2C bus" | awk '{print $3}' | cut -d'-' -f2)
    if [ ! -z "$DP4_BUS" ]; then
        echo "Setting DP-4 brightness to 100% using DDC (bus $DP4_BUS)"
        ddcutil --bus=$DP4_BUS setvcp 10 100
    else
        echo "DP-4 DDC bus not found, using software brightness adjustment"
        # Use software brightness adjustment as fallback
        xrandr --output $MONITOR_RETINA --brightness 1.2
    fi
else
    echo "DP-4 is not connected, making HUION primary"
    xrandr --output $MONITOR_HUION --primary
fi

# Set wallpaper using GNOME settings if available
WALLPAPER_PATH="/home/cloudgenius/nixos-config/wall/eog-wallpaper.png"
if [ -f "$WALLPAPER_PATH" ] && command -v gsettings &> /dev/null; then
    WALLPAPER_URI="file://$WALLPAPER_PATH"
    gsettings set org.gnome.desktop.background picture-uri "$WALLPAPER_URI"
    gsettings set org.gnome.desktop.background picture-uri-dark "$WALLPAPER_URI"
    gsettings set org.gnome.desktop.background picture-options 'zoom'
    gsettings set org.gnome.desktop.screensaver picture-uri "$WALLPAPER_URI"
    gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
    echo "Wallpaper set using GNOME settings"
fi

echo "Monitor layout configured successfully"
exit 0