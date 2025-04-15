# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asus"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/LosAngeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };


  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optional: Auto-run garbage collection to save disk space
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # Ensure Flakes can access the registry correctly
  nix.settings.substituters = ["https://cache.nixos.org/"];
  nix.settings.trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];

  # Optional: Enable nix-direnv integration if you use direnv
  # programs.direnv.enable = true;
  # programs.direnv.nix-direnv.enable = true;



  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  # Configure Hardware OpenGL and Vulkan to use NVIDIA
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # NixOS automatically selects the correct OpenGL implementation (NVIDIA's)
    # when services.xserver.videoDrivers includes "nvidia".
  };


  # Configure NVIDIA specific settings
  hardware.nvidia = {
    # Modesetting is needed for modern displays and Wayland / smoother Xorg.
    modesetting.enable = true;

    # Use the NVIDIA proprietary driver (the default is usually suitable).
    # 'production' selects the latest stable official driver.
    package = config.boot.kernelPackages.nvidiaPackages.production;

    # Optional: Enable power management (suspend/resume features)
    powerManagement.enable = true;

    # Optional: Open source kernel module (alternative, usually lower performance/features)
    # Use EITHER 'package' OR 'open', not both. 'package' is recommended for 1080 Ti.
    # open = true;

    # Optional: Enable NVIDIA settings persistence daemon
    nvidiaSettings = true;
  };


  # --- Docker Configuration ---
  virtualisation.docker = {
    enable = true;
    
    # Enable support for the NVIDIA Container Runtime -> GPU access
    enableNvidia = true; # KEEP THIS FOR NOW.

    # Optional: Specify Docker package if needed, otherwise uses default
    # package = pkgs.docker;
  };

  # --- NVIDIA Container Toolkit Configuration (Updated based on warnings) ---
  # This is the NEW way to enable GPU support in containers
  hardware.nvidia-container-toolkit.enable = true;
  
  # Despite that, GPU support in containers wont work without # virtualisation.docker.enableNvidia = true;
  # docker run --rm --runtime=nvidia --device nvidia.com/gpu=all ubuntu nvidia-smi
  # docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

 # Enable Flatpak service
  services.flatpak.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cloudgenius = {
    initialPassword = "cdcd";
    description = "Nilesh";
    isNormalUser = true;
    extraGroups = [ 
      "wheel" # Enable ‘sudo’ for the user 
      "networkmanager"
      "docker"
    ]; 
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      zsh
    ];
  };

  programs = {
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "sudo"
          "terraform"
          "systemadmin"
          "vi-mode"
        ];
      };
    };
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    curl
    git
    wget
    gnome-tweaks
    btop
    htop
    flatpak
    gnome-software
    glxinfo      # Useful for checking OpenGL rendering (part of mesa-utils)
    cudatoolkit
    opentofu
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "24.11"; # Did you read the comment?

}

