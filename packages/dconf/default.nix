{
  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      # Optionally, you can change the button layout here
      button-layout = "appmenu:minimize,maximize,close";
      # Reduce title bar font size
      titlebar-font = "Sans 9"; # Smaller font for title bars
    };

    # Enable minimize and maximize buttons
    "org/gnome/desktop/wm/preferences" = {
      action-minimize = "minimize";
      action-maximize = "maximize";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "caffeine@patapon.info"
        "dash-to-dock@micxgx.gmail.com"
        "tilingshell@ferrarodomenico.com"
        "Vitals@CoreCoding.com"
        "mediacontrols@cliffniff.github.com"
        "just-perfection-desktop@just-perfection"

        # "tactile@lundal.io"
        # "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        # "pop-shell@system76.com"
        # "forge@jmmaranan.com"
        # "gsconnect@andyholmes.github.io"
        # "quick-settings-tweaks@qwreey"
        # "paperwm@paperwm.github.com"
        # "datemenu-formatter@marcinjakubowski.github.com"
        # "openweather-extension@jenslody.de"
        # "space-bar@luchrioh"
        # "undecorate@sun.wxg@gmail.com"
        # "tophat@fflewddur.github.io"
        # "AlphabeticalAppGrid@stuarthayhurst"
      ];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      # Workspace Settings
      workspace-popup-mode = 1; # 0 = Default, 1 = Compact (bigger thumbnails)
      workspace-switcher-size = 15; # Scale factor (default is 10, higher values = bigger)
      workspace-switcher-should-show = true; # Show workspace switcher popup
      # Enable workspace switcher click to main view
      workspace-switcher-popup-only-on-primary = false;
      workspace-switcher-click-to-main-view = true;
      # Panel Settings
      panel = true; # Show top panel
      panel-in-overview = true; # Show panel in overview
      panel-notification-icon = true; # Show notification icon
      panel-arrow = true; # Show panel arrow
      panel-corner-size = 0; # Panel corner size (0 = default)
      panel-button-padding-size = 0; # Adjust panel button padding
      panel-indicator-padding-size = 0; # Adjust panel indicator padding
      clock-menu = true; # Show clock menu
      calendar = true; # Show calendar in clock menu
      week-numbers = false; # Show week numbers in calendar

      # Start Menu/Dash Settings
      dash = true; # Show dash
      dash-icon-size = 0; # Dash icon size (0 = default)

      # Overview Settings and Behavior
      search = true; # Show search
      ripple-box = true; # Show ripple animation when opening activities
      keyboard-layout = true; # Show keyboard layout
      accessibility-menu = true; # Show accessibility menu
      hot-corner = true; # Enable hot corner
      osd = true; # Show on-screen display
      window-demands-attention-focus = true; # Auto focus windows that demand attention
      window-picker-icon = true; # Show app icon in window picker
      type-to-search = true; # Type to search

      # Animation Settings
      animation = true; # Enable animations
      animation-speed = 1.0; # Animation speed (1.0 = normal)

      # Background Settings
      background-menu = true; # Show background menu
      theme = true; # Enable theme compatibility
      activities-button = true; # Show activities button

      # Screen Related Settings
      double-super-to-appgrid = true; # Double Super key press to show app grid
      overlay-key = true; # Enable overlay key (Super)

      # Window Controls
      window-maximized-border = true; # Enable window maximized border
      window-preview-caption = true; # Show window preview caption
      window-preview-close-button = true; # Show window preview close button

      # Other Visual Elements
      startup-status = 0; # 0 = Default
      power-icon = true; # Show power icon
      workspace-wrap-around = false; # Wrap around workspaces when reaching the end
      notification-banner-position = 0; # 0 = Top Start, 1 = Top Center, 2 = Top End

      # App Grid Settings
      app-grid-animation = true; # Enable app grid animation
      app-grid-icon-size = 0; # App grid icon size (0 = default)

      # Miscellaneous
      looking-glass-width = 0; # Looking glass width (0 = default)
      looking-glass-height = 0; # Looking glass height (0 = default)
      show-apps-button = true; # Show applications button
    };

    "org/gnome/shell/extensions/caffeine" = {
      show-indicator = true;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      blur-enabled = true;
      blur-strength = 10.0; # Adjust as desired
      blur-background = true;
      blur-background-opacity = 0.8; # Adjust as desired
      blur-background-saturation = 1.0; # Adjust as desired
    };

    "org/gnome/desktop/interface".show-battery-percentage = true;
    "org/gnome/shell/extensions/dash-to-dock" = {
      # --- Common Dash to Dock Settings Examples ---

      # Position on screen ('TOP', 'RIGHT', 'BOTTOM', 'LEFT')
      dock-position = "BOTTOM";

      # Icon size limit (true = limit size, false = use theme size)
      icon-size-fixed = true;
      # Max icon size in pixels when icon-size-fixed = true
      dash-max-icon-size = 48; # Adjust as desired

      # Intellihide ('ALL_WINDOWS', 'MAXIMIZED_WINDOWS', 'NO_AUTOHIDE')
      intellihide-mode = "ONLY_FOCUSED_WINDOWS"; # Adjust as desired
      # Require pressure to activate intellihide (true/false)
      require-pressure-to-show = true;
      # Pressure threshold (adjust sensitivity)
      pressure-threshold = 150.0; # Default is often 150.0

      # Dock visibility ('PRIMARY', 'ALL', 'FOCUS') - Monitor selection
      preferred-monitor-signal = "PRIMARY"; # Show only on primary monitor
      # Or show on all monitors:
      # preferred-monitor-signal = "ALL";

      # Show app running indicators (true/false)
      show-running-apps = true;
      # Style for running indicators ('DOTS', 'SQUARES', 'DASHES', 'SEGMENTED', 'SOLID', 'CILIORA', 'METRO')
      running-indicator-style = "DOTS";

      # Show favorite applications (true/false)
      show-favorite-apps = true;
      # Show the Applications button (the grid icon) (true/false)
      show-apps-at-top = false; # Set true to show it at the start/top

      # Customize dock appearance (true/false)
      customize-alphas = true;
      # Opacity settings (0.0 fully transparent to 1.0 fully opaque)
      max-alpha = 0.8; # Opacity when not hovered/active
      min-alpha = 0.2; # Opacity for intellihide or when inactive (depends on other settings)

      # Extend dock to screen edges (true/false)
      extend-height = false;

      # Click action ('skip', 'launch', 'cycle-windows', 'minimize', 'quit', 'previews', 'minimize-or-previews')
      click-action = "cycle-windows";

      # Scroll action ('cycle-windows', 'switch-workspace', 'do-nothing')
      scroll-action = "cycle-windows";

      # --- Add any other Dash to Dock settings you want to configure ---
      # Find more keys using dconf-editor under /org/gnome/shell/extensions/dash-to-dock/
      # or by running: gsettings list-recursively org.gnome.shell.extensions.dash-to-dock
    };
    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-uri = "file:///home/cloudgenius/nixos-config/wall/eog-wallpaper.png";
      picture-uri-dark = "file:///home/cloudgenius/nixos-config/wall/eog-wallpaper.png";
      picture-options = "zoom"; # Or 'scaled', 'centered', 'spanned', etc.
    };

    # --- Window Manager Keybindings ---
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>w"];
      maximize = ["<Super>Up"];
      begin-resize = ["<Super>BackSpace"];
      toggle-fullscreen = ["<Shift>F11"];
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      # Disable default Super+Space for input source switching
      switch-input-source = [];
      switch-input-source-backward = [];
    };

    # --- Media Keys & Custom Keybindings ---
    "org/gnome/settings-daemon/plugins/media-keys" = {
      next = ["<Shift>AudioPlay"];

      # List ALL custom keybinding paths you define below
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" # Ulauncher
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/" # Flameshot
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/" # New Alacritty
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/" # New Chrome
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/" # Apple Brightness Down
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/" # Apple Brightness Up
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6/" # Apple Brightness Max
      ];
    };

    # Define Custom Keybinding 0: Ulauncher
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Ulauncher";
      command = "ulauncher-toggle";
      binding = "<Super>space";
    };

    # Define Custom Keybinding 1: Flameshot
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      name = "Flameshot";
      command = ''sh -c "flameshot gui"''; # Indented string for quoting
      binding = "<Control>Print";
    };

    # Define Custom Keybinding 2: New Alacritty Window
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      name = "New Alacritty Window";
      command = "alacritty";
      binding = "<Shift><Alt>2";
    };

    # Define Custom Keybinding 3: New Chrome Window
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
      name = "New Chrome Window";
      command = "google-chrome"; # Ensure this command exists
      binding = "<Shift><Alt>1";
    };

    # Define Custom Keybinding 4: Apple Brightness Down (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
      name = "Brightness Down";
      # Make sure your ddc.sh script is executable (chmod +x ~/ddc.sh)
      # The path must be correct for the user 'cloudgenius'
      command = "/home/cloudgenius/nixos-config/dotfiles/ddc.sh down";
      binding = "<Control>F1";
    };

    # Define Custom Keybinding 5: Apple Brightness Up (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      name = "Brightness Up";
      command = "/home/cloudgenius/nixos-config/dotfiles/ddc.sh up";
      binding = "<Control>F2";
    };

    # Define Custom Keybinding 6: Apple Brightness Max (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      name = "Brightness Up";
      command = "/home/cloudgenius/nixos-config/dotfiles/ddc.sh up";
      binding = "<Control><Shift>F2";
    };

    # --- Workspace Settings ---
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 6;
    };

    # --- Shell Keybindings (App Switching) ---
    "org/gnome/shell/keybindings" = {
      switch-to-application-1 = ["<Alt>1"];
      switch-to-application-2 = ["<Alt>2"];
      switch-to-application-3 = ["<Alt>3"];
      switch-to-application-4 = ["<Alt>4"];
      switch-to-application-5 = ["<Alt>5"];
      switch-to-application-6 = ["<Alt>6"];
      switch-to-application-7 = ["<Alt>7"];
      switch-to-application-8 = ["<Alt>8"];
      switch-to-application-9 = ["<Alt>9"];
    };
  };
}
