{
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
}
