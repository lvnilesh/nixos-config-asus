# Create a file named desktop-audio.nix
{
  config,
  pkgs,
  ...
}: {
  # Security limits for real-time audio
  security.pam.loginLimits = [
    # Allow real-time scheduling
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    # Allow memory locking
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
    # Allow nice priority
    {
      domain = "@audio";
      item = "nice";
      type = "-";
      value = "-19";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "99999";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "99999";
    }
  ];

  # Make sure your user is in the audio group
  users.users.cloudgenius = {
    # Other user settings...
    extraGroups = ["audio" "jackaudio"];
  };

  environment.etc."fluidsynth.conf".text = ''
    synth.default-soundfont=${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2
  '';

  environment.systemPackages = with pkgs; [
    # MIDI and audio basics
    jack2
    qjackctl
    alsa-utils

    # DAWs and software instruments
    ardour
    hydrogen
    guitarix
    zynaddsubfx

    # VST host and plugins
    carla

    # MIDI utilities
    a2jmidid # For connecting ALSA MIDI to JACK MIDI
    qmidiarp # MIDI arpeggiator to create patterns
    qmidinet # For network MIDI if needed
    pmidi # Simple MIDI player and recorder
    rtmidi # Real-time MIDI processing library
    # midi editing
    musescore
    rosegarden

    # audio analysis
    sonic-visualiser # For analyzing audio files
    # sonic-annotator # For annotating audio files

    aubio # For audio feature extraction
    python3Packages.aubio # Python interface if needed
    audacity # Audio editor with spectral analysis
    pulseaudioFull
    waon

    # Additional MIDI tools
    midicsv # Convert MIDI to CSV and back (useful for analyzing Dire Straits tracks)
    MIDIVisualizer # Helps visualize MIDI patterns (good for learning the song)

    fluidsynth
    soundfont-fluid # The correct package name
    freepats
    soundfont-ydp-grand
    soundfont-arachno # Optional - high quality
    soundfont-generaluser # Optional - high quality

    netcat-openbsd
    jack1
    jack-example-tools
  ];
}
