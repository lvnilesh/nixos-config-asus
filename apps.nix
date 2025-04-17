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
      dconf-editor 

      gnome-tweaks
      btop
      htop
      flatpak
      gnome-software
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