{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      window = {
        opacity = 1.0;
        decorations = "buttonless"; # Options: full, none, transparent, buttonless
        startup_mode = "Windowed"; # Options: Windowed, Maximized, Fullscreen
        dimensions = {
          columns = 100; # Set the line width (number of columns)
          lines = 30; # Set the line count (number of lines)
        };
        position = {
          x = 3200; # Window position from left edge of screen (in pixels)
          y = 1440; # Window position from top edge of screen (in pixels)
        };
        padding = {
          x = 5; # Padding inside the window (horizontal)
          y = 5; # Padding inside the window (vertical)
        };
      };

      font = {
        size = 9;
        normal = {
          family = "SF Mono";
          style = "Regular";
        };
        bold = {
          family = "SF Mono";
          style = "Heavy";
        };
        italic = {
          family = "SF Mono";
          style = "Heavy Italic";
        };
        bold_italic = {
          family = "SF Mono";
          style = "Medium Italic";
        };
      };

      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      general.live_config_reload = true;
      general.import = [
        "${pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "alacritty";
          rev = "f6cb5a5"; # Or specify a specific commit/tag
          sha256 = "sha256-H8bouVCS46h0DgQ+oYY8JitahQDj0V9p2cOoD4cQX+Q="; # Replace with correct hash
        }}/catppuccin-mocha.toml"
      ];
    };
  };
}
