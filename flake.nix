{
  description = "My NixOS Flake Configuration";

  # Define external dependencies (inputs)
  inputs = {
    # NixOS package repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # Or "nixos-unstable", etc.

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # Make sure Home Manager uses the same nixpkgs revision
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Define what this flake provides (outputs)
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {

    # Define your NixOS system configuration
    nixosConfigurations = {
      # Replace 'asus' with your actual system's hostname (or any identifier)
      asus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Or "aarch64-linux", etc.
        specialArgs = { inherit inputs; }; # Pass inputs down to modules
        modules = [
          # Your main system configuration file
          ./configuration.nix

          # Home Manager NixOS module
          home-manager.nixosModules.home-manager
          {
            # Configure Home Manager settings
            home-manager.useGlobalPkgs = true; # Use system nixpkgs by default
            home-manager.useUserPackages = true; # Allow users to manage packages
            # Define users you want Home Manager to manage
            home-manager.users.cloudgenius = import ./home.nix; # Import user-specific config

            # Optional: Set default values shared across users managed by Home Manager
            # home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

      # You can define more systems here if needed
      # another-hostname = nixpkgs.lib.nixosSystem { ... };
    };

    # You could also define packages, devShells, etc. here if desired
  };
}