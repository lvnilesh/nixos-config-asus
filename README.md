flatpak
```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak uninstall com.visualstudio.code

flatpak uninstall --unused
```

aliases
```
# alias code="flatpak run com.visualstudio.code"
alias rb="sudo nixos-rebuild switch"
alias arb="sudo nixos-rebuild switch --flake .#asus"
alias g="git"
```

cleanup 
```
flatpak update -y

sudo nixos-rebuild boot --upgrade
sudo nixos-rebuild switch

sudo nix-collect-garbage -d

sudo nix-collect-garbage --delete-older-than 30d

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

docker info | grep -i nvidia
nvidia-ctk --version
nvidia-container-cli --version
sudo systemctl restart docker

docker run --rm --gpus all alpine sh -c "ls -la /dev | grep nvidia"


podman run --rm --gpus all docker.io/nvidia/cuda:12.8.0-base-ubuntu22.04 nvidia-smi
docker run --rm --gpus all docker.io/nvidia/cuda:12.8.0-base-ubuntu22.04 nvidia-smi

docker run --rm --gpus all nvidia/cuda:12.8.0-base-ubuntu22.04 \
  bash -c "apt-get update && apt-get install -y wget build-essential unzip && \
           wget https://github.com/NVIDIA/cuda-samples/archive/refs/tags/v12.3.zip && \
           unzip v12.3.zip && cd cuda-samples-12.3/Samples/1_Utilities/deviceQuery && \
           make && ./deviceQuery"

docker run --rm --gpus all --security-opt=label=disable nvidia/cuda:12.8.0-devel-ubuntu22.04 \
  bash -c "nvidia-smi && nvcc --version"

           

docker run --rm --gpus all tensorflow/tensorflow:latest-gpu \
  python -c "import tensorflow as tf; print('Num GPUs Available: ', len(tf.config.list_physical_devices('GPU')), '\nGPU Details:', tf.config.list_physical_devices('GPU'))"

docker run --rm --gpus all nvidia/cuda:12.8.0-base-ubuntu22.04 \
  bash -c "env | grep -i nvidia"

docker run --rm --gpus all pytorch/pytorch:latest \
  python -c "import torch; print('CUDA available:', torch.cuda.is_available(), '\nNumber of GPUs:', torch.cuda.device_count(), '\nCurrent device:', torch.cuda.current_device(), '\nDevice name:', torch.cuda.get_device_name(0))"


```

generate hardware config

```
sudo nixos-generate-config --show-hardware-config > ~/nixos-config/hardware-configuration.nix
```

update
```
nix flake update

# or update only nixpkgs
nix flake lock --update-input nixpkgs

# Or update home-manager
nix flake lock --update-input home-manager

sudo nixos-rebuild switch --flake .#asus
```

TODO
```
gitaliases
```