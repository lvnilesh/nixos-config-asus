{
  config,
  pkgs,
  lib,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      deja-dup
      bitwarden
      bitwarden-cli
      dos2unix
      obsidian
      # gnome-terminal
      btop
      htop
      flatpak

      # libreoffice-fresh
      # pdfarranger
      # gImageReader
      # gnome.dconf-editor
      # gnome.gnome-tweaks
      # gnome.gnome-software

      glxinfo # Useful for checking OpenGL rendering (part of mesa-utils)
      cudatoolkit
      autorandr
      xorg.xrandr
      xorg.xset
      xorg.xsetroot
      xorg.xinit
      xorg.xmodmap
      xorg.xev
      xorg.xrandr
      gnome-settings-daemon # For gsettings
      dconf # Required for gsettings

      inetutils
      cifs-utils
      samba
      avahi

      mongosh

      # neovim
      alacritty
      xwallpaper
      # pcmanfm
      # rofi
      # pfetch
      opentofu
      autojump
      coreutils
      pciutils
      usbutils
      dig
      ethtool
      opentabletdriver
      google-chrome
      floorp
      # brave
      python313Full
      eza
      alejandra
      dunst # notify-send
      mako # notify-send
      libnotify # notify-send
      glib # notify-send
      discord
      telegram-desktop
      whatsapp-for-linux
      signal-desktop-bin
      pinta
      krita
      gimp
      inkscape
      blender
      gnome-screenshot
      gnome-disk-utility
      gnome-system-monitor
      gnome-remote-desktop
      unrar
      ffmpeg

      # GStreamer framework tools
      gst_all_1.gstreamer

      # Plugin collections by category
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly

      # FFmpeg support for almost any video format
      gst_all_1.gst-libav

      # Hardware acceleration support
      gst_all_1.gst-vaapi

      # Test if GStreamer is working properly with:
      # gst-launch-1.0 videotestsrc ! videoconvert ! autovideosink

      # Core Rust toolchain
      rustup
      rustc
      cargo
      gcc
      (rustPlatform.rustLibSrc) # Add the source component

      # Essential development tools
      rustfmt # Code formatter
      clippy # Linter
      rust-analyzer # Language server for IDEs

      gnupg
      pinentry # For passphrase entry dialogs
      pinentry-curses
      pinentry-gtk2
      gpgme
      paperkey
      keybase
      yubikey-personalization
      yubikey-manager
      pcsclite
      pcsctools

      pkgs.catppuccin
      pkgs.catppuccin-gtk
      pkgs.catppuccin-cursors
    ];
  };
}
