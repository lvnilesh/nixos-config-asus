# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./apps.nix
      # (import "${home-manager}/nixos" )
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asus"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/LosAngeles";

  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

#  nix.gc = {
#    automatic = true;
#    options = "--delete-older-than 7d";
#  };

  nix.settings.substituters = ["https://cache.nixos.org/"];
  nix.settings.trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    xkb.layout = "us";
    displayManager = {
      gdm.enable = true;
      sessionCommands = ''
			  xwallpaper --zoom /home/cloudgenius/nixos-config/wall/eog-wallpaper.png
			  xset r rate 200 35 &
		  '';
      # autoLogin.enable = true;
      # autoLogin.user = "cloudgenius";
    };
    desktopManager.gnome = {
      enable = true;  
    };
  };

  services.gnome.gnome-initial-setup.enable = false;

	fonts.packages = with pkgs; [
		jetbrains-mono
	];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Replaces driSupport32Bit concept
    extraPackages = [ ];
    extraPackages32 = [ ];
  };

#  hardware.opengl = {
#    enable = true;
#    driSupport = true; 
#    driSupport32Bit = true;
#  };

  hardware.nvidia = {
    modesetting.enable = true;
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    package = config.boot.kernelPackages.nvidiaPackages.stable; 
    open = false;
    powerManagement.enable = true;     # Optional: Enable power management (suspend/resume features)
    nvidiaSettings = true;     # Optional: Enable NVIDIA settings persistence daemon
  };

  virtualisation.docker = {
    enable = true;
    enableNvidia = true; 
    # Enable support for the NVIDIA Container Runtime -> GPU access
    # KEEP THIS FOR NOW. https://github.com/NixOS/nixpkgs/issues/363505
  };

  hardware.nvidia-container-toolkit.enable = true;
  # Despite that, GPU support in containers wont work without # virtualisation.docker.enableNvidia = true;
  # docker run --rm --runtime=nvidia --device nvidia.com/gpu=all ubuntu nvidia-smi
  # docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

  services.pulseaudio.enable = false; 

  services = {
    openssh.enable = true;
    flatpak.enable = true;
    printing.enable = true;    
    pipewire = {
      enable = true;
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
    firefox.enable = true;
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

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };
  
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.br0.useDHCP = true;
  networking.bridges = {
    "br0" = {
      interfaces = [ "eno1" ];
    };
  };


  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
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

