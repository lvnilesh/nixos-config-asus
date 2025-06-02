#!/usr/bin/env zsh

echo "========================================"
echo "Sultans of Swing MIDI Guitar Setup"
echo "========================================"

# Kill any existing FluidSynth
echo "Stopping any existing FluidSynth instances..."
pkill fluidsynth 2>/dev/null

# Find the soundfont
echo "Locating soundfont..."
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

# Create temporary scripts
FLUID_SCRIPT=$(mktemp)
echo "#!/usr/bin/env zsh" > $FLUID_SCRIPT
echo "echo 'FluidSynth Console - Starting...'" >> $FLUID_SCRIPT
echo "echo 'This window shows FluidSynth output and accepts commands'" >> $FLUID_SCRIPT
echo "echo '------------------------------------------------------'" >> $FLUID_SCRIPT
echo "exec fluidsynth -v -s -a jack -j -m alsa_seq -g 3.0 -r 48000 '$SF'" >> $FLUID_SCRIPT
chmod +x $FLUID_SCRIPT

MIDI_SCRIPT=$(mktemp)
echo "#!/usr/bin/env zsh" > $MIDI_SCRIPT
echo "echo 'MIDI Monitor - Starting...'" >> $MIDI_SCRIPT
echo "echo 'This window shows MIDI events from your keyboard'" >> $MIDI_SCRIPT
echo "echo '------------------------------------------------------'" >> $MIDI_SCRIPT
echo "sleep 3" >> $MIDI_SCRIPT
echo "MIDI=\$(aconnect -l | grep 'USB MIDI Interface' | grep -oP 'client \K[0-9]+')" >> $MIDI_SCRIPT
echo "echo 'Monitoring MIDI input from client '\$MIDI" >> $MIDI_SCRIPT
echo "if [ -n \"\$MIDI\" ]; then" >> $MIDI_SCRIPT
echo "  exec aseqdump -p \$MIDI:0" >> $MIDI_SCRIPT
echo "else" >> $MIDI_SCRIPT
echo "  echo 'Error: MIDI device not found'" >> $MIDI_SCRIPT
echo "  sleep 30" >> $MIDI_SCRIPT
echo "fi" >> $MIDI_SCRIPT
chmod +x $MIDI_SCRIPT

# Set MIDI Volume level down to ZERO
echo "Setting MIDI volume level to zero..."
# This is necessary to avoid hearing piano sounds
# when starting FluidSynth
sh $HOME/nixos-config/Music/midi_volume_down.sh 

# Set Fluidsynth gain level to 1.0 
echo "Setting FluidSynth gain level to 1.0..."
sh $HOME/nixos-config/Music/gain.sh 'gain 1.0'   # Set volume to 1.0

# Start FluidSynth in a separate Alacritty window
echo "Starting FluidSynth in a new terminal..."
# alacritty -t "FluidSynth Console" -e $FLUID_SCRIPT &
zellij action new-pane --direction right --name "FluidSynth Console" -- bash -c "$FLUID_SCRIPT" &
FLUID_TERM_PID=$!

# Wait for FluidSynth to initialize
echo "Waiting for FluidSynth to initialize..."
sleep 5

# Get client numbers
echo "Finding MIDI connections..."
FLUID=$(aconnect -l | grep -i fluid | grep -oP 'client \K[0-9]+')
MIDI=$(aconnect -l | grep 'USB MIDI Interface' | grep -oP 'client \K[0-9]+')

if [ -z "$FLUID" ]; then
    echo "Error: FluidSynth not found. Make sure it started correctly in the new terminal."
    rm -f $FLUID_SCRIPT $MIDI_SCRIPT
    exit 1
fi

echo "FluidSynth client: $FLUID"
echo "MIDI keyboard client: $MIDI"

# Start MIDI monitor in a separate Alacritty window
echo "Starting MIDI monitor in a new terminal..."
# alacritty -t "MIDI Monitor" -e $MIDI_SCRIPT &
zellij action new-pane --direction down --name "MIDI Monitor" -- bash -c "$MIDI_SCRIPT" &
MIDI_TERM_PID=$!

if [ -n "$FLUID" ] && [ -n "$MIDI" ]; then
    echo "Connecting MIDI keyboard to FluidSynth..."
    aconnect $MIDI:0 $FLUID:0
    
    # Force guitar sound
    sh $HOME/nixos-config/Music/gain.sh "prog 0 30"
    sleep 1    
    # echo "Setting up Overdriven Guitar sound..."
    # for i in {1..3}; do
    #     echo "prog 0 30" | nc -u -w 1 localhost 9800
    #     sleep 0.2
    # done
    
    # Add reverb and effects for Mark Knopfler tone
    echo "Adding reverb and effects..."
    echo "gain 2.5" | nc -u -w 1 localhost 9800
    echo "rev_setroomsize 0.6" | nc -u -w 1 localhost 9800
    echo "rev_setlevel 0.3" | nc -u -w 1 localhost 9800
    
    echo "========================================"
    echo "Setup complete! You can now play Sultans of Swing."
    echo ""
    echo "Monitoring windows have been opened:"
    echo "- FluidSynth Console: Shows audio engine and accepts commands"
    echo "- MIDI Monitor: Shows raw MIDI data from your keyboard"
    echo ""
    echo "If you still hear piano instead of guitar sounds,"
    echo "type 'prog 0 30' directly in the FluidSynth Console window"
    echo ""
    echo "Playing Tips:"
    echo "- Sultans of Swing is in D minor"
    echo "- Main scale: D minor pentatonic (D, F, G, A, C)"
    echo "- Main riff: D, F, G, A, G, F, D"
    echo "- Use pitch bend for Mark Knopfler's signature bends"
    echo ""
    echo "Try these commands in the FluidSynth Console window to switch sounds:"
    echo "  prog 0 28  (Electric Guitar - Clean)"
    echo "  prog 0 30  (Overdriven Guitar - Sultans of Swing style)"
    echo "  prog 0 31  (Distortion Guitar - for heavier parts)"
    echo "  prog 0 25  (Acoustic Guitar - Steel)"
    echo ""
    echo "This script will keep running to maintain the terminal windows."
    echo "Press Ctrl+C to quit when finished (will close all windows)"

    # Set MIDI Volume level down to ZERO
    echo "Setting MIDI volume level to zero..."
    # This is necessary to avoid hearing piano sounds
    # when starting FluidSynth
    sh $HOME/nixos-config/Music/midi_volume_down.sh 

    # Keep script running until user quits
    trap "pkill -P $$; rm -f $FLUID_SCRIPT $MIDI_SCRIPT; exit 0" INT TERM EXIT
    while true; do
        sleep 1
    done
else
    echo "Error: Could not find FluidSynth or MIDI clients."
    echo "Please check your connections and try again."
    rm -f $FLUID_SCRIPT $MIDI_SCRIPT
    exit 1
fi