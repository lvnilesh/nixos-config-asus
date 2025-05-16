{
  config,
  pkgs,
  inputs,
  ...
}: let
  myAppleFonts = pkgs.callPackage ./modules/apple-fonts.nix {};
in {
  imports = [
    ./vitals.nix
    ./packages
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cloudgenius";
  home.stateVersion = "24.11"; # Set to your current NixOS/HM version

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif = ["New York" "Noto Serif" "Lohit"];
      sansSerif = ["SF Pro" "Noto Sans" "Lohit"];
      monospace = ["SF Mono" "Noto Sans Mono"];
    };
  };

  xdg.enable = true;

  # set cursor size and dpi for 27 inch 5k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 218; # 172 for 4k;
  };

  home.packages =
    (with pkgs.gnomeExtensions; [
      appindicator
      blur-my-shell
      caffeine
      dash-to-dock
      tiling-shell
      vitals

      # tactile
      # paperwm
      # forge
      # gsconnect
      # quick-settings-tweaker
    ])
    ++ (with pkgs; [
      myAppleFonts
      htop
      vlc
      unzip
      bat
      neofetch
      fastfetch
      albert
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.kubectl
      ])
      azure-cli
      awscli2
      # notify

      libgtop
      # Add the .dev output for header files needed for compilation
      libgtop.dev
      dunst # notify-send
      mako # notify-send
      libnotify # notify-send
      glib # notify-send

      # Packages that should be installed to the user profile.
      neofetch
      nnn # terminal file manager

      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      yq-go # yaml processor https://github.com/mikefarah/yq
      eza # A modern replacement for ‘ls’
      fzf # A command-line fuzzy finder
      # Terminal utilities
      fd
      tldr

      # Development tools
      git
      gh
      vscode

      meslo-lgs-nf # Standalone package
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code

      # networking tools
      nmap
      mtr # A network diagnostic tool
      iperf3
      dnsutils # `dig` + `nslookup`
      ldns # replacement of `dig`, it provide the command `drill`
      aria2 # A lightweight multi-protocol & multi-source command-line download utility
      socat # replacement of openbsd-netcat
      nmap # A utility for network discovery and security auditing
      ipcalc # it is a calculator for the IPv4/v6 addresses

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd

      # nix related
      #
      # it provides the command `nom` works just like `nix`
      # with more details log output
      nix-output-monitor

      # productivity
      glow # markdown previewer in terminal

      btop # replacement of htop/nmon
      iotop # io monitoring
      iftop # network monitoring

      # system call monitoring
      strace # system call monitoring
      ltrace # library call monitoring
      lsof # list open files

      # busybox # this messes up grep # a single binary that provides several stripped-down Unix tools in a single executable

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ]);

  systemd.user.services.albert = {
    Unit = {
      Description = "Albert Launcher";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.albert}/bin/albert";
      Restart = "on-failure";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };

  systemd.user.services.opentabletdriver = {
    Unit = {
      Description = "opentabletdriver daemon launcher";
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.opentabletdriver}/bin/otd-daemon";
      Restart = "on-failure";
    };
    Install = {WantedBy = ["graphical-session.target"];};
  };

  # The login keyring did not get unlocked when you logged into the computer.

  # Enable gnome-keyring in Home Manager
  services.gnome-keyring = {
    enable = true;
    components = ["pkcs11" "secrets" "ssh"];
  };

  # https://github.com/NixOS/nixpkgs/issues/318274
  # systemctl list-units --user --all
  # cd ~/.config/systemd/user
  # systemctl --user status opentabletdriver.service
  # systemctl --user status graphical-session.target

  # Terminal file manager
  programs.lf = {
    enable = true;
    settings = {
      previewer = "${pkgs.ctpv}/bin/ctpv";
    };
  };
  programs.home-manager.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-BL";
      package = pkgs.tokyo-night-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    font = {
      name = "SF Pro"; # "SF Pro Display"; # fc-list | grep "New York"
      package = myAppleFonts;
      size = 11;
    };
    # font = {
    #   name = "Source Code Pro";
    #   package = pkgs.source-code-pro;
    #   size = 11;
    # };
    # font = {
    #   name = "Noto Sans";
    #   package = pkgs.noto-fonts;
    #   size = 11;
    # };
    # font = {
    #   name = "Roboto";
    #   package = pkgs.roboto-font;
    #   size = 11;
    # };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-theme-name = "Tokyonight-Dark-BL";
      icon-theme-name = "Papirus-Dark";
      cursor-theme-name = "Bibata-Modern-Ice";
      cursor-size = 24;
      gtk-font-name = "SF Pro Display 11";
      gtk-xft-dpi = 218000;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-theme-name = "Tokyonight-Dark-BL";
      icon-theme-name = "Papirus-Dark";
      cursor-theme-name = "Bibata-Modern-Ice";
      cursor-size = 24;
      gtk-font-name = "SF Pro Display 11";
      gtk-xft-dpi = 218000;
    };
  };
  # Enable user services (e.g., syncthing)
  # services.syncthing.enable = true;
}
