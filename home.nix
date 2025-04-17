{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "cloudgenius";
  home.homeDirectory = "/home/cloudgenius";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11"; # Set to your current NixOS/HM version



  
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
      rb = "sudo nixos-rebuild switch";      
      btw = "echo i use nixos btw";
    };

    initExtra = ''
      export PS1='\[\e[38;5;76m\]\u\[\e[0m\] in \[\e[38;5;32m\]\w\[\e[0m\] \\$ '
    '';
  };

  programs.alacritty = {
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

  home.file.".config/bat/config".text = ''
    --theme="Nord"
    --style="numbers,changes,grid"
    --paging=auto
  '';
  
  home.file.".config/qtile".source = /home/cloudgenius/nixos-config/qtile;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages you want to install for your user
  home.packages = with pkgs; [
    firefox
    htop
    vlc
    unzip
    bat
    neofetch
  ];

  programs.vscode = {
    enable = true;

    # --- CHOOSE ONE PACKAGE ---
    # Option A: Install official Microsoft VS Code (requires allowUnfree)
    package = pkgs.vscode;

    # Option B: Install VSCodium (Open Source build, no telemetry/MS branding)
    # package = pkgs.vscodium; # Recommended if you prefer FOSS

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
    # Uncomment and add settings you want managed by Home Manager
    # userSettings = {
    #   "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', monospace";
    #   "editor.fontSize" = 14;
    #   "workbench.colorTheme" = "Default Dark+";
    #   "files.autoSave" = "onFocusChange";
    #   "nix.enableLanguageServer" = true; # If using bbenoist.nix extension
    #   # Add other settings here
    # };

    # --- Optional: Manage Keybindings (keybindings.json) ---
    # userKeybindings = [
    #   {
    #     key = "ctrl+alt+t";
    #     command = "workbench.action.terminal.toggleTerminal";
    #   }
    # ];

  };


  # Basic git configuration
  programs.git = {
    enable = true;
    userName = "Nilesh";
    userEmail = "nilesh@cloudgeni.us";
  };


  # Manage dotfiles
  home.file = {
    # Example: Create a directory
    ".config/my-app".source = ./dotfiles/my-app; # Assuming you have ./dotfiles/my-app

    # Example: Symlink a file
    ".gitconfig".source = ./dotfiles/.gitconfig;

    # Example: Create a file with specific text content
    ".my-custom-file".text = ''
      Hello from Home Manager!
      Managed declaratively.
    '';
  };
  # Create a 'dotfiles' directory in ~/nixos-config/ to store these files

  # Example: Configure environment variables
  home.sessionVariables = {
    EDITOR = "vi";
    # MY_API_KEY = "secret"; # DON'T DO THIS! Use secrets management.
  };

  # You can configure many programs declaratively:
  # programs.neovim.enable = true;
  # programs.firefox.enable = true;

  # Enable user services (e.g., syncthing)
  # services.syncthing.enable = true;
}