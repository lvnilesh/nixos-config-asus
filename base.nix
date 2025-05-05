{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/apps.nix
    ./modules/opensnitch.nix
    ./modules/firefox.nix
    ./modules/slack.nix
    ./modules/gnome.nix
    ./modules/nvidia.nix
    ./modules/docker.nix
    ./modules/tailscale.nix
    ./modules/cpu-power.nix
    ./modules/ssh.nix
    ./modules/virt.nix
    ./modules/vscode-remote.nix
    ./modules/monitors.nix
    ./modules/autorandr.nix
    ./modules/i2c-dev.nix
    # (import "${home-manager}/nixos" )
  ];

  time.timeZone = "America/LosAngeles";
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
  ];

  # Leave bluetooth off on boot, the user can enable if needed
  hardware.bluetooth.powerOnBoot = false;

  # Enable auto-upgrades.
  system.autoUpgrade = {
    enable = true;
    # Run daily
    dates = "daily";
    # Build the new config and make it the default, but don't switch yet.  This will be picked up on reboot.  This helps
    # prevent issues with OpenSnitch configs not well matching the state of the system.
    operation = "boot";
  };

  # Limit nix rebuilds priority.  When left on the default is uses all available reouses which can make the system unusable
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  # Enable udev settings for yubikey personalization
  services.udev.packages = [pkgs.yubikey-personalization];
}
