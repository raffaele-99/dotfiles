{
  description = "Unified configs for both NixOS and macOS";

  inputs = {
    nixpkgs.url = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
    let
      systemNixOS = "aarch64-linux";    # or aarch64-linux
      systemDarwin = "aarch64-darwin"; # or aarch64-darwin
    in {
      # For NixOS
      nixosConfigurations.nixosHost = nixpkgs.lib.nixosSystem {
        system = systemNixOS;
        modules = [
	  home-manager.nixosModules.home-manager
          ./nix/nixos/configuration.nix
        ];
      };

      # For macOS
      darwinConfigurations.macHost = darwin.lib.darwinSystem {
        system = systemDarwin;
        modules = [
          ./nix/darwin/darwin.nix
        ];
      };
    };
}

