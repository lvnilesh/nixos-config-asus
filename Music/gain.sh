#!/usr/bin/env zsh

# Check if command is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <fluidsynth_command>"
  echo "Examples:"
  echo "  $0 'prog 0 30'  # Set channel 0 to distortion guitar"
  echo "  $0 'gain 4.0'   # Set volume to 4.0"
  echo "  $0 'channels'   # Show channel instruments"
  exit 1
fi

# Create a temporary file for telnet input
TELNET_INPUT=$(mktemp)
echo "$1" > $TELNET_INPUT

# Use telnet with the command file and timeout to avoid hanging
( sleep 1; cat $TELNET_INPUT; sleep 0.5; echo -e "\035"; sleep 0.5; echo "quit" ) | telnet localhost 9800 > /dev/null 2>&1

# Clean up
rm -f $TELNET_INPUT

echo "Command '$1' sent to FluidSynth successfully."