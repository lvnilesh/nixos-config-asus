{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.micromamba
  ];

  xdg.configFile."screenpen/launch-screenpen.sh" = {
    text = ''
      #!/usr/bin/env bash
      export MAMBA_ROOT_PREFIX="$HOME/.local/share/micromamba"
      export MAMBA_EXE="${pkgs.micromamba}/bin/micromamba"
      export ENV_NAME="screenpen"
      export ENV_PREFIX="$MAMBA_ROOT_PREFIX/envs/$ENV_NAME"

      # Create the environment if it doesn't exist
      if [ ! -d "$ENV_PREFIX" ]; then
        $MAMBA_EXE create -y -n $ENV_NAME python pyqt -c conda-forge
        $MAMBA_EXE run -n $ENV_NAME pip install --upgrade pip setuptools
        $MAMBA_EXE run -n $ENV_NAME pip install screenpen
      fi

      # Always upgrade screenpen on launch (optional, remove if not desired)
      # $MAMBA_EXE run -n $ENV_NAME pip install --upgrade screenpen

      exec $MAMBA_EXE run -n $ENV_NAME python -m screenpen -c /home/cloudgenius/nixos-config/dotfiles/screenpenconfig.ini "$@"
    '';
    executable = true;
  };

  xdg.desktopEntries.screenpen = {
    name = "ScreenPen";
    exec = "${config.home.homeDirectory}/.config/screenpen/launch-screenpen.sh";
    terminal = false;
    type = "Application";
    categories = ["Utility"];
  };

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "ScreenPen";
      command = "${config.home.homeDirectory}/.config/screenpen/launch-screenpen.sh";
      binding = "<Alt>p";
    };
  };
}
