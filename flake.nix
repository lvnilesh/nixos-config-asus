{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # Or "nixos-24.11", etc.

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {

      asus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Or "aarch64-linux", etc.
        specialArgs = { inherit inputs; }; # Pass inputs down to modules
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true; # Use system nixpkgs by default
              useUserPackages = true; # Allow users to manage packages
              users.cloudgenius = import ./home.nix; # Import user-specific config
              # extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };

      # nuc = nixpkgs.lib.nixosSystem { ... };
    };

    # You could also define packages, devShells, etc. here if desired
  };
}