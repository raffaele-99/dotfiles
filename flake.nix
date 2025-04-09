{
  description = "Unified configs for both NixOS and macOS";

  inputs = {
    nixpkgs.url = "nixpkgs";
    darwin.url = "github:lnl7/nix-darwin";
  };

  outputs = { self, nixpkgs, darwin, ... }:
    let
      systemNixOS = "aarch64-linux";    # or aarch64-linux
      systemDarwin = "aarch64-darwin"; # or aarch64-darwin
    in {
      # For NixOS
      nixosConfigurations.nixosHost = nixpkgs.lib.nixosSystem {
        system = systemNixOS;
        modules = [
          ./nix/nixos/configuration.nix
          ./nix/nixos/hardware-configuration.nix
        ];
      };

      # For macOS
      darwinConfigurations.macHost = darwin.lib.darwinSystem {
        system = systemDarwin;
        modules = [
          ./nix/darwin/nix/darwin-flake.nix
          # any other darwin modules
        ];
      };
    };
}

