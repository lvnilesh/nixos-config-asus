{pkgs, ...}: {
  # Create a custom GTK CSS file to reduce title bar height
  home.file.".config/gtk-3.0/gtk.css".text = ''
    /* Reduce title bar height */
    headerbar.default-decoration {
      min-height: 0px;
      padding-top: 1px;     /* Adjust this value to reduce from top */
      padding-bottom: 1px;  /* Adjust this value to reduce from bottom */
    }

    headerbar.default-decoration button.titlebutton {
      min-height: 0px;
      min-width: 0px;
      padding: 1px;         /* Make buttons smaller */
    }

    /* Reduce window title bar height */
    .titlebar {
      min-height: 0px;
      padding-top: 0px;
      padding-bottom: 0px;
    }
  '';
  # Manage dotfiles
  home.file = {
    # Create a p10k.zsh configuration file
    ".p10k.zsh".source = ../../.p10k.zsh;

    # Example: Create a directory
    # ".config/mera-app".source = ../../dotfiles/mera-app; # Assuming you have ./dotfiles/mera-app

    # Example: Symlink screen brightness control script
    # "ddc.sh".source = ../../dotfiles/ddc.sh;

    # Example: Create a file with specific text content
    # ".my-custom-file".text = ''
    #   Hello from Home Manager!
    #   Managed declaratively.
    # '';
    ".config/bat/config".text = ''
      --theme="Nord"
      --style="numbers,changes,grid"
      --paging=auto
    '';
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "vi"; # Change to your preferred editor
    VISUAL = "code"; # Change if needed
    PAGER = "less";
    PATH = "$HOME/.local/bin:$PATH";
    # Add more environment variables as needed
    NVM_DIR = "$HOME/.nvm";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };

  home.sessionPath = [
    "$HOME/nixos-config/dotfiles"
  ];

  # The login keyring did not get unlocked when you logged into the computer.
  # Create an autostart entry instead of using systemd
  home.file.".config/autostart/unlock-keyring.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Unlock Keyring
    Exec=${pkgs.bash}/bin/bash -c "${pkgs.libsecret}/bin/secret-tool unlock --all"
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Name[en_US]=Unlock Keyring
    Comment[en_US]=Unlock keyring at startup
    Comment=Unlock keyring at startup
  '';

  home.file.".config/touchegg/touchegg.conf".text = ''
    <touchégg>
      <settings>
        <property name="animation_delay">150</property>
        <property name="action_execute_threshold">20</property>
        <property name="color">auto</property>
        <property name="borderColor">auto</property>
      </settings>

      <application name="All">
        <!-- Switch to workspace left with 3-finger swipe right -->
        <gesture type="SWIPE" fingers="3" direction="RIGHT">
          <action type="RUN_COMMAND">
            <command>xdotool key ctrl+alt+Left</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>

        <!-- Switch to workspace right with 3-finger swipe left -->
        <gesture type="SWIPE" fingers="3" direction="LEFT">
          <action type="RUN_COMMAND">
            <command>xdotool key ctrl+alt+Right</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>

        <!-- Switch to workspace left with 4-finger swipe right -->
        <gesture type="SWIPE" fingers="4" direction="RIGHT">
          <action type="RUN_COMMAND">
            <command>xdotool key ctrl+alt+Left</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>

        <!-- Switch to workspace right with 4-finger swipe left -->
        <gesture type="SWIPE" fingers="4" direction="LEFT">
          <action type="RUN_COMMAND">
            <command>xdotool key ctrl+alt+Right</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>


        <!-- Show all windows (Activities overview) with 3-finger swipe up -->
        <gesture type="SWIPE" fingers="3" direction="UP">
          <action type="RUN_COMMAND">
            <command>xdotool key super</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>

        <!-- Add 4-finger swipe down to dismiss overview -->
        <gesture type="SWIPE" fingers="3" direction="DOWN">
          <action type="RUN_COMMAND">
            <command>xdotool key Escape</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>


        <!-- Show all windows (Activities overview) with 4-finger swipe up -->
        <gesture type="SWIPE" fingers="4" direction="UP">
          <action type="RUN_COMMAND">
            <command>xdotool key super</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>

        <!-- Add 4-finger swipe down to dismiss overview -->
        <gesture type="SWIPE" fingers="4" direction="DOWN">
          <action type="RUN_COMMAND">
            <command>xdotool key Escape</command>
            <repeat>false</repeat>
            <on>end</on>
          </action>
        </gesture>
      </application>
    </touchégg>
  '';
}
