{ config, pkgs, lib, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      deja-dup 
      bitwarden
      obsidian 
      # libreoffice-fresh 
      # pdfarranger
      # gImageReader
      # gnome.dconf-editor 
      # gnome.gnome-tweaks
      # gnome.gnome-software
      btop
      htop
      flatpak
      
      glxinfo      # Useful for checking OpenGL rendering (part of mesa-utils)
      cudatoolkit
      
      # neovim
      alacritty
      xwallpaper
      # pcmanfm
      # rofi
      # pfetch
      opentofu

      albert
      pciutils
      usbutils
      dig
    ];
  };
}