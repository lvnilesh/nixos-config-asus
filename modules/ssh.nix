{
  pkgs,
  lib,
  ...
}: {
  programs = {
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses; # or pkgs.pinentry-gtk2 for GUI
    };
  };
}
