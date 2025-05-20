# Create a file named desktop-audio.nix
{
  config,
  pkgs,
  ...
}: {
  # for general use
  # boot.kernelParams = ["threadirqs"]; # Keep this but remove aggressive params

  # Environment variables for Guitarix
  environment.variables = {
    GUITARIX_TUNER_WARNINGS = "0"; # Disable tuner warnings
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Balanced desktop configuration
    extraConfig.pipewire = {
      "99-desktop-audio.conf" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 1024; # Higher for desktop use or 256
          default.clock.min-quantum = 32; # Higher minimum
          default.clock.max-quantum = 8192;
          core.daemon = true;
          core.name = "pipewire-0";
          core.realtime = true;
        };
      };

      # Media session configuration
      media-session.config.alsa-monitor = {
        rules = [
          {
            matches = [{"node.name" = "~alsa_input.*";}];
            actions = {
              update-props = {
                "node.nick" = "Microphone";
                "priority.driver" = 100;
                "priority.session" = 100;
              };
            };
          }
          {
            matches = [{"node.name" = "~alsa_output.*";}];
            actions = {
              update-props = {
                "node.nick" = "Speakers";
                "priority.driver" = 100;
                "priority.session" = 100;
              };
            };
          }
        ];
      };

      # Client-specific settings for better CPU usage
      "client.conf" = {
        stream.properties = {
          node.latency = "0.021333"; # 1024/48000
          resample.quality = 3; # Balance between quality and CPU
        };
      };
    };
  };
}
