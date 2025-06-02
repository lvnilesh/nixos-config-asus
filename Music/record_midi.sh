#!/usr/bin/env zsh
# Description: This script records MIDI input from a specified device and saves it to a file.
# Usage: ./record_midi.sh [output_file.mid]
# --- Configuration ---
# The name of your MIDI input device. This should match what 'amidi -l' or 'aconnect -i' shows.
DEVICE_NAME="USB MIDI Interface"

# Default output MIDI file path. Can be overridden by the first argument.
DEFAULT_OUTPUT_FILE="$HOME/recorded_midi_$(date +%Y%m%d_%H%M%S).mid"
MIDI_OUTPUT_FILE="${1:-$DEFAULT_OUTPUT_FILE}" # Use argument if provided, else default

# --- Script Logic ---

# Check for arecordmidi
if ! command -v arecordmidi &> /dev/null
then
    echo "Error: 'arecordmidi' command not found." >&2
    echo "Please install 'alsa-utils' (e.g., 'sudo apt install alsa-utils' on Debian/Ubuntu/Fedora/Arch)." >&2
    exit 1
fi

echo "Looking for MIDI input device: '$DEVICE_NAME'..."

# First, try to find the client:port ID using aconnect
# This is often more robust than parsing hw:X,Y,Z
CLIENT_ID=$(aconnect -i -l | grep -A 1 "$DEVICE_NAME" | grep 'client' | awk '{print $2}' | sed 's/:$//')
MIDI_INPUT_PORT=""

if [ -n "$CLIENT_ID" ]; then
    # Assuming the first port (usually 0) of the client
    MIDI_INPUT_PORT="${CLIENT_ID}:0"
else
    # Fallback: If aconnect didn't find a client ID, try parsing amidi -l for hw:X,Y,Z
    MIDI_INPUT_PORT=$(amidi -l | grep "$DEVICE_NAME" | head -n 1 | awk '{print $2}')
fi

if [ -z "$MIDI_INPUT_PORT" ]; then
    echo "Error: MIDI input device '$DEVICE_NAME' not found." >&2
    echo "Please ensure your MIDI keyboard is connected and powered on." >&2
    echo "Run 'amidi -l' or 'aconnect -i' to see available devices and verify the name." >&2
    exit 1
fi

echo "Found MIDI input device '$DEVICE_NAME' at port: $MIDI_INPUT_PORT"
echo "Recording to: $MIDI_OUTPUT_FILE"
echo "Press Ctrl+C to stop recording."

# Start recording
arecordmidi -p "$MIDI_INPUT_PORT" "$MIDI_OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "MIDI recording saved to '$MIDI_OUTPUT_FILE'."
else
    echo "MIDI recording failed or was interrupted." >&2
fi