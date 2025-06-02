#!/usr/bin/env zsh
# Description: This script plays a MIDI file to a specified MIDI output device.
# Usage: ./play_midi_computer.sh [midi_file.mid]    
# If no argument is provided, it defaults to a recent recorded MIDI file in the home directory.

#!/bin/bash

# --- Configuration ---
# Path to your soundfont file
SF="/nix/store/19vz6pj86lblarzcvh9qrb6z6i80bmkb-Fluid-3/share/soundfonts/FluidR3_GM2-2.sf2"
if [ ! -f "$SF" ]; then
    echo "Error: Soundfont not found at $SF"
    echo "Searching for alternative soundfonts..."
    SF=$(find /nix/store -name "*.sf2" -print -quit)
    if [ -z "$SF" ]; then
        echo "Error: No soundfont found. Please install a soundfont package."
        exit 1
    fi
fi
echo "Using soundfont: $SF"

# Audio output device (e.g., 'hw:0', 'default', 'pulse')
# Use 'aplay -l' to find your audio devices
AUDIO_DEVICE="default" # <--- ADJUST IF NEEDED (e.g., "hw:0" for first sound card)

# --- Script Logic ---

# Check for fluidsynth
if ! command -v fluidsynth &> /dev/null
then
    echo "Error: 'fluidsynth' command not found." >&2
    echo "Please install 'fluidsynth'." >&2
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

# Check for soundfont
if [ ! -f "$SF" ]; then
    echo "Error: Soundfont '$SF' not found." >&2
    echo "Please provide a valid path to a soundfont file." >&2
    exit 1
fi

# Check for MIDI file
if [ ! -f "$MIDI_FILE" ]; then
    echo "Error: MIDI file '$MIDI_FILE' not found." >&2
    echo "Please provide a valid path to a MIDI file or ensure the default exists." >&2
    exit 1
fi

echo "Playing MIDI file '$MIDI_FILE' on computer speakers via FluidSynth..."
echo "Using soundfont: $SF"

# Play the MIDI file
fluidsynth -a alsa -o audio.alsa.device="$AUDIO_DEVICE" "$SF" "$MIDI_FILE"

if [ $? -eq 0 ]; then
    echo "MIDI playback complete."
else
    echo "MIDI playback failed or was interrupted." >&2
fi