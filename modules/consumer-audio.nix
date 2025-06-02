# Create a file named desktop-audio.nix
{
  config,
  pkgs,
  ...
}: let
  wireplumberConfig = import ./wireplumber-config.nix {inherit pkgs;};
in {
  boot.kernelParams = [
    "threadirqs"
    "btusb.enable_autosuspend=0"
    "usbcore.autosuspend=-1"
  ];

  # Environment variables for Guitarix
  environment.variables = {
    GUITARIX_TUNER_WARNINGS = "0"; # Disable tuner warnings
  };

  # Add user to audio group
  users.users.cloudgenius.extraGroups = ["audio"];

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

    # Balanced desktop configuration
    extraConfig.pipewire = {
      "99-good-audio.conf" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 4096; # Higher for desktop use or 256
          default.clock.min-quantum = 32; # Higher minimum
          default.clock.max-quantum = 8192;
          core.daemon = true;
          core.name = "pipewire-0";
          core.realtime = true;
        };

        bluez5 = {
          # "codecs" = ["aac"];
          "codecs" = ["aac" "sbc"];
          # "codecs" = ["aac" "aptx" "aptx_hd" "ldac" "sbc" "mp3" "opus" "flac" "vorbis" "pcm"];

          "profile" = "a2dp-sink";
          "battery-provider" = true;
        };
      };

      # # Media session configuration
      # media-session.config.alsa-monitor = {
      #   rules = [
      #     {
      #       matches = [{"node.name" = "~alsa_input.*";}];
      #       actions = {
      #         update-props = {
      #           "node.nick" = "Microphone";
      #           "priority.driver" = 100;
      #           "priority.session" = 100;
      #         };
      #       };
      #     }
      #     {
      #       matches = [{"node.name" = "~alsa_output.*";}];
      #       actions = {
      #         update-props = {
      #           "node.nick" = "Speakers";
      #           "priority.driver" = 100;
      #           "priority.session" = 100;
      #         };
      #       };
      #     }
      #   ];
      # };

      # Client-specific settings for better CPU usage
      "client.conf" = {
        stream.properties = {
          node.latency = "0.021333"; # 1024/48000
          resample.quality = 3; # Balance between quality and CPU
        };
      };
    };
  };

  # Install professional audio packages
  environment.systemPackages = with pkgs; [
    pkgs.fdk_aac
    fdk_aac
    pavucontrol
    helvum
    qpwgraph
    # Add more audio tools as needed
  ];

  # This line MUST be present and at the top level of your configuration.nix
  nixpkgs.config.allowUnfree = true;

  boot.kernel.sysctl = {
    "kernel.bluetooth.disable_idle_timer" = 1;
    # "usbcore.autosuspend" = -1; # Only if your Bluetooth adapter is USB and causing issues
  };

  # bluetoothctl list
  # Controller 7C:F1:7E:FA:D1:D5 asus #2 # tplink [default]
  # Controller 70:D8:23:B0:40:13 asus # internal

  # boot.blacklistedKernelModules = [
  #   "btintel" # this will disable the Intel Bluetooth module
  # ];
}
