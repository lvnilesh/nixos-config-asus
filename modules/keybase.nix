{
  config,
  pkgs,
  ...
}: {
  # Your existing configuration...

  # Add Keybase service
  services.keybase = {
    enable = true;
  };

  # Also enable KBFS (Keybase File System) if you need it
  services.kbfs = {
    enable = true;
    mountPoint = "/run/user/1000/keybase"; # Default mount point
  };

  # Set this to ensure proper user permissions
  users.users.cloudgenius = {
    packages = with pkgs; [keybase keybase-gui];
    extraGroups = ["keybase"];
  };

  # Create a keybase group if it doesn't exist
  users.groups.keybase = {};

  # Add the Keybase package
  environment.systemPackages = with pkgs; [
    keybase
    keybase-gui # Optional: include if you want the GUI
  ];
}
