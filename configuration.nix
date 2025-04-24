# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./base.nix
   ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

#  nix.gc = {
#    automatic = true;
#    options = "--delete-older-than 7d";
#  };

  nix.settings.substituters = ["https://cache.nixos.org/"];
  nix.settings.trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];

  # Tablet
  hardware.opentabletdriver = {
    enable = true;
    daemon.enable = true;
  };

  services.pulseaudio.enable = false; 
  security.rtkit.enable = true;
  services = {
    openssh.enable = true;
    flatpak.enable = true;
    printing.enable = true;    
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;      
      pulse.enable = true;
    };
  };

  # services.libinput.enable = true;   # Enable touchpad support (enabled default in most desktopManager).

  # for global user
  users.defaultUserShell=pkgs.zsh; 

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cloudgenius = {
    initialPassword = "cdcd";
    description = "Nilesh";
    isNormalUser = true;
    extraGroups = [ 

      "wheel" # Enable ‘sudo’ for the user. 
      "networkmanager"
      "docker"
      "libvirtd"
      "audio"
      "video"
      "input"
    ];
    
    shell = pkgs.zsh;

    packages = with pkgs; [
      tree
      zsh
    ];
  };

  # enable zsh and oh my zsh
  programs = {
    virt-manager.enable = true;
#    firefox.enable = true;
    zsh = {
        enable = true;
        autosuggestions.enable = true;
        zsh-autoenv.enable = true;
        syntaxHighlighting.enable = true;
        ohMyZsh = {
          enable = true;
          theme = "robbyrussell";
          plugins = [
            "git"
            "npm"
            "history"
            "node"
            "rust"
            "deno"
            "sudo"
            "terraform"
            "systemadmin"
            "vi-mode"           
          ];
        };
    };
  };

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
    # "sp5100_tco" # Example for AMD SP5100 TCO
    # Add the module specific to your hardware
  ];

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

