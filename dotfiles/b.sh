#!/etc/profiles/per-user/cloudgenius/bin/zsh

# --- Configuration ---
# Define step size for brightness change (e.g., 0.1 for 10%)
step=0.1
# Define minimum brightness (xrandr brightness can't be exactly 0)
min_brightness=0.1
# Define maximum brightness
max_brightness=1.0
# --- End Configuration ---

# Function to get the brightness of the first connected display reporting it
get_current_brightness() {
  xrandr --verbose | grep -A 5 ' connected' | grep -m 1 -i brightness | awk '{print $2}'
}

# Get current brightness level
current_brightness=$(get_current_brightness)

# Handle case where brightness might not be found (e.g., initial state or error)
# Or if the monitor doesn't report brightness via xrandr --verbose this way.
# We assume 1.0 as a default if we can't read it.
if [ -z "$current_brightness" ]; then
    echo "Warning: Could not determine current brightness from xrandr --verbose. Assuming ${max_brightness}."
    current_brightness=${max_brightness}
fi

# Adjust brightness based on argument
if [ "$1" = "up" ]; then
  # Use awk for floating point arithmetic
  new_brightness=$(awk -v current="$current_brightness" -v step="$step" 'BEGIN { print current + step }')
elif [ "$1" = "down" ]; then
  # Use awk for floating point arithmetic
  new_brightness=$(awk -v current="$current_brightness" -v step="$step" 'BEGIN { print current - step }')
else
  # Use basename for cleaner usage message independent of script path
  echo "Usage: $(basename "$0") up|down"
  exit 1
fi

# Ensure brightness stays within the defined range using awk for comparison
if awk -v nb="$new_brightness" -v minb="$min_brightness" 'BEGIN { exit !(nb < minb) }'; then
  new_brightness="$min_brightness"
elif awk -v nb="$new_brightness" -v maxb="$max_brightness" 'BEGIN { exit !(nb > maxb) }'; then
  new_brightness="$max_brightness"
fi

# Find all connected outputs using xrandr --query
# Grep for lines containing ' connected ' (with spaces to be more specific)
# Awk prints the first field ($1), which is the output name (e.g., DP-0, eDP-1)
connected_outputs=$(xrandr --query | grep ' connected ' | awk '{print $1}')

# Check if any connected outputs were found
if [ -z "$connected_outputs" ]; then
    echo "Error: No connected outputs found by xrandr."
    exit 1
fi

echo "Setting brightness to: $new_brightness"
echo "Applying to connected outputs:"

# Loop through each connected output and apply the new brightness
echo "$connected_outputs" | while IFS= read -r output_name; do
    echo " - $output_name"
    xrandr --output "$output_name" --brightness "$new_brightness"
done

echo "Brightness adjustment complete."