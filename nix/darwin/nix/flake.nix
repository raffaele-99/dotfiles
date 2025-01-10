{
  description = "Test nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager }:
  let
    configuration = { pkgs, config, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.neovim
          pkgs.mkalias
          pkgs.rectangle
          pkgs.tmux
          pkgs.iterm2
          pkgs.obsidian
          pkgs.netcat
          pkgs.nmap
          pkgs.masscan
          pkgs.gobuster
          pkgs.ffuf
          pkgs.zsh
          pkgs.go
          pkgs.slack
          pkgs.thunderbird
          pkgs.tree
          pkgs.jq
          pkgs.yq
          pkgs.python314
          pkgs.semgrep
          pkgs.wpscan
          pkgs.wget
          # pkgs._1password
          # pkgs._1password-gui
          pkgs.hidden-bar
          ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

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
      users.users.luca.shell = pkgs.zsh;

      # macOS system configuration
      system.defaults = {
        dock.mru-spaces = false;
        dock.orientation = "bottom";
        dock.autohide = false;
        dock.persistent-apps = [
          "/Applications/Arc.app"
            "${pkgs.slack}/Applications/Slack.app"
            "${pkgs.thunderbird}/Applications/Thunderbird.app"
            "/Applications/Burp Suite Professional.app"
          "/Applications/Firefox Developer Edition.app"
          "/System/Applications/Calendar.app" 
          "${pkgs.iterm2}/Applications/iTerm2.app"
        ];
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.LoginwindowText = ".";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.KeyRepeat = 2;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        screencapture.location = "~/Pictures/screenshots";
      };
      security.pam.enableSudoTouchIdAuth = true;

      homebrew = {
        enable = true;
        brews = [
            "mas"
        ];
        casks = [
          "the-unarchiver"
          "burp-suite-professional"
        ];
        masApps = {
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = 
        [ pkgs.nerd-fonts.jetbrains-mono
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
        # home-manager.backupFileExtension = "backup";

    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
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
          #          home-manager.darwinModules.home-manager {  
          #            home-manager.useGlobalPkgs = true;
          #  home-manager.useUserPackages = true;
          #  home-manager.users.luca = import ./home.nix;
          #   }
      ];
    };
  };
}
