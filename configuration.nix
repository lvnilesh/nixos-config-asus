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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "asus"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  time.timeZone = "America/LosAngeles";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Optional: Auto-run garbage collection to save disk space
#  nix.gc = {
#    automatic = true;
#    options = "--delete-older-than 7d";
#  };

  nix.settings.substituters = ["https://cache.nixos.org/"];
  nix.settings.trusted-public-keys = ["cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="];



	fonts.packages = with pkgs; [
		jetbrains-mono
	];

  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "cloudgenius";

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb.layout = "us";
    # xkb.options = "eurosign:e,caps:escape";
  };

  services = {
    openssh.enable = true;
    flatpak.enable = true;
    printing.enable = true;
    # libinput.enable = true;   # Enable touchpad support
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    # NixOS automatically selects the correct OpenGL implementation (NVIDIA's)
    # when services.xserver.videoDrivers includes "nvidia".
  };

  # Configure NVIDIA specific settings
  hardware.nvidia = {
    modesetting.enable = true;          # Modesetting is needed for modern displays and Wayland / smoother Xorg.
    package = config.boot.kernelPackages.nvidiaPackages.production;     # Use the NVIDIA proprietary driver
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    open = false;                       # Optional: Open source kernel module (alternative, usually lower performance/features)
    nvidiaSettings = true;              # Optional: Enable NVIDIA settings persistence daemon
    powerManagement.enable = true;      # Optional: Enable power management (suspend/resume features)
    nvidiaPersistenced = true;
  };

  # Docker Configuration
  virtualisation.docker = {
    enable = true;    
    enableNvidia = true;
    # NVIDIA Container Runtime in docker- KEEP THIS FOR NOW. https://github.com/NixOS/nixpkgs/issues/363505
  };

  hardware.nvidia-container-toolkit.enable = true;
  
  # Despite that, GPU support in containers wont work without # virtualisation.docker.enableNvidia = true;
  # docker run --rm --runtime=nvidia --device nvidia.com/gpu=all ubuntu nvidia-smi
  # docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

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
      "video"
      "audio"
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

    firefox.enable = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };    
  
    virt-manager.enable = true;

  };

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [
    vim
    curl
    git
    wget
  ];

  # Virt manager

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  networking = {
    interfaces = {
      eno1.useDHCP = true;
      br0.useDHCP = true;
    };
    bridges = {
      "br0" = {
        interfaces = [ "eno1" ];
      };
    };
  };


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;







hardware.interception-tools = {
    enable = true;
    udevmonConfig = ''
      - JOB: intercept -g $DEVNODE | /run/interception/mouse-to-super | uinput -d /dev/uinput
        DEVICE:
          PROPERTIES: '*ID_VENDOR_ID*=="046d", *ID_MODEL_ID*=="c548"'
    '';
    plugins = [
      (pkgs.writeShellScriptBin "mouse-to-super" ''
        #!${pkgs.runtimeShell}
        ${pkgs.gawk}/bin/awk '
          BEGIN {
            # !!! VERIFY THIS code using evtest for your specific mouse !!!
            TARGET_BUTTON_CODE = 277; # <--- ADJUST THIS CODE!

            KEY_LEFTMETA = 125;   # Super key
            fflush()
          }
          $1 == 1 && $2 == TARGET_BUTTON_CODE && $3 == 1 {
            print "1 " KEY_LEFTMETA " 1"; # Super Press
            print "0 0 0"; # Sync
            fflush();
            next;
          }
          $1 == 1 && $2 == TARGET_BUTTON_CODE && $3 == 0 {
            print "1 " KEY_LEFTMETA " 0"; # Super Release
            print "0 0 0"; # Sync
            fflush();
            next;
          }
          { print $0; fflush(); }
        '
      '')
    ];
  };

  # Optional: Ensure your user is in the 'input' group if you ever need
  # to run tools like evtest directly without sudo (might not be needed for this setup).
  # users.users.cloudgenius.extraGroups = [ "input" ];




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
  system.stateVersion = "24.05"; # Changed from "24.11" # Did you read the comment?

}

