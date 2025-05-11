# Add to your home-manager configuration file
# For example, in your home-manager.users.cloudgenius section of configuration.nix
{
  config,
  pkgs,
  lib,
  ...
}: let
  # Define the configuration content as a proper Nix structure
  syncConfig = lib.generators.toJSON {} {
    listening_port = 55555;
    storage_path = "${config.home.homeDirectory}/btsync/config";
    display_new_version = false;
    directory_root = "${config.home.homeDirectory}/btsync/sync/";
    files_default_path = "${config.home.homeDirectory}/downloads";
    webui = {
      listen = "0.0.0.0:8888";
      allow_empty_password = true;
    };
  };
in {
  # Install Resilio Sync from nixpkgs
  home.packages = [pkgs.resilio-sync];

  # Create a wrapper script that generates the config file directly
  home.file.".local/bin/resilio-sync" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      CONFIG_DIR="${config.home.homeDirectory}/btsync/config"
      CONFIG_PATH="$CONFIG_DIR/sync.conf"

      # Make sure the directory exists
      mkdir -p "$CONFIG_DIR"

      # Create the config file directly
      cat > "$CONFIG_PATH" << 'EOF'
      ${syncConfig}
      EOF

      # Set proper permissions
      chmod 600 "$CONFIG_PATH"

      # Run resilio-sync with the config
      exec ${pkgs.resilio-sync}/bin/rslsync --config "$CONFIG_PATH" --nodaemon
    '';
  };

  # Setup for PATH
  home.sessionPath = ["${config.home.homeDirectory}/.local/bin"];

  # Add activation script to prepare directories
  home.activation = {
    prepareResilioSync = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/btsync/config
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/btsync/sync
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/downloads
      $DRY_RUN_CMD mkdir -p ${config.home.homeDirectory}/.local/bin
    '';
  };

  # Setup systemd user service
  systemd.user.services.resilio-sync = {
    Unit = {
      Description = "Resilio Sync Service";
      After = "network.target";
    };

    Service = {
      ExecStart = "${config.home.homeDirectory}/.local/bin/resilio-sync";
      Restart = "on-failure";
      RestartSec = 5;
      Type = "simple";
      PrivateTmp = true;
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
# # Start Resilio Sync
# systemctl --user start resilio-sync
# # Stop Resilio Sync
# systemctl --user stop resilio-sync
# # Check status
# systemctl --user status resilio-sync
# # Enable auto-start at login
# systemctl --user enable resilio-sync
# # Disable auto-start
# systemctl --user disable resilio-sync
# # View logs
# journalctl --user -u resilio-sync

