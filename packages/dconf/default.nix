{
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "caffeine@patapon.info"
        "tactile@lundal.io"
        "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
        "pop-shell@system76.com"
        "forge@jmmaranan.com"
        "Vitals@CoreCoding.com"
        "gsconnect@andyholmes.github.io"
        "quick-settings-tweaks@qwreey"
        "appindicatorsupport@rgcjonas.gmail.com"
        "paperwm@paperwm.github.com"
        "dash-to-dock@micxgx.gmail.com"
        "datemenu-formatter@marcinjakubowski.github.com"
        "openweather-extension@jenslody.de"
        "just-perfection-desktop@just-perfection"
        "blur-my-shell@aunetx"
        "space-bar@luchrioh"
        "undecorate@sun.wxg@gmail.com"
        "tophat@fflewddur.github.io"
        "AlphabeticalAppGrid@stuarthayhurst"
      ];
    };
    "org/gnome/shell/extensions/caffeine" = {
      show-indicator = true;
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
      command = "/home/cloudgenius/ddc.sh down";
      binding = "<Control>F1";
    };

    # Define Custom Keybinding 5: Apple Brightness Up (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      name = "Brightness Up";
      command = "/home/cloudgenius/ddc.sh up";
      binding = "<Control>F2";
    };

    # Define Custom Keybinding 6: Apple Brightness Max (ASDControl)
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      name = "Brightness Up";
      command = "/home/cloudgenius/ddc.sh up";
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
