{
  pkgs,
  lib,
  config,
  ...
}: {
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
      "editor.fontFamily" = "'SF Mono', 'monospace', monospace";
      "editor.fontLigatures" = true; # --- Optional: Enable Font Ligatures (JetBrains Mono supports them) ---
      "editor.fontSize" = 10;
      "terminal.integrated.fontFamily" = "'SF Mono', 'monospace', monospace";
      "terminal.integrated.fontSize" = 10;
      "window.zoomLevel" = 0;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "files.autoSave" = "onFocusChange";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "nix.enableLanguageServer" = true; # If using bbenoist.nix extension
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.startupEditor" = "none";
      "update.mode" = "manual";
      "update.showReleaseNotes" = false;
      "diffEditor.ignoreTrimWhitespace" = true;
    };
  };
}
