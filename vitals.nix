# In your home-manager configuration (e.g., home.nix)
{ config, pkgs, lib, ... }:

{

  # --- Configure Vitals Settings via dconf ---
  dconf.settings = {
    # Target the dconf path used by the Vitals extension
    "org/gnome/shell/extensions/vitals" = {

      # --- Example Vitals Configuration ---
      # (Adjust these values to your preferences)

      # Update interval in milliseconds (e.g., 2000 = 2 seconds)
      update-time = 2000;

      # Display order of sensors in the panel (comma-separated string list)
      # Valid items often include: cpu-usage, cpu-frequency, cpu-temperature,
      # memory-usage, swap-usage, storage-usage, network-speed, fan-speed,
      # battery-info, voltage-info, system-load, process-count
      display-order = "cpu-usage,memory-usage,network-speed,storage-usage,cpu-temperature,fan-speed";

      # Sensors to show (boolean flags)
      show-cpu-usage = true;
      show-memory-usage = true;
      show-swap-usage = true;
      show-network-speed = true;
      show-storage-usage = true; # Shows usage for specified partitions
      show-temperature = true;  # Requires working sensors (lm_sensors often needed)
      show-voltage = true;      # Requires working sensors
      show-fan = true;          # Requires working sensors
      show-battery = true;
      show-system-load = true;
      show-process-count = true;
      show-frequency = true; # Show CPU frequency

      # Temperature unit ('celsius', 'fahrenheit', 'kelvin')
      temperature-unit = "celsius";

      # Storage partitions to monitor (list of mount points or device paths)
      # Example: show root and home
      storage-paths = [ "/" "/home" ];
      # Example: show specific devices
      # storage-paths = [ "/dev/nvme0n1p2" "/dev/sda1" ];

      # Network configuration
      network-interfaces = [ ]; # Empty array usually means 'monitor all active'
      # Or specify like: network-interfaces = [ "enp3s0" "wlp4s0" ];
      network-speed-unit = "B"; # 'B' (Bytes), 'b' (bits)
      show-total-network-speed = false; # Sum speed across interfaces

      # Appearance
      use-compact-layout = false;
      show-sensor-icons = true;
      show-sensor-labels = true; # Show text like 'CPU', 'MEM'

      # Font size adjustment (0 = default, negative = smaller, positive = larger)
      font-size-offset = 0;

      # --- Add other Vitals settings as needed ---
      # You can find more keys by:
      # 1. Installing Vitals and using its Preferences dialog.
      # 2. Using dconf-editor and navigating to /org/gnome/shell/extensions/vitals/
      # 3. Running `gsettings list-recursively org.gnome.shell.extensions.vitals` in the terminal
      #    (after installing the extension at least once).
    };

    # --- You can add settings for other extensions or GNOME components here ---
    # "org/gnome/shell/extensions/dash-to-dock" = { ... };
    # "org/gnome/desktop/interface" = { ... };

  }; # End dconf.settings

  # --- Optional: System-level dependencies (might be needed for sensors) ---
  # While this is home-manager, if Vitals needs system tools like lm_sensors
  # for temperature/fan readings, those need to be configured in your main
  # /etc/nixos/configuration.nix:
  #
  # hardware.sensor.lmSensors.enable = true;
  # services.udev.enable = true; # Usually enabled by default with GNOME


}