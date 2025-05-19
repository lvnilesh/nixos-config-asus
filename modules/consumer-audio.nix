# Create a file named desktop-audio.nix
{
  config,
  pkgs,
  ...
}: {
  # for general use
  # boot.kernelParams = ["threadirqs"]; # Keep this but remove aggressive params

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
          default.clock.quantum = 1024; # Higher for desktop use
          default.clock.min-quantum = 32; # Higher minimum
          default.clock.max-quantum = 8192;
          core.daemon = true;
          core.name = "pipewire-0";
        };
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
