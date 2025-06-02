{
  pkgs,
  lib,
  config,
  # inputs,
  ...
}:
#
#
#
# let
#  unstable = inputs.nixos-unstable.legacyPackages.${pkgs.system}; # Use legacyPackages and pkgs.system
#  unstable = import <nixos-unstable> {
#    config = {
#      allowUnfree = true;
#    };
#  };
# in
#
#
#
{
  programs.vscode = {
    enable = true; # lib.mkForce true;
    package = pkgs.vscode; # lib.mkForce unstable.vscode; # pkgs.vscode-fhs; # pkgs.vscode; # package = pkgs.vscodium;
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
      "chat.editor.fontSize" = 9;
      "diffEditor.ignoreTrimWhitespace" = true;
      "editor.fontFamily" = "'SF Mono', 'monospace', monospace";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 9;
      "editor.minimap.enabled" = false;
      "explorer.confirmDelete" = false;
      "explorer.confirmDragAndDrop" = false;
      "files.autoSave" = "onFocusChange";
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "nix.enableLanguageServer" = true; # If using bbenoist.nix extension
      "telemetry.telemetryLevel" = "off";
      # "terminal.integrated.allowRoot" = true;
      "terminal.integrated.copyOnSelection" = true;
      "terminal.integrated.defaultProfile.linux" = "zsh";
      "terminal.integrated.enablePersistentSessions" = false;
      "terminal.integrated.enableMultiLinePasteWarning" = "never";
      "terminal.integrated.fontFamily" = "'SF Mono', 'monospace', monospace";
      "terminal.integrated.fontSize" = 9;
      "terminal.integrated.inheritEnv" = true;
      "terminal.integrated.profiles.linux" = {
        "zsh" = {
          "args" = [
            "-l"
            "-c"
            "zellij"
          ];
          "env" = {
            "NO_NEW_PRIVILEGES" = "0";
          };
          "overrideName" = true;
          "path" = "${pkgs.zsh}/bin/zsh";
        };
      };
      "terminal.integrated.sendKeybindingsToShell" = true;
      "terminal.integrated.shellIntegration.enabled" = true;
      "update.mode" = "manual";
      "update.showReleaseNotes" = false;
      "window.zoomLevel" = 0;
      "workbench.activityBar.location" = "top";
      "workbench.colorTheme" = "Catppuccin Mocha";
      "workbench.startupEditor" = "none";
      "workbench.editor.enablePreview" = false;
    };
  };
}
