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
# this goes through each file in the fish/functions directory and creates a symlink to it inside
# $HOME/.config/fish/functions
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
# pull_cheats_repos
# this pulls navi cheats (both work and personal) and saves them to ~/source
function pull_cheats_repos
    set -l personal_dir "$HOME/source/cheats-personal"
    set -l work_dir     "$HOME/source/cheats-work"
    mkdir -p (dirname $personal_dir) (dirname $work_dir)
    if test -d $personal_dir/.git
        git -C $personal_dir pull
    else
        git clone https://github.com/raffaele-99/cheats.git $personal_dir
    end
    if test -d $work_dir/.git
        git -C $work_dir pull
    else
        git clone https://github.com/luca-tanto/cheats.git $work_dir
    end
end

# FUNCTION
# link_navi_cheats
# this creates symlinks in the navi cheats folder that point to ~/source/cheats-(personal/work)
function link_navi_cheats
    set -l navipersonal "$NAVI_PATH/personal"
    set -l naviwork     "$NAVI_PATH/work"
    rm -rf $navipersonal $naviwork
    mkdir -p (dirname $navipersonal) (dirname $naviwork)
    ln -sfn $HOME/source/cheats-personal $navipersonal
    ln -sfn $HOME/source/cheats-work     $naviwork
end

# FUNCTION
# do_setup
# this creates symlinks for your fish functions and then calls some of them to be run during setup
function do_setup
	make_symlinks_for_fish_functions
	get-semgrep-rules $LUCA_CONTENT_DIR
	get-bearer-rules $LUCA_CONTENT_DIR
	pull_cheats_repos
	link_navi_cheats
end

# FUNCTION
# erase_setup_functions
# if there are functions that you dont want to be used outside of this script,
# then delete them here
function erase_setup_functions
	functions -e make_symlinks_for_fish_functions
	functions -e set_env_vars
	functions -e pull_cheats_repos
	functions -e link_navi_cheats
	functions -e do_setup
end

# ------------------------------------------------------------------------------------------- #

set_env_vars
do_setup
erase_setup_functions

# ------------------------------------------------------------------------------------------- #

if test (uname) = "Darwin"
	set -Ux LUCA_HOST_TYPE "macHost"
	darwin-rebuild switch --flake $HOME/dotfiles#macHost
else
	set -Ux LUCA_HOST_TYPE "nixosHost"
	sudo nixos-rebuild switch --flake $HOME/dotfiles#nixosHost
end

# ------------------------------------------------------------------------------------------- #
