{
  pkgs,
  config,
  ...
}: {
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Replaces driSupport32Bit concept
    extraPackages = [];
    extraPackages32 = [];
  };

  #  hardware.opengl = {
  #    enable = true;
  #    driSupport = true;
  #    driSupport32Bit = true;
  #  };

  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = false;
    powerManagement.enable = true; # Optional: Enable power management (suspend/resume features)
    nvidiaSettings = true; # Optional: Enable NVIDIA settings persistence daemon
  };
}
