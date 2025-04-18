{ config, pkgs, ... }:

{
  home-manager.users."luca" = { pkgs, ... }:
    {
      home.packages = with pkgs; [
        atool
        httpie
        fish
        firefox
        python314
        rofi
        git
	file
	vscode
	gh
	docker
	go
	navi
	firefox-devedition
	glow
      ];

      home.stateVersion = "24.11";

      nixpkgs.config.allowUnfree = true;

      home.file = {
        ".config/fish/functions/fish_greeting.fish".text = ''
        '';
      };

      programs = {
        fish = {
	  enable = true;
	};
	rofi = {
	  enable = true;
	  terminal = "${pkgs.ghostty}/bin/ghostty";
	  theme = "android_notification";
	};
      };

      programs.i3status.enable = true;

      home.shellAliases = {
        "nrs" = "sudo nixos-rebuild switch";
      };
    };
}
