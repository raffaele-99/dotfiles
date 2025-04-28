#!/run/current-system/sw/bin/fish

# ------------------------------------------------------------------------------------------- #

# do not run this script if a custom content directory hasnt been defined
if not set -q LUCA_CONTENT_DIR
	echo "set LUCA_CONTENT_DIR globally before running: set -Ux LUCA_CONTENT_DIR <directory>"
	exit
end

# ------------------------------------------------------------------------------------------- #

# FUNCTION
# make_symlinks_for_fish_functions
# this goes through each file in the fish/functions directory and creates a symlink to it inside $HOME/.config/fish/functions
function make_symlinks_for_fish_functions
	set -l src "$HOME/dotfiles/fish/functions"
	set -l dest "$HOME/.config/fish/functions"

	if not test -d $dest
		mkdir -p $dest
	end

	for file in $src/*
		set -l name (basename $file)
		ln -sfn $file "$dest/$name"
	end
end

# FUNCTION
# set_env_vars
# this sets various environment variables that are used by some tools
function set_env_vars
	set -Ux NAVI_CONFIG "$HOME/dotfiles/navi/config.yaml"
	set -Ux LUCA_DOTFILES_DIR "$HOME/dotfiles"
	set -Ux LUCA_NIX_DIR "$LUCA_DOTFILES_DIR/nix"
	set -Ux NAVI_PATH "$HOME/.local/share/navi/cheats"
end

# FUNCTION
# do_setup
# this creates symlinks for your fish functions and then calls some of them to be run during setup
function do_setup
	make_symlinks_for_fish_functions
	get-semgrep-rules $LUCA_CONTENT_DIR
	get-bearer-rules $LUCA_CONTENT_DIR
end

# FUNCTION
# erase_setup_functions
# if there are functions that you dont want to be used outside of this script,
# then delete them here
function erase_setup_functions
	functions -e make_symlinks_for_fish_functions
	functions -e do_setup
	functions -e set_env_vars
end

# ------------------------------------------------------------------------------------------- #

set_env_vars
do_setup
erase_setup_functions

# ------------------------------------------------------------------------------------------- #

rm -rf $NAVI_PATH/personal
rm -rf $NAVI_PATH/work

git clone https://github.com/raffaele-99/cheats.git $NAVI_PATH/personal
git clone https://github.com/luca-tanto/cheats.git $NAVI_PATH/work

# ------------------------------------------------------------------------------------------- #

if test (uname) = "Darwin"
	set -Ux LUCA_HOST_TYPE "macHost"
	darwin-rebuild switch --flake $HOME/dotfiles#macHost
else
	set -Ux LUCA_HOST_TYPE "nixosHost"
	sudo nixos-rebuild switch --flake $HOME/dotfiles#nixosHost
end

# ------------------------------------------------------------------------------------------- #