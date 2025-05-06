#!/run/current-system/sw/bin/zsh
# System maintenance and garbage collection

# Update flatpaks
flatpak update -y
flatpak uninstall --unused

# Update NixOS
sudo nixos-rebuild boot --upgrade
sudo nixos-rebuild switch

# Clean up Nix store
sudo nix-collect-garbage -d
sudo nix-collect-garbage --delete-older-than 30d

# Clean up boot entries
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch

echo "System maintenance completed!"