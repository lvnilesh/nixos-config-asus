# Add this to your NixOS configuration file (usually /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: {
  # Ensure necessary packages are installed
  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  fileSystems."/mnt/backup" = {
    device = "//cosmos.cg.home.arpa/tank_smbshare";
    fsType = "cifs";
    options = [
      "credentials=/home/cloudgenius/.cred"
      "uid=1000"
      "gid=100"
      "forceuid" # Add this to force the use of the specified uid
      "forcegid" # Add this to force the use of the specified gid
      "file_mode=0644" # Default file permissions
      "dir_mode=0755" # Default directory permissions
      # "noauto"
      "_netdev"
      "nofail"
    ];
  };

  fileSystems."/mnt/Recordings" = {
    device = "//truenas.cg.home.arpa/Recordings";
    fsType = "cifs";
    options = [
      "credentials=/home/cloudgenius/.cred"
      "uid=1000"
      "gid=100"
      "forceuid" # Add this to force the use of the specified uid
      "forcegid" # Add this to force the use of the specified gid
      "file_mode=0644" # Default file permissions
      "dir_mode=0755" # Default directory permissions
      # "noauto"
      "_netdev"
      "nofail"
    ];
  };
}
