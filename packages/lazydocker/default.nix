{pkgs, ...}: {
  # Create lazydocker config file
  xdg.configFile."lazydocker/config.yml".text = ''
    gui:
      scrollHeight: 2
      theme:
        activeBorderColor:
          - green
          - bold
        inactiveBorderColor:
          - white
      returnImmediately: false
    update:
      dockerRefreshInterval: 100ms
  '';
}
