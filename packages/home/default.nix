{
  pkgs,
  ...
}: {
  # Manage dotfiles
  home.file = {
    # Create a p10k.zsh configuration file
    ".p10k.zsh".source = ../../.p10k.zsh;

    # Example: Create a directory
    # ".config/mera-app".source = ../../dotfiles/mera-app; # Assuming you have ./dotfiles/mera-app

    # Example: Symlink screen brightness control script
    # "ddc.sh".source = ../../dotfiles/ddc.sh;

    # Example: Create a file with specific text content
    # ".my-custom-file".text = ''
    #   Hello from Home Manager!
    #   Managed declaratively.
    # '';
    ".config/bat/config".text = ''
      --theme="Nord"
      --style="numbers,changes,grid"
      --paging=auto
    '';
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vi"; # Change to your preferred editor
    VISUAL = "code"; # Change if needed
    PAGER = "less";
    PATH = "$HOME/.local/bin:$PATH";
    # Add more environment variables as needed
    NVM_DIR = "$HOME/.nvm";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  home.sessionPath = [
    "$HOME/nixos-config/dotfiles"
  ];

  # The login keyring did not get unlocked when you logged into the computer.
  # Create an autostart entry instead of using systemd
  home.file.".config/autostart/unlock-keyring.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Unlock Keyring
    Exec=${pkgs.bash}/bin/bash -c "${pkgs.libsecret}/bin/secret-tool unlock --all"
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name[en_US]=Unlock Keyring
    Comment[en_US]=Unlock keyring at startup
    Comment=Unlock keyring at startup
  '';
}
