#!/usr/bin/env zsh

# --- Configuration ---
# The name of your MIDI output device. This should match what 'amidi -l' or 'aconnect -o' shows.
DEVICE_NAME="USB MIDI Interface"

# --- Script Logic ---

# Check for aplaymidi
if ! command -v aplaymidi &> /dev/null
then
    echo "Error: 'aplaymidi' command not found." >&2
    echo "Please install 'alsa-utils' (e.g., 'sudo apt install alsa-utils' on Debian/Ubuntu/Fedora/Arch)." >&2
    exit 1
fi

echo "Looking for MIDI output device: '$DEVICE_NAME'..."

# First, try to find the client:port ID using aconnect
CLIENT_ID=$(aconnect -o -l | grep -A 1 "$DEVICE_NAME" | grep 'client' | awk '{print $2}' | sed 's/:$//')
MIDI_OUTPUT_PORT=""

if [ -n "$CLIENT_ID" ]; then
    # Assuming the first port (usually 0) of the client
    MIDI_OUTPUT_PORT="${CLIENT_ID}:0"
else
    # Fallback: If aconnect didn't find a client ID, try parsing amidi -l for hw:X,Y,Z
    MIDI_OUTPUT_PORT=$(amidi -l | grep "$DEVICE_NAME" | head -n 1 | awk '{print $2}')
fi

if [ -z "$MIDI_OUTPUT_PORT" ]; then
    echo "Error: MIDI output device '$DEVICE_NAME' not found." >&2
    echo "Please ensure your MIDI keyboard is connected and powered on." >&2
    echo "Run 'amidi -l' or 'aconnect -o' to see available devices and verify the name." >&2
    exit 1
fi

# Determine the MIDI file to play
MIDI_FILE="$1" # Try to use the first argument if provided

# If no argument was provided, find the most recently created MIDI file by the recorder
if [ -z "$MIDI_FILE" ]; then
    DEFAULT_MIDI_FILE=$(ls -t "$HOME"/recorded_midi_*.mid 2>/dev/null | head -n 1)
    if [ -z "$DEFAULT_MIDI_FILE" ]; then
        echo "Error: No recorded MIDI files found in '$HOME' matching 'recorded_midi_*.mid'." >&2
        echo "Please provide a valid path to a MIDI file or record one first." >&2
        exit 1
    fi
    MIDI_FILE="$DEFAULT_MIDI_FILE"
fi

# Check for MIDI file
if [ ! -f "$MIDI_FILE" ]; then
    echo "Error: MIDI file '$MIDI_FILE' not found." >&2
    echo "Please provide a valid path to a MIDI file or ensure the default exists." >&2
    exit 1
fi

echo "Found MIDI output device '$DEVICE_NAME' at port: $MIDI_OUTPUT_PORT"
echo "Playing MIDI file '$MIDI_FILE' on '$DEVICE_NAME'..."

# Play the MIDI file to the device
aplaymidi -p "$MIDI_OUTPUT_PORT" "$MIDI_FILE"

if [ $? -eq 0 ]; then
    echo "MIDI playback to device complete."
else
    echo "MIDI playback to device failed or was interrupted." >&2
fi