# In your home-manager configuration
{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zoom-us
  ];
}
