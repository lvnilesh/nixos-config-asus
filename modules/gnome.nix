{
  pkgs,
  lib,
  ...
}: {
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.xserver = {
    displayManager = {
      gdm.enable = true;
      sessionCommands = ''
        ${pkgs.xorg.xset}/bin/xset r rate 200 35 &
      '';
    };
    desktopManager.gnome = {
      enable = true;
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = "cloudgenius";
  };

  # Selectively disable some GNOME extensions
  #
  # services.xserver.desktopManager.gnome = {
  #   extraGSettingsOverrides = ''
  #     [org.gnome.shell]
  #     disabled-extensions=['window-list@gnome-shell-extensions.gcampax.github.com']
  #   '';
  # };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.gnome.gnome-initial-setup.enable = false;

  environment.systemPackages = with pkgs.gnomeExtensions; [
  ];

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-font-viewer
    gnome-keyring
    gnome-maps
    gnome-music
    # gnome-remote-desktop
    gnome-shell-extensions # (this is a meta package, so it will pull in all the extensions)
    gnome-photos
    gnome-terminal
    gnome-tour
    yelp
  ];

  # The calculator app tries to pull various values for currency conversions, etc that I don't need.  Just block
  # everything
  services.opensnitch.rules = {
    rule-500-gnome-calc = {
      name = "Block calculator from any network access";
      enabled = true;
      action = "deny";
      duration = "always";
      operator = {
        type = "simple";
        sensitive = false;
        operand = "process.path";
        data = "${lib.getBin pkgs.gnome-calculator}/bin/.gnome-calculator-wrapped";
      };
    };
  };
}
