flatpak
```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

aliases
```
alias code="flatpak run com.visualstudio.code"
alias rb="sudo nixos-rebuild switch"
alias g="git"
```
gitaliases

cleanup 
```
sudo nix-collect-garbage --delete-older-than 30d
sudo nixos-rebuild boot — upgrade
flatpak update -y

sudo nix-collect-garbage -d
```


To remove all but the most recent boot entry run: 

```
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system 
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

Test
```
docker run --rm --runtime=nvidia --device nvidia.com/gpu=all ubuntu nvidia-smi
docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
```

generate hardware config

```
sudo nixos-generate-config --show-hardware-config > ~/nixos-config/hardware-configuration.nix
```

nix flake update
sudo nixos-rebuild switch --flake .#asus