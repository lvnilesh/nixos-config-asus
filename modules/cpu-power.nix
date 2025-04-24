{ pkgs, lib, ... }:
{
  
  # Set up auto-cpufreq for better power management.
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };
  # This is the service that lets you pick power profiles in the gnome UI.  It conflicts with auto-cpufreq
  services.power-profiles-daemon.enable = false;

}
