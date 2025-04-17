{
  description = "My NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable # nixos-24.05"; # Or "nixos-unstable", etc.

#    home-manager = {
#      url = "github:nix-community/home-manager/release-24.05"; # Make sure Home Manager uses the same nixpkgs revision
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
  };

  outputs = { self, nixpkgs, ... }@inputs: { # removed home-manager

    nixosConfigurations = { # You can define all your systems here 

     asus = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # Or "aarch64-linux", etc.
        specialArgs = { inherit inputs; }; # Pass inputs down to modules
        modules = [
          ./configuration.nix
#          home-manager.nixosModules.home-manager
#          {
#            home-manager = {
#              useGlobalPkgs = true; # Use system nixpkgs by default
#              useUserPackages = true; # Allow users to manage packages
#              users.cloudgenius = import ./home.nix; # Import user-specific config
#              extraSpecialArgs = { inherit inputs; }; # Optional: Set default values shared across users managed by Home Manager
#            };            
#          }
        ];
      };

      # nuc = nixpkgs.lib.nixosSystem { ... };
    };

    # You could also define packages, devShells, etc. here if desired
  };
}