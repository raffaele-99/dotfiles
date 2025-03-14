{
  description = "Test nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {
      environment.systemPackages = with pkgs; [ 
          neovim
          mkalias
          rectangle
          tmux
          obsidian
          netcat
          nmap
          masscan
          gobuster
          ffuf
          zsh
          go
          fish
          tree
          jq
          yq
          python314
          # semgrep
          navi
          wget
          hidden-bar
          docker
          gh
          exiftool
          hugo
        ];


      nix.settings.experimental-features = "nix-command flakes";

      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Allow unfree packages.
      nixpkgs.config.allowUnfree = true;

      # Set zsh as the default shell.
      users.knownUsers = [ "luca" ];
      users.users.luca.uid = 501;
      users.users.luca.shell = pkgs.fish;

      # macOS system configuration
      system.defaults = {
        dock.mru-spaces = false;
        dock.orientation = "bottom";
        dock.autohide = false;
        dock.persistent-apps = [
          "/Applications/Arc.app" 
          "/Applications/Burp Suite Professional.app"
          "/Applications/Firefox Developer Edition.app"
          "/Applications/Ghostty.app"
          "/System/Applications/Calendar.app" 
          "/Applications/Slack.app"
        ];
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = ".";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.KeyRepeat = 2;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        screencapture.location = "~/Pictures/screenshots";
      };
      security.pam.services.sudo_local.touchIdAuth = true;

      homebrew = {
        enable = true;
        brews = [
            "mas"
            "openjdk@11"
        ];
        casks = [
          "the-unarchiver"
          "burp-suite-professional" # installing via brew as burp pro on nix is a pain
          "ghostty" # installing via brew as nix version is broken 
        ];
        masApps = {
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [ 
          pkgs.nerd-fonts.jetbrains-mono
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      users.users.luca.home = "/Users/luca";
    };
  in
  {
    darwinConfigurations."tantobook" = nix-darwin.lib.darwinSystem {
      modules = [ 
        configuration 
          nix-homebrew.darwinModules.nix-homebrew {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "luca";
            };
          }
      ];
    };
  };
}
