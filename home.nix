{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cloudgenius";
  home.stateVersion = "24.11"; # Set to your current NixOS/HM version
  fonts.fontconfig.enable = true;
  xdg.enable = true;

  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "tactile@lundal.io"
#        "datemenu-formatter@marcinjakubowski.github.com"
#        "openweather-extension@jenslody.de"
#        "just-perfection-desktop@just-perfection"
#        "blur-my-shell@aunetx"
#        "space-bar@luchrioh"
#        "undecorate@sun.wxg@gmail.com"
#        "tophat@fflewddur.github.io"
#        "AlphabeticalAppGrid@stuarthayhurst"        
      ];
    };
    "org/gnome/shell/extensions/caffeine" = {
      show-indicator = true;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/cloudgenius/nixos-config/wall/eog-wallpaper.png";
      picture-uri-dark = "file:///home/cloudgenius/nixos-config/wall/eog-wallpaper.png";
      picture-options = "zoom"; # Or 'scaled', 'centered', 'spanned', etc.
    };    
  };

  home.packages = 
    (with pkgs.gnomeExtensions; [
      caffeine
      tactile
    ])
    ++
    (with pkgs; [
      firefox
      htop
      vlc
      unzip
      bat
      neofetch
      jetbrains-mono
      albert
      (google-cloud-sdk.withExtraComponents [
        google-cloud-sdk.components.gke-gcloud-auth-plugin
        google-cloud-sdk.components.kubectl
      ])
      azure-cli
      awscli2
    ]);

  systemd.user.services.albert = {
    Unit = { Description = "Albert Launcher"; After = [ "graphical-session.target" ]; };
    Service = { ExecStart = "${pkgs.albert}/bin/albert"; Restart = "on-failure"; };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };

  systemd.user.services.opentabletdriver = {
    Unit = { Description = "opentabletdriver daemon launcher"; After = [ "graphical-session.target" ]; };
    Service = { ExecStart = "${pkgs.opentabletdriver}/bin/otd-daemon"; Restart = "on-failure"; };
    Install = { WantedBy = [ "graphical-session.target" ]; };
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
        window.opacity = 1.0;
        font.normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
        font.size = 16;
      };
    };
  };

  programs.vscode = {
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
      "editor.fontSize" = 16;    
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "files.autoSave" = "onFocusChange";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "nix.enableLanguageServer" = true; # If using bbenoist.nix extension
      "workbench.colorTheme" = "Default Dark+";
      "workbench.startupEditor" = "none";
    };

  };


  # Manage dotfiles
  home.file = {
    # Example: Create a directory
    ".config/mera-app".source = ./dotfiles/mera-app; # Assuming you have ./dotfiles/mera-app

    # Example: Symlink a file
    ".gitconfig".source = ./dotfiles/.gitconfig;

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

  # Enable user services (e.g., syncthing)
  # services.syncthing.enable = true;
}