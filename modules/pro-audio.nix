# Professional audio setup
{
  config,
  pkgs,
  ...
}: let
  wireplumberConfig = import ./wireplumber-config.nix {inherit pkgs;};
in {
  # Real-time kernel optimization
  boot.kernelPackages = pkgs.linuxPackages-rt;
  boot.kernelParams = ["threadirqs" "preempt=full" "processor.max_cstate=1" "idle=poll"];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "fs.inotify.max_user_watches" = 524288;
  };

  # Add user to audio group
  users.users.cloudgenius.extraGroups = ["audio"];

  # PipeWire with professional settings (updated)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber = {
      enable = true;
      configPackages = [wireplumberConfig];
    };

    # PipeWire configuration
    extraConfig.pipewire = {
      "99-good-audio.conf" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 256; # Lower for less latency
          default.clock.min-quantum = 16; # Allow very low latency
          default.clock.max-quantum = 1024; # Still allow higher values if needed
          core.daemon = true;
          core.name = "pipewire-0";
        };
      };

      # Client-specific optimizations
      "client.conf" = {
        stream.properties = {
          node.latency = "0.005333"; # 256/48000
          resample.quality = 5; # Higher quality resampling
        };
      };
    };
  };

  # Install professional audio packages
  environment.systemPackages = with pkgs; [
    # Core audio applications
    ardour
    audacity
    # reaper     # If you have it packaged
    # bitwig-studio # Uncomment if you have it properly packaged

    qtractor

    # Audio utilities
    pipewire # Core PipeWire package
    pipewire.jack # JACK support for PipeWire
    # pwtools # For pw-jack and other PipeWire tools
    pavucontrol # PulseAudio volume control (works with PipeWire)
    jack2 # JACK tools
    qjackctl # JACK control GUI
    # cadence # Another useful audio control panel
    carla # Plugin host
    zita-njbridge
    a2jmidid
    jack_capture

    # Audio monitoring and routing
    helvum # PipeWire patchbay (modern alternative to qjackctl)
    pavucontrol # Volume control
    patchage # Connection manager

    # Effects and processing
    easyeffects # Audio effects for PipeWire

    # Professional plugins
    calf
    lsp-plugins
    zam-plugins
    # distrho
    x42-plugins
    zrythm

    # Additional utilities
    jack_capture # Record audio
    zita-njbridge # Network audio
    ffmpeg # Audio conversion
    sox # Sound processin

    # Additional audio tools that are definitely in nixpkgs
    fluidsynth
    hydrogen
    guitarix
  ];

  # Enable realtime kit for audio
  security.rtkit.enable = true;

  # Memory locking for audio applications
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
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
    # For real-time priority
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nice";
      type = "-";
      value = "-19";
    }
  ];

  # Allow unfree packages (needed for some commercial audio software)
  nixpkgs.config.allowUnfree = true;
}
