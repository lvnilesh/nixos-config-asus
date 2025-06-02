# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./base.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelParams = [
  #   "video=DP-1:5120x2880@60"
  # ];

  networking.hostName = "asus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nix.settings.substituters = ["https://cache.nixos.org/"];
  nix.settings.trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];

  # Tablet
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  security.polkit.enable = true;

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false; # set false and use keys instead!
        PermitRootLogin = "no"; # say no to this.
      };
    };
    flatpak.enable = true;
    printing.enable = true;
  };

  services.fwupd.enable = true;
  # sudo systemctl status fwupd.service
  # fwupdmgr get-updates
  # fwupdmgr refresh
  # fwupdmgr update

  services.libinput.enable = true; # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.touchpad = {
    naturalScrolling = true;
    tapping = true;
    disableWhileTyping = true;
  };

  # Enable the touchegg service
  services.touchegg.enable = true;
  #
  # touchegg --debug
  # xev # to get the keycode

  # sudo systemctl restart touchegg.service
  # sudo systemctl enable touchegg.service
  # sudo systemctl start touchegg.service
  # sudo systemctl status touchegg.service
  #
  # flatpak install flathub com.github.joseexposito.touche

  # for global user
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cloudgenius = {
    initialPassword = "cdcd";
    description = "Nilesh";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEWM/PQ1EF0spec86grdfOaT0/G92oV2KxPHPSe4fTp7"
    ];
    shell = pkgs.zsh;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "docker"
      "libvirtd"
      "audio"
      "video"
      "input"
      "kvm"
      "libvirt"
    ];
    packages = with pkgs; [
      tree
      zsh
      touchegg # Install touchegg for gesture support
      xdotool
      # Test manually
      # xdotool key alt+Left
      # xdotool key alt+Right
      # xdotool key alt+Shift+Left
      # xdotool key alt+Shift+Right
      # xdotool key alt+Shift+Up
      # xdotool key alt+Shift+Down
      # xdotool key alt+Shift+Page_Up
      # xdotool key alt+Shift+Page_Down
    ];
  };

  programs.zsh.enable = true;
  programs.virt-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    git
    wget
  ];

  # Examine the previous boot's journal: After rebooting (even if it was slow), check the logs from the end of the previous shutdown sequence.
  # journalctl -b -1 -e
  # Systemd has tools to analyze boot and shutdown times, although shutdown analysis is trickier.
  # systemd-analyze blame: While primarily for boot, sometimes long-running startup services can cause shutdown issues. Run it to see if any services take an exceptionally long time to start.
  # systemd-analyze blame

  # Ensure hardware module is loaded if needed, e.g.:
  boot.kernelModules = [
    "iTCO_wdt" # Example for Intel TCO watchdog
    "coretemp"
    "it87"
    # "sp5100_tco" # Example for AMD SP5100 TCO
    # Add the module specific to your hardware
  ];

  hardware.cpu = {
    intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
