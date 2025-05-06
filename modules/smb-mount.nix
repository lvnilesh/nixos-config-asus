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
      "uid=${toString config.users.users.cloudgenius.uid}"
      "gid=${toString config.users.groups.users.gid}"
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=60"
      "_netdev"
      "nofail"
    ];
  };

  # # Ensure networking is fully up before attempting mounts
  # systemd.services.mount-backup = {
  #   description = "Mount SMB backup share";
  #   requires = [ "network-online.target" ];
  #   after = [ "network-online.target" ];
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
  #     ExecStart = "${pkgs.util-linux}/bin/mount -t cifs //192.168.1.8/tank_smbshare /mnt/backup -o credentials=/home/cloudgenius/.cred,uid=${toString config.users.users.cloudgenius.uid},gid=${toString config.users.groups.users.gid},sec=ntlmssp,iocharset=utf8,nofail";
  #     ExecStop = "${pkgs.util-linux}/bin/umount /mnt/backup";
  #   };
  # };
}
