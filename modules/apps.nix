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
      obsidian
      gnome-terminal
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

      # neovim
      alacritty
      xwallpaper
      # pcmanfm
      # rofi
      # pfetch
      opentofu

      coreutils
      pciutils
      usbutils
      dig
      ethtool
      opentabletdriver
      google-chrome
      floorp
      brave
      python313Full
      eza
      alejandra
      dunst # notify-send
      mako # notify-send
      libnotify # notify-send
      glib # notify-send
      discord

      # Core Rust toolchain
      rustc
      cargo
      gcc
      # Essential development tools
      rustfmt # Code formatter
      clippy # Linter
      rust-analyzer # Language server for IDEs
    ];
  };
}
