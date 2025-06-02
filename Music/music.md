# Test connection

aconnect -i

client 0: 'System' [type=kernel]
    0 'Timer           '
    1 'Announce        '
client 14: 'Midi Through' [type=kernel]
    0 'Midi Through Port-0'
client 36: 'USB MIDI Interface' [type=kernel,card=5]
    0 'USB MIDI Interface MIDI 1'

# Watch

aseqdump -p 36:0

lsusb | grep -i midi
Bus 001 Device 020: ID fc02:0101  USB MIDI Interface

udevadm info -a -p $(udevadm info -q path -n /dev/bus/usb/001/020)


# Start JACK audio server
jack_control start

# Bridge ALSA MIDI to JACK MIDI
a2jmidid -e 

# Alternatively, you can use QjackCtl for a graphical interface:

qjackctl

# find 

aconnect -l
client 0: 'System' [type=kernel]
    0 'Timer           '
	Connecting To: 142:0
    1 'Announce        '
	Connecting To: 142:0, 128:0
client 14: 'Midi Through' [type=kernel]
    0 'Midi Through Port-0'
	Connecting To: 143:0[real:0]
	Connected From: 24:0, 143:0[real:0]
client 24: 'USB MIDI Interface' [type=kernel,card=2]
    0 'USB MIDI Interface MIDI 1'
	Connecting To: 14:0, 143:0[real:0]
	Connected From: 143:0[real:0]
client 142: 'PipeWire-System' [type=user,pid=3483]
    0 'input           '
	Connected From: 0:1, 0:0
client 143: 'PipeWire-RT-Event' [type=user,pid=3483]
    0 'input           '
	Connecting To: 14:0[real:0], 24:0[real:0]
	Connected From: 14:0[real:0], 24:0[real:0]
# dump 

❯ aseqdump -p 24:0
Waiting for data. Press Ctrl+C to end.
Source  Event                  Ch  Data
  0:1   Port subscribed            143:0 -> 129:0
 24:0   Note on                 0, note 50, velocity 100
 24:0   Note off                0, note 50
 24:0   Note on                 0, note 50, velocity 75
 24:0   Note off                0, note 50
 24:0   Note on                 0, note 50, velocity 75
 24:0   Note off                0, note 50
 24:0   Note on                 0, note 52, velocity 75
 24:0   Note off                0, note 52
 24:0   Note on                 0, note 52, velocity 75
 24:0   Note off                0, note 52

lsof -i :8888

systemctl --user stop resilio-sync

# First, let's start Guitarix:
guitarix -p 8888 &

# Then find its MIDI client number:

aconnect -l | grep -i guitarix



######

aconnect -l
client 0: 'System' [type=kernel]
    0 'Timer           '
	Connecting To: 142:0
    1 'Announce        '
	Connecting To: 142:0
client 14: 'Midi Through' [type=kernel]
    0 'Midi Through Port-0'
	Connected From: 24:0
client 24: 'USB MIDI Interface' [type=kernel,card=2]
    0 'USB MIDI Interface MIDI 1'
	Connecting To: 14:0
client 128: 'FLUID Synth (49643)' [type=user,pid=49643]
    0 'Synth input port (49643:0)'
client 142: 'PipeWire-System' [type=user,pid=3483]
    0 'input           '
	Connected From: 0:1, 0:0
client 143: 'PipeWire-RT-Event' [type=user,pid=3483]
    0 'input        


### 
# Format: aconnect [MIDI_KEYBOARD_CLIENT]:[PORT] [FLUIDSYNTH_CLIENT]:[PORT]
# Example:
aconnect 24:0 128:0


fluidsynth -v -a jack -m alsa_seq /nix/store/l7hyxnq23j3ms1w0mqpf4vjkfj66mqn8-Fluid-3/share/soundfonts/FluidR3_GM2-2.sf2
FluidSynth runtime version 2.4.3
Copyright (C) 2000-2025 Peter Hanappe and others.
Distributed under the LGPL license.
SoundFont(R) is a registered trademark of Creative Technology Ltd.

fluidsynth: debug: SF Version: 2.2
fluidsynth: debug: ftell(): 298, fread(): 148156408 bytes
fluidsynth: debug: Sample 'High Q(R)': loop range '58906912 - 58910210' after sample end '58908468', using it anyway
fluidsynth: prog		0	0	0
fluidsynth: prog		1	0	0
fluidsynth: prog		2	0	0
fluidsynth: prog		3	0	0
fluidsynth: prog		4	0	0
fluidsynth: prog		5	0	0
fluidsynth: prog		6	0	0
fluidsynth: prog		7	0	0
fluidsynth: prog		8	0	0
fluidsynth: prog		9	128	0
fluidsynth: prog		10	0	0
fluidsynth: prog		11	0	0
fluidsynth: prog		12	0	0
fluidsynth: prog		13	0	0
fluidsynth: prog		14	0	0
fluidsynth: prog		15	0	0
fluidsynth: debug: Using 'alsa_seq' midi driver
fluidsynth: debug: Using 'jack' audio driver
fluidsynth: debug: Jack engine sample rate: 48000
fluidsynth: Jack sample rate mismatch, adjusting. (synth.sample-rate=44100, jackd=48000)
Type 'help' for help topics.