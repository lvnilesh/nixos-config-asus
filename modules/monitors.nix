{
  pkgs,
  lib,
  ...
}: {
  # User-level service
  systemd.user.services.monitorscript = {
    description = "Setup monitor layout at startup";

    # Important: This runs AFTER the session is fully loaded and authenticated
    after = ["graphical-session.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/home/cloudgenius/nixos-config/dotfiles/monitors.sh";
      # Add the required packages to the PATH
      Environment = [
        "PATH=${pkgs.xorg.xrandr}/bin:${pkgs.coreutils}/bin:$PATH"
        "DISPLAY=:0"
      ];
    };

    # This activates the service on session login
    wantedBy = ["graphical-session.target"];
  };
}
