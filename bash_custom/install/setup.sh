# for macOS

# install xcode command line tools
# xcode-select --install


# Install nix using determinate systems installer (has flakes enabled by default)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Install nix-darwin
nix run nix-darwin -- switch --flake ~/.dotfiles/nix/darwin/nix/flake.nix\#tantobook


# Darwin rebuild
# darwin-rebuild switch --flake ~/nix.\#simple
