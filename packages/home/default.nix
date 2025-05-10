{
  # Manage dotfiles
  home.file = {
    # Example: Create a directory
    ".config/mera-app".source = ../../dotfiles/mera-app; # Assuming you have ./dotfiles/mera-app

    # Example: Symlink screen brightness control script
    "ddc.sh".source = ../../dotfiles/ddc.sh;

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
}
