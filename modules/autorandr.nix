{
  config,
  pkgs,
  lib,
  ...
}: {
  # Enable autorandr to handle monitor hotplug events
  services.autorandr = {
    enable = true;

    # Optional: Default profile to use if no configured profile matches
    defaultTarget = "default";

    # Define profiles for different monitor configurations
    profiles = {
      # Profile for when all monitors are connected
      "all-monitors" = {
        fingerprint = {
          # nix-env -iA nixos.autorandr
          # autorandr --save current-setup
          # cat /home/cloudgenius/.config/autorandr/current-setup/setup
          "HDMI-1" = "00ffffffffffff00230100000100000026100103804728960adaffa3584aa22917494b00000001010101010101010101010101010101023a801871382d40582c4500c48e2100001e023a80d072382d40582c4500c48e2100001e000000fc00424d442048444d490a20202020000000fd00323c1f4408000a20202020202001f702031f544985849493a0a1a29f90230904078301000068030c004000001e00011d007251d01e206e285500c48e2100001e011d00bc52d01e20b8285540c48e2100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2"; # Replace with actual fingerprint
          "DP-2" = "00ffffffffffff0020343013010101010b1e0103b51d11783a3585a656489a241250542108000101810081809500d1c0010101010101023a801871382d40582c450026a51000001e000000fd0038411e5311000a202020202020000000fc004b616d7661732031330a202020000000ff004c35363035313739343330320a0113020300b14f010203040590111213149f0607151623097f078301000065030c001000023a801871382d40582c4500dd0c1100001e011d8018711c1620582c2500dd0c1100009e011d80d0721c1620102c2580dd0c1100009e023a80d072382d40102c4580dd0c1100001e00000000000000000000000000000000000000000095"; # Replace with actual fingerprint
          "DP-4" = "00ffffffffffff0006b371270000001432220104b53c22783bf105ad5141b3250e50542108008140818081c0a940d1c0010101010101565e00a0a0a029503020350055502100001a000000fd00283cb2b25d010a202020202020000000fc00504132374a43560a2020202020000000ff0053434c4d53423030343438300a0236020342715a6110040302601f1312115f5e5d666564636222212005140716012309070783010000e200eae305e301e6060701726b04681a00000101283c00e30f21604dd000a0f0703e803020350055502100001a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000517012790300030164fd680184ff134f0007801f003f0b510043000700a9b40004ff139f002f801f003f0b28000200040001d00004ff0e9f002f801f006f083d000200040089660004ff0e9f002f801f006f081e0002000400d5510004ff0e9f002f801f006f081800020004000000000000000000000000000000000000009290"; # Replace with actual fingerprint
        };
        config = {
          # Configure DP-2 (1080p monitor)
          "DP-2" = {
            enable = true;
            mode = "1920x1080"; # Change to your resolution
            position = "0x0";
          };

          # Configure HDMI-1 (ATEM monitor mirrored to DP-2)
          "HDMI-1" = {
            enable = true;
            mode = "1920x1080"; # Change to your resolution
            position = "0x0";
            scale = {
              method = "factor";
              x = 1.0;
              y = 1.0;
            };
          };

          # Configure DP-4 (5K monitor to the right)
          "DP-4" = {
            enable = true;
            mode = "5120x2880"; # Change to your resolution
            position = "1920x0"; # Position it to the right of DP-2
            primary = true;
          };
        };
      };

      # Profile for when DP-4 is disconnected
      "no-dp4" = {
        fingerprint = {
          "HDMI-1" = "00ffffffffffff00230100000100000026100103804728960adaffa3584aa22917494b00000001010101010101010101010101010101023a801871382d40582c4500c48e2100001e023a80d072382d40582c4500c48e2100001e000000fc00424d442048444d490a20202020000000fd00323c1f4408000a20202020202001f702031f544985849493a0a1a29f90230904078301000068030c004000001e00011d007251d01e206e285500c48e2100001e011d00bc52d01e20b8285540c48e2100001e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c2"; # Replace with actual fingerprint
          "DP-2" = "00ffffffffffff0020343013010101010b1e0103b51d11783a3585a656489a241250542108000101810081809500d1c0010101010101023a801871382d40582c450026a51000001e000000fd0038411e5311000a202020202020000000fc004b616d7661732031330a202020000000ff004c35363035313739343330320a0113020300b14f010203040590111213149f0607151623097f078301000065030c001000023a801871382d40582c4500dd0c1100001e011d8018711c1620582c2500dd0c1100009e011d80d0721c1620102c2580dd0c1100009e023a80d072382d40102c4580dd0c1100001e00000000000000000000000000000000000000000095"; # Replace with actual fingerprint
        };
        config = {
          # Configure DP-2 (1080p monitor)
          "DP-2" = {
            enable = true;
            mode = "1920x1080"; # Change to your resolution
            position = "0x0";
            primary = true;
          };

          # Configure HDMI-1 (4K monitor mirrored to DP-2)
          "HDMI-1" = {
            enable = true;
            mode = "1920x1080"; # Change to your resolution
            position = "0x0";
            scale = {
              method = "factor";
              x = 1.0;
              y = 1.0;
            };
          };
        };
      };
    };

    # Define hooks to run after monitor configuration changes
    hooks = {
      postswitch = {
        # Set wallpaper after monitor configuration changes
        "set-wallpaper" = ''
          if [ -e "$HOME/nixos-config/wall/eog-wallpaper.png" ]; then
            if command -v gsettings &> /dev/null; then
              gsettings set org.gnome.desktop.background picture-uri "file://$HOME/nixos-config/wall/eog-wallpaper.png"
              gsettings set org.gnome.desktop.background picture-uri-dark "file://$HOME/nixos-config/wall/eog-wallpaper.png"
              gsettings set org.gnome.desktop.background picture-options 'zoom'

              # Also set screensaver/lock screen
              gsettings set org.gnome.desktop.screensaver picture-uri "file://$HOME/nixos-config/wall/eog-wallpaper.png"
              gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
            fi
          fi
        '';
      };
    };
  };

  # Make sure required packages are installed
  environment.systemPackages = with pkgs; [
    autorandr
    xorg.xrandr
    gnome-settings-daemon # For gsettings
    dconf # Required for gsettings
  ];

  # Enable dconf (required for GNOME settings)
  programs.dconf.enable = true;
}
