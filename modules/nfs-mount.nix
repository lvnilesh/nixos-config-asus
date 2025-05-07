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

  fileSystems = let
    commonOptions = [
      "vers=4.2"
      "noatime"
      # "noauto"
      "_netdev"
      "nofail"
      "rw"
    ];
  in {
    "/mnt/nfs" = {
      device = "truenas.cg.home.arpa:/mnt/tank/nfs";
      fsType = "nfs";
      options = commonOptions;
    };

    "/mnt/R" = {
      device = "truenas.cg.home.arpa:/mnt/tank/Recordings";
      fsType = "nfs";
      options = commonOptions;
    };

    "/mnt/models" = {
      device = "truenas.cg.home.arpa:/mnt/tank/models";
      fsType = "nfs";
      options = commonOptions;
    };

    "/mnt/Software" = {
      device = "truenas.cg.home.arpa:/mnt/tank/Software";
      fsType = "nfs";
      options = commonOptions;
    };

    "/mnt/source" = {
      device = "truenas.cg.home.arpa:/mnt/tank/source";
      fsType = "nfs";
      options = commonOptions;
    };
  };
}
