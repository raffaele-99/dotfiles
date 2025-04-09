{ config, pkgs, lib, ... }:

{
  system.stateVersion = 5;

  nix = {    
    settings.experimental-features = "nix-command flakes";
  };

  system.defaults = {
    dock.mru-spaces = false;
    dock.orientation = "bottom";
    dock.autohide = false;
    finder.AppleShowAllExtension = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  environment.shells = with pkgs; [ bashInteractive zsh fish ];

};

