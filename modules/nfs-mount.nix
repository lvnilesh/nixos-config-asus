# Add this to your NixOS configuration file (usually /etc/nixos/configuration.nix)
{
  config,
  pkgs,
  ...
}: {
  boot.supportedFilesystems = ["nfs"];
  services.rpcbind.enable = true; # needed for NFS

  # Use built-in NixOS NFS client configuration options
  services.nfs.server.enable = false; # We don't need the server

  # Custom ID mapping script
  system.activationScripts.nfsIdmap = {
    text = ''
            mkdir -p /etc/nfs
            cat > /etc/nfs/idmap.conf <<EOF
      # Static mapping for Mac UID 501 -> NixOS UID 1000
      501 1000
      # Static mapping for Mac GID 20 -> NixOS GID 100
      20 100
      EOF
    '';
    deps = [];
  };

  fileSystems."/mnt/x" = {
    device = "truenas.cg.home.arpa:/mnt/tank/nfs";
    fsType = "nfs";
    options = [
      "vers=4.2"
      "noatime"
      # "noauto"
      "_netdev"
      "nofail"
      "rw"
    ];
  };
}
