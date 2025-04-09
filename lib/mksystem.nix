{ nixpkgs, overlays, inputs }:

name: { 
  system, 
  user, 
  darwin ? false 
}:

let
  isDarwin = darwin;
  
  # Choose between nixosSystem and darwinSystem
  systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem;
  
  # set config files for this system
  machineConfig = ./machines/${name}.nix;
  userOSConfig = ./users/${user}/${if isDarwin then "darwin" else "nixos"}.nix;
  userHMConfig = ./users/${user}/home-manager.nix;
  
  home-manager = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
in systemFunc rec {

  inherit system;
  modules = [

    # apply overlays globally
    { nixpkgs.overlays = overlays; }

    # allow unfree pkgs
    { nixpkgs.config.allowUnfree = true; }
    
    # machine-specific configuration
    machineConfig
    
    # OS-specific per-user configuration
    userOSConfig
    
    # home manager configuration for the user
    home-manager.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import userHMConfig { inherit inputs; };
    }

    # expose some parameters to downstream modules if needed
    {
      config._module.args = {
        currentSystemName = name;
        currentUser = user;
        isDarwin = isDarwin;
        inputs = inputs;
      };
    }

  ];

}

