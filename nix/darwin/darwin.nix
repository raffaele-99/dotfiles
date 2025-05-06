{ config, pkgs, lib, ... }:

{

  environment.etc."proxychains.conf".text = ''
  [ProxyList]
  http    127.0.0.1       3128
  '';

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
    feroxbuster
    mitmproxy
    navi
    wget
    docker
    gh
    hugo
    awscli2
    _1password-cli
    glow
    semgrep
    freerdp
  ];

  nix.settings.experimental-features = "nix-command flakes";

  programs.fish.enable = true;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Set Git commit hash for darwin-version, or remove if not needed
  system.configurationRevision = null;

  # Used for backwards compatibility.
  system.stateVersion = 5;

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # macOS user accounts
  users.knownUsers = [ "luca" ];
  users.users.luca.uid = 501;
  users.users.luca.shell = pkgs.fish;
  users.users.luca.home = "/Users/luca";

  # macOS system defaults
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
    screencapture.location = "~/Pictures/screenshots";
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  # Homebrew configuration
  homebrew = {
    enable = true;
    brews = [
      "mas"
      "openjdk@11"
      "glow"
      "semgrep"
    ];
    casks = [
      "the-unarchiver"
      "burp-suite-professional"
      "ghostty"
    ];
    masApps = {};
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Copy each installed app from /nix/store to /Applications/Nix Apps
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
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
}

