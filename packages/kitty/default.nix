{pkgs, ...}: {
  programs.kitty = {
    enable = true;

    settings = {
      # Font configuration
      font_family = "SF Mono";
      bold_font = "SF Mono Bold";
      italic_font = "SF Mono Italic";
      bold_italic_font = "SF Mono Bold Italic";
      font_size = 9;
      adjust_line_height = 0;
      adjust_column_width = 0;
      # Window layout
      remember_window_size = "no";
      initial_window_width = "90c";
      initial_window_height = "30c";
      window_padding_width = 8;

      # Terminal bell
      enable_audio_bell = false;
      visual_bell_duration = "0.1";

      # Scrollback
      scrollback_lines = 10000;

      # Mouse
      mouse_hide_wait = 3.0;
      copy_on_select = "clipboard";

      # Advanced
      shell_integration = "enabled";
      allow_remote_control = "yes";

      # Colors (Dracula theme as an example)
      background = "#282a36";
      foreground = "#f8f8f2";
      cursor = "#f8f8f2";
      selection_background = "#44475a";
      selection_foreground = "#f8f8f2";
    };

    # Keybindings
    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+equal" = "increase_font_size";
      "ctrl+shift+minus" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";
      "ctrl+shift+z" = "launch --type=overlay ${pkgs.zellij}/bin/zellij --config-dir /home/cloudgenius/.config/zellij";
    };

    # Instead of shell, use startup_session
    extraConfig = ''
      # Set the path to Zellij config
      env ZELLIJ_CONFIG_DIR=/home/cloudgenius/.config/zellij
      # Make sure no session is loaded
      shell_integration enabled

      # Force X11 for better GPU compatibility
      env KITTY_DISABLE_WAYLAND=1

      # NVIDIA optimizations
      env __GL_THREADED_OPTIMIZATIONS=1

      # Launch Zellij on startup with the correct config
      # startup_session zellij
    '';
  };
}
