{
  pkgs,
  lib,
  ...
}: {
  services.tailscale = {
    enable = true;
    # authKeyFile = "/etc/nixos/secrets/tailscale-authkey";
    extraUpFlags = [
      "--accept-routes" # Accept routes advertised by other nodes
      "--advertise-exit-node"
      "--advertise-routes=192.168.1.0/24,192.168.20.0/24,192.168.30.0/24,192.168.40.0/24,10.0.0.0/16" # Advertise local subnets
      "--accept-dns=false" # Don't use Tailscale DNS settings
      "--ssh" # Enable Tailscale SSH server on this node
      "--hostname=asus-nix" # Set a specific Tailscale hostname
    ];
  };

  # --- Tailscale exit node ---

  # Enable IP Forwarding
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Configure Firewall (If enabled)
  # If you have networking.firewall.enable = true;, you need to allow
  # traffic from the Tailscale interface and potentially forwarding.
  # Trusting the interface is often the simplest way.
  # networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # sudo tailscale up --advertise-routes=192.168.1.0/24,192.168.20.0/24,192.168.30.0/24,192.168.40.0/24,10.0.0.0/24 --advertise-exit-node
  # Warning: UDP GRO forwarding is suboptimally configured on br0, UDP forwarding throughput capability will increase with a configuration change.
  # See https://tailscale.com/s/ethtool-config-udp-gro
  # Some peers are advertising routes but --accept-routes is false

  systemd.services.ethtool-br0 = {
    description = "Set ethtool options for br0";
    after = ["network.target"];
    wants = ["network.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.ethtool}/bin/ethtool -K br0 rx-udp-gro-forwarding on rx-gro-list off
      '';
    };
    wantedBy = ["multi-user.target"];
  };

  # sudo ethtool -k br0 | grep -E 'rx-udp-gro-forwarding|rx-gro-list'
}
