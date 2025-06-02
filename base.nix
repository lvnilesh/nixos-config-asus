{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  myAppleFonts = pkgs.callPackage ./modules/apple-fonts.nix {};
in {
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
    ./modules/smb-mount.nix
    ./modules/nfs-mount.nix
    ./modules/keybase.nix
    # ./modules/pro-audio.nix
    ./modules/consumer-audio.nix
    ./modules/midi.nix
    ./modules/midi-rules.nix

    # (import "${home-manager}/nixos" )
  ];
  time.timeZone = "America/Los_Angeles";
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "hi_IN/UTF-8" "mr_IN/UTF-8" "kn_IN/UTF-8" "all"];
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

  # The login keyring did not get unlocked when you logged into the computer.
  # System-wide configuration
  services.gnome.gnome-keyring.enable = true;

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    libsecret
    seahorse # GUI for managing keys
    bluez
    bluez-tools
    blueman # Bluetooth manager with GUI
  ];

  # Enable PAM integration
  security.pam.services = {
    login.enableGnomeKeyring = true;
    # Add your display manager here
    gdm.enableGnomeKeyring = true; # For GDM
    # lightdm.enableGnomeKeyring = true; # For LightDM
    # sddm.enableGnomeKeyring = true;    # For SDDM
  };

  # Allow unfree packages if you haven't already
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "apple-fonts" # Add the pname from your derivation
      # ... other unfree packages ...
    ];

  fonts = {
    packages = with pkgs; [
      myAppleFonts # Add your custom font package
      jetbrains-mono
      # source-code-pro
      # roboto

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra # Contains many Indic scripts
      # Individual Lohit fonts for Indic scripts
      lohit-fonts.assamese
      lohit-fonts.bengali
      lohit-fonts.devanagari # For Hindi
      lohit-fonts.gujarati
      lohit-fonts.kannada
      lohit-fonts.malayalam
      lohit-fonts.marathi
      lohit-fonts.nepali
      lohit-fonts.odia
      # lohit-fonts.punjabi
      lohit-fonts.tamil
      lohit-fonts.telugu
      culmus # For some more exotic scripts
      google-fonts # Comprehensive collection including many Indic fonts
      liberation_ttf # For general coverage
    ];
    fontDir.enable = true;
    enableDefaultPackages = true;
  };

  boot.kernel.sysctl = {
    "net.ipv6.conf.all.disable_ipv6" = 1;
    "net.ipv6.conf.default.disable_ipv6" = 1;
    # Optionally, disable on loopback too, though often not strictly necessary
    # "net.ipv6.conf.lo.disable_ipv6" = 1;
  };

  boot = {
    kernelModules = ["tcp_bbr"];
    kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
      "net.core.wmem_max" = 1073741824;
      "net.core.rmem_max" = 1073741824;
      "net.ipv4.tcp_rmem" = "4096 87380 1073741824";
      "net.ipv4.tcp_wmem" = "4096 87380 1073741824";
    };
  };

  console = {
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    useXkbConfig = true;
  };

  # Configure Bluetooth audio if needed
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Enable = "Source,Sink,Media,Socket";
        # AutoConnect = true;
        FastConnectable = true;
        ControllerMode = "bredr";
        Experimental = true;
        JustWorksRepairing = true;
        # AutoEnable = true;
      };
      # # Find mac address using `bluetoothctl devices | grep -i "Trackpad"`
      # "4C:74:BF:F2:1F:9E" = {
      #   #  Big Trackpad
      #   AutoConnect = "true";
      #   Trusted = "true";
      #   ReconnectAttempts = "7";
      #   ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64";
      # };
      # "50:C2:75:77:68:48" = {
      #   # Jabra Evolve2 65
      #   AutoConnect = "true";
      #   Trusted = "true";
      #   ReconnectAttempts = "7";
      #   ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64";
      # };
      # "90:9C:4A:DA:DE:63" = {
      #   # Apple AirPods Max
      #   AutoConnect = "true";
      #   Trusted = "true";
      #   ReconnectAttempts = "7";
      #   ReconnectIntervals = "1, 2, 4, 8, 16, 32, 64";
      # };
    };
  };

  # Enable Bluetooth-related services
  services.blueman.enable = true;

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
    settings = {
      warn-dirty = false;
      auto-optimise-store = true;
    };
  };

  # Enable udev settings for yubikey personalization
  services.udev.packages = [pkgs.yubikey-personalization];
  services.pcscd.enable = true; # smart card daemon (pcscd) is essential for communicating with the YubiKey.
}
