{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./vitals.nix
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cloudgenius";
  home.stateVersion = "24.11"; # Set to your current NixOS/HM version
  fonts.fontconfig.enable = true;
  xdg.enable = true;

  # set cursor size and dpi for 27 inch 5k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 218; # 172 for 4k;
  };

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "tactile@lundal.io"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "pop-shell@system76.com"
        "forge@jmmaranan.com"
        "Vitals@CoreCoding.com"
        "gsconnect@andyholmes.github.io"
        "quick-settings-tweaks@qwreey"
        "appindicatorsupport@rgcjonas.gmail.com"
        "paperwm@paperwm.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "datemenu-formatter@marcinjakubowski.github.com"
        "openweather-extension@jenslody.de"
        "just-perfection-desktop@just-perfection"
        "blur-my-shell@aunetx"
        "space-bar@luchrioh"
        "undecorate@sun.wxg@gmail.com"
        "tophat@fflewddur.github.io"
        "AlphabeticalAppGrid@stuarthayhurst"
      ];
    };
    "org/gnome/shell/extensions/caffeine" = {
      show-indicator = true;
    };
    "org/gnome/desktop/interface".show-battery-percentage = true;
    "org/gnome/shell/extensions/dash-to-dock" = {
      # --- Common Dash to Dock Settings Examples ---

      # Position on screen ('TOP', 'RIGHT', 'BOTTOM', 'LEFT')
      dock-position = "BOTTOM";

      # Icon size limit (true = limit size, false = use theme size)
      icon-size-fixed = true;
      # Max icon size in pixels when icon-size-fixed = true
      dash-max-icon-size = 48; # Adjust as desired

      # Intellihide ('ALL_WINDOWS', 'MAXIMIZED_WINDOWS', 'NO_AUTOHIDE')
      intellihide-mode = "ALL_WINDOWS";
      # Require pressure to activate intellihide (true/false)
      require-pressure-to-show = true;
      # Pressure threshold (adjust sensitivity)
      pressure-threshold = 150.0; # Default is often 150.0

      # Dock visibility ('PRIMARY', 'ALL', 'FOCUS') - Monitor selection
      preferred-monitor-signal = "PRIMARY"; # Show only on primary monitor
      # Or show on all monitors:
      # preferred-monitor-signal = "ALL";

      # Show app running indicators (true/false)
      show-running-apps = true;
      # Style for running indicators ('DOTS', 'SQUARES', 'DASHES', 'SEGMENTED', 'SOLID', 'CILIORA', 'METRO')
      running-indicator-style = "DOTS";

      # Show favorite applications (true/false)
      show-favorite-apps = true;
      # Show the Applications button (the grid icon) (true/false)
      show-apps-at-top = false; # Set true to show it at the start/top

      # Customize dock appearance (true/false)
      customize-alphas = true;
      # Opacity settings (0.0 fully transparent to 1.0 fully opaque)
      max-alpha = 0.8; # Opacity when not hovered/active
      min-alpha = 0.2; # Opacity for intellihide or when inactive (depends on other settings)

      # Extend dock to screen edges (true/false)
      extend-height = false;

      # Click action ('skip', 'launch', 'cycle-windows', 'minimize', 'quit', 'previews', 'minimize-or-previews')
      click-action = "cycle-windows";

      # Scroll action ('cycle-windows', 'switch-workspace', 'do-nothing')
      scroll-action = "cycle-windows";

      # --- Add any other Dash to Dock settings you want to configure ---
      # Find more keys using dconf-editor under /org/gnome/shell/extensions/dash-to-dock/
      # or by running: gsettings list-recursively org.gnome.shell.extensions.dash-to-dock
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-uri = "file:///home/cloudgenius/nixos-config/wall/eog-wallpaper.png";
      picture-uri-dark = "file:///home/cloudgenius/nixos-config/wall/eog-wallpaper.png";
      picture-options = "zoom"; # Or 'scaled', 'centered', 'spanned', etc.
    };

    # --- Window Manager Keybindings ---
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>w"];
      maximize = ["<Super>Up"];
      begin-resize = ["<Super>BackSpace"];
      toggle-fullscreen = ["<Shift>F11"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      # Disable default Super+Space for input source switching
      switch-input-source = [];
      switch-input-source-backward = [];
    };

    # --- Media Keys & Custom Keybindings ---
    "org/gnome/settings-daemon/plugins/media-keys" = {
      next = ["<Shift>AudioPlay"];

      # List ALL custom keybinding paths you define below
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" # Ulauncher
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" # Flameshot
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" # New Alacritty
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" # New Chrome
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" # Apple Brightness Down
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/" # Apple Brightness Up
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/" # Apple Brightness Max
      ];
    };

    # Define Custom Keybinding 0: Ulauncher
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Ulauncher";
      command = "ulauncher-toggle";
      binding = "<Super>space";
    };

    # Define Custom Keybinding 1: Flameshot
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Flameshot";
      command = ''sh -c "flameshot gui"''; # Indented string for quoting
      binding = "<Control>Print";
    };

    # Define Custom Keybinding 2: New Alacritty Window
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "New Alacritty Window";
      command = "alacritty";
      binding = "<Shift><Alt>2";
    };

    # Define Custom Keybinding 3: New Chrome Window
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "New Chrome Window";
      command = "google-chrome"; # Ensure this command exists
      binding = "<Shift><Alt>1";
    };

    # Define Custom Keybinding 4: Apple Brightness Down (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "Brightness Down";
      # Make sure your ddc.sh script is executable (chmod +x ~/ddc.sh)
      # The path must be correct for the user 'cloudgenius'
      command = "/home/cloudgenius/ddc.sh down";
      binding = "<Control>F1";
    };

    # Define Custom Keybinding 5: Apple Brightness Up (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      name = "Brightness Up";
      command = "/home/cloudgenius/ddc.sh up";
      binding = "<Control>F2";
    };

    # Define Custom Keybinding 6: Apple Brightness Max (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      name = "Brightness Up";
      command = "/home/cloudgenius/ddc.sh up";
      binding = "<Control><Shift>F2";
    };

    # --- Workspace Settings ---
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 6;
    };

    # --- Shell Keybindings (App Switching) ---
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = ["<Alt>1"];
      switch-to-application-2 = ["<Alt>2"];
      switch-to-application-3 = ["<Alt>3"];
      switch-to-application-4 = ["<Alt>4"];
      switch-to-application-5 = ["<Alt>5"];
      switch-to-application-6 = ["<Alt>6"];
      switch-to-application-7 = ["<Alt>7"];
      switch-to-application-8 = ["<Alt>8"];
      switch-to-application-9 = ["<Alt>9"];
    };
  };

  home.packages =
    (with pkgs.gnomeExtensions; [
      # ulauncher
      # flameshot
      # alacritty
      caffeine
      tactile
      paperwm
      appindicator
      dash-to-dock
      vitals
      # pop-shell
      forge
      blur-my-shell
      gsconnect
      quick-settings-tweaker
    ])
    ++ (with pkgs; [
      htop
      vlc
      unzip
      bat
      neofetch
      fastfetch
      jetbrains-mono
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
      gnupg

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

      # system tools
      sysstat
      lm_sensors # for `sensors` command
      ethtool
      pciutils # lspci
      usbutils # lsusb
    ]);

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

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

  # https://github.com/NixOS/nixpkgs/issues/318274
  # systemctl list-units --user --all
  # cd ~/.config/systemd/user
  # systemctl --user status opentabletdriver.service
  # systemctl --user status graphical-session.target

  programs = {
    home-manager.enable = true;
    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window.opacity = 1.0;
        window.decorations = "buttonless";
        # window.startMaximized = false;
        # window.dynamicPadding = false;
        window.padding = {
          x = 5;
          y = 5;
        };

        font.normal = {
          family = "JetBrains Mono";
          style = "Medium";
        };
        font.bold = {
          family = "JetBrains Mono";
          style = "Heavy";
        };
        font.italic = {
          family = "JetBrains Mono";
          style = "Heavy Italic";
        };
        font.bold_italic = {
          family = "JetBrains Mono";
          style = "Medium Italic";
        };
        font.size = 9;
        scrolling.multiplier = 5;
        selection.save_to_clipboard = true;
        general.live_config_reload = true;
        general.import = [
          "${pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "alacritty";
            rev = "f6cb5a5"; # Or specify a specific commit/tag
            sha256 = "sha256-H8bouVCS46h0DgQ+oYY8JitahQDj0V9p2cOoD4cQX+Q="; # Replace with correct hash
          }}/catppuccin-mocha.toml"
        ];
      };
    };
    git = {
      enable = true;
      userName = "Nilesh";
      userEmail = "nilesh@cloudgeni.us";
      aliases = {
        recent = "!git for-each-ref --sort=-committerdate refs/heads/ --format='%(committerdate:short) %(refname:short)' | head -n 10";
        co = "checkout";
        cob = "checkout -b";
        coo = "!git fetch && git checkout";
        br = "branch";
        brd = "branch -d";
        brD = "branch -D";
        merged = "branch --merged";
        st = "status";
        aa = "add -A .";
        cm = "commit -m";
        aacm = "!git add -A . && git commit -m";
        cp = "cherry-pick";
        amend = "commit --amend -m";
        dev = "!git checkout dev && git pull origin dev";
        staging = "!git checkout staging && git pull origin staging";
        main = "!git checkout main && git pull origin";
        master = "!git checkout master && git pull origin";
        po = "push origin";
        pu = "!git push origin `git branch --show-current`";
        pod = "push origin dev";
        pos = "push origin staging";
        pom = "push origin main";
        poh = "push origin HEAD";
        pogm = "!git push origin gh-pages && git checkout master && git pull origin master && git rebase gh-pages && git push origin master && git checkout gh-pages";
        pomg = "!git push origin master && git checkout gh-pages && git pull origin gh-pages && git rebase master && git push origin gh-pages && git checkout master";
        plo = "pull origin";
        plod = "pull origin dev";
        plos = "pull origin staging";
        plom = "pull origin main";
        ploh = "pull origin HEAD";
        unstage = "reset --soft HEAD^";
        ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
        ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat";
        f = "!git ls-files | grep -i";
        gr = "grep -Ii";
        la = "!git config -l | grep alias | cut -c 7-";
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      envExtra = ''
        export ZOMEZSHVARIABLE="something";

        alias k=kubectl;
      '';
      # Add code to run near the end of zsh initialization
      initExtra = ''
        # Attempt to remove the ls alias, ignore errors if it doesn't exist
        unalias ls 2>/dev/null || true
        alias ls=eza
        # Add any other custom init commands below
      '';
      # OR use initExtraFirst = '' ... ''; to run earlier
    };
    vscode = {
      enable = true;
      package = pkgs.vscode; # package = pkgs.vscodium;

      # --- Optional: Manage Extensions ---
      # Uncomment and add extensions you want managed by Home Manager
      # extensions = with pkgs.vscode-extensions; [
      #   # Example extensions (find more on Nix package search or vscode marketplace)
      #   bbenoist.nix                 # Nix language support
      #   ms-python.python             # Python support (Microsoft)
      #   ms-vscode.cpptools         # C/C++ support (Microsoft)
      #   rust-lang.rust-analyzer    # Rust support
      #   # Add other desired extensions here by their identifier
      # ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #   # Example for extensions not yet packaged in nixpkgs
      #   # {
      #   #   name = "github-copilot"; # Or other unique name
      #   #   publisher = "GitHub";
      #   #   version = "1.xxx.xxx"; # Specify version
      #   #   sha256 = "sha256-hash-goes-here"; # Get this hash (nix usually tells you on first build failure)
      #   # }
      # ];

      # --- Optional: Manage User Settings (settings.json) ---
      profiles.default.userSettings = {
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', monospace";
        "editor.fontLigatures" = true; # --- Optional: Enable Font Ligatures (JetBrains Mono supports them) ---
        "editor.fontSize" = 10;
        "terminal.integrated.fontSize" = 10;
        "window.zoomLevel" = -1.5;
        "explorer.confirmDelete" = false;
        "explorer.confirmDragAndDrop" = false;
        "files.autoSave" = "onFocusChange";
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "nix.enableLanguageServer" = true; # If using bbenoist.nix extension
        "workbench.colorTheme" = "Nord";
        "workbench.startupEditor" = "none";
        "update.mode" = "manual";
        "update.showReleaseNotes" = false;
      };
    };
  };

  #   gtk = {
  #     enable = true;
  #     theme.name = "adw-gtk3";
  #     cursorTheme.name = "Bibata-Modern-Ice";
  #     iconTheme.name = "GrubboxPlus";
  #   };
  #
  #   xdg.mimeApps.defaultApplications = {
  #     "text/plain" = ["neovide.desktop"];
  #     "application/pdf" = ["zathura.desktop"];
  #     "image/*" = ["sxiv.desktop"];
  #     "video/png" = ["mpv.desktop"];
  #     "video/jpg" = ["mpv.desktop"];
  #     "video/*" = ["mpv.desktop"];
  #   };

  # Manage dotfiles
  home.file = {
    # Example: Create a directory
    ".config/mera-app".source = ./dotfiles/mera-app; # Assuming you have ./dotfiles/mera-app

    # Example: Symlink screen brightness control script
    "ddc.sh".source = ./dotfiles/ddc.sh;

    # Example: Create a file with specific text content
    ".my-custom-file".text = ''
      Hello from Home Manager!
      Managed declaratively.
    '';
    ".config/bat/config".text = ''
      --theme="Nord"
      --style="numbers,changes,grid"
      --paging=auto
    '';
  };

  home.sessionVariables = {
    EDITOR = "vi";
  };

  home.sessionPath = [
    "$HOME/nixos-config/dotfiles"
  ];

  # Enable user services (e.g., syncthing)
  # services.syncthing.enable = true;
}
