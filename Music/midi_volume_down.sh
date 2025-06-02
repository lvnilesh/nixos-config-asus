#!/usr/bin/env zsh

# --- Configuration ---
# MIDI message for Control Change 7 (Main Volume) to value 0 (zero)
# B0 = Control Change on Channel 1 (B1 for Ch2, etc. - usually 1 is fine for global messages)
# 07 = Control Change Number for Main Volume (CC7)
# 00 = Value 0 (minimum volume)
VOLUME_DOWN_MESSAGE="B0 07 00"

# The specific name of your MIDI device as it appears in 'amidi -l' or 'aconnect -o'
# We're using "USB MIDI Interface" as per your example.
DEVICE_NAME="USB MIDI Interface"

# --- Script Logic ---

# Check if amidi is installed
if ! command -v amidi &> /dev/null
then
    echo "Error: 'amidi' command not found." >&2
    echo "Please install 'alsa-utils' (e.g., 'sudo apt install alsa-utils' on Debian/Ubuntu)." >&2
    exit 1
fi

echo "Detecting MIDI device named '$DEVICE_NAME'..."

# Use amidi -l to find the hardware port (hw:X,Y,Z) for the specified device name
# This greps for the device name, takes the first matching line, and extracts the second field (the port ID)
MIDI_PORT=$(amidi -l | grep "$DEVICE_NAME" | head -n 1 | awk '{print $2}')

# Check if a port was found
if [ -z "$MIDI_PORT" ]; then
    echo "Error: MIDI device '$DEVICE_NAME' not found." >&2
    echo "Please ensure your MIDI keyboard is connected and powered on." >&2
    echo "Run 'amidi -l' to see available devices and verify the name." >&2
    exit 1
fi

echo "Found MIDI device '$DEVICE_NAME' at port: $MIDI_PORT"
echo "Sending MIDI message '$VOLUME_DOWN_MESSAGE' to port '$MIDI_PORT'..."

# Send the MIDI message
amidi -p "$MIDI_PORT" -S "$VOLUME_DOWN_MESSAGE"

if [ $? -eq 0 ]; then
    echo "Successfully sent MIDI volume down command to '$DEVICE_NAME'."
else
    echo "Failed to send MIDI volume down command to '$DEVICE_NAME'." >&2
    echo "Check MIDI_PORT ($MIDI_PORT) and device connections." >&2
fi