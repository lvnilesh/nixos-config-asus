{
  pkgs,
  config,
  ...
}: {
  # Ensure nvidia-docker compatibility
  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
    runc
    libnvidia-container
  ];

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    # enableNvidia = true;
    # Enable support for the NVIDIA Container Runtime -> GPU access
    # KEEP THIS FOR NOW. https://github.com/NixOS/nixpkgs/issues/363505
    daemon.settings = {
      # Enable CDI support
      features = {
        cdi = true;
      };
    };
  };

  hardware.nvidia-container-toolkit.enable = true;
  # Despite that, GPU support in containers wont work without # virtualisation.docker.enableNvidia = true;
  # docker run --rm --runtime=nvidia --device nvidia.com/gpu=all ubuntu nvidia-smi
  # docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
}
