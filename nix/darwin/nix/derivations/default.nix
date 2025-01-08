{ pkgs ? import <nixpkgs> {} }:
let
  script = ''
    #!/usr/bin/env bash
    if system_profiler SPDisplaysDataType | grep -q "LS49C95xU"; then
      defaults write com.apple.dock orientation left
      killall Dock
    else
      echo "Display not found."
    fi
  '';
in
pkgs.stdenv.mkDerivation {
  name = "dock-orientation-switch";
  src = ./.;
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
    echo "${script}" > $out/bin/dock-orientation-switch
    chmod +x $out/bin/dock-orientation-switch
  '';
}
