# for macOS

# first install nix
# sh <(curl -L https://nixos.org/nix/install)

# then clone this repo
# nix-shell -p git --run 'git clone https://github.com/raffaele-99/dotfiles.git ~/dotfiles'

# Install nix-darwin
nix run nix-darwin --extra-experimental-features 'nix-command flakes' -- switch --flake ~/dotfiles/nix/darwin/nix/flake.nix\#tantobook

# Darwin rebuild
# darwin-rebuild switch --flake ~/nix.\#simple
