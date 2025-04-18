{ config, pkgs, lib, ... }:

{
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
      
      glxinfo      # Useful for checking OpenGL rendering (part of mesa-utils)
      cudatoolkit
      
      # neovim
      alacritty
      xwallpaper
      # pcmanfm
      # rofi
      # pfetch
      opentofu

      
      pciutils
      usbutils
      dig
      ethtool
    ];
  };
}