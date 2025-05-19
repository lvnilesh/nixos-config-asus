# In your home-manager configuration
{
  config,
  pkgs,
  ...
}: {
  services.polybar = {
    enable = true;
    package = pkgs.polybar;
    script = "polybar &";
    config = {
      "bar/main" = {
        modules-right = "mpris date";
        # Other bar settings...
      };

      "module/mpris" = {
        type = "custom/script";
        exec = "${pkgs.playerctl}/bin/playerctl metadata --format '{{ artist }} - {{ title }}' --follow";
        tail = true;
        label = "%output%";
        format-prefix = "♪ ";
        format = "<label>";
        # Additional config...
      };

      # Other module definitions...
    };
  };

  # Install required packages
  home.packages = with pkgs; [
    playerctl # Command-line controller for MPRIS
    mpdris2 # Bridge between MPD and MPR
    mpd # Music Player Daemon
  ];
}
