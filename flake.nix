{
  description = "Unified config for NixOS and Darwin systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, darwin, home-manager, ... }:
    let
      overlays = []; # Add any overlays here if needed.
      mksystem = import ./lib/mksystem.nix { inherit nixpkgs overlays inputs; };
    in {
      darwinConfigurations.macbook = mksystem "macbook" {
        system = "aarch64-darwin";
        user = "luca";
        darwin = true;
      };

      nixosConfigurations.vm-aarch64-parallels = mksystem "vm-aarch64-parallels" {
        system = "aarch64-linux";
        user = "luca";
      };

      nixosConfigurations.framework = mksystem "framework" {
        system = "x86_64-linux";
        user = "luca";
      };
    };
}

