{
  pkgs,
  lib,
  ...
}: {
  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true;
  };

  networking.networkmanager.unmanaged = ["interface-name:eno1" "interface-name:br0"];

  networking.useDHCP = false; # Optional: Disable top-level DHCP if you configure all interfaces explicitly
  networking.interfaces.eno1 = {
    # Do NOT configure useDHCP or IP addresses here
    # This interface will be managed by the bridge
    # You might need specific L2 settings here eventually, but usually not.
  };

  networking.interfaces.br0 = {
    useDHCP = true; # Get IP address for the bridge interface
  };

  networking.bridges."br0" = {
    interfaces = ["eno1"]; # Add eno1 to the bridge
    # Optional: You might want to set bridge priority, STP, etc. here if needed
    # settings = {
    #   ForwardDelay = 4;
    #   StpEnable = true;
    # };
  };
}
