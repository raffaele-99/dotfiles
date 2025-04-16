#!/run/current-system/sw/bin/fish

# not an actual setup script yet

if not set -q LUCA_CONTENT_DIR
	echo "set LUCA_CONTENT_DIR globally before running"
	exit
end


# handle fish functions
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

# put any other necessary setup tasks here
function set_env_vars
	set -Ux NAVI_CONFIG "$HOME/dotfiles/navi/config.yaml"
	set -Ux LUCA_DOTFILES_DIR "$HOME/dotfiles"
	set -Ux LUCA_NIX_DIR "$LUCA_DOTFILES_DIR/nix"
end

# define what actual setup is
function do_all

	make_symlinks_for_fish_functions
	
	get-semgrep-rules $LUCA_CONTENT_DIR
	get-bearer-rules $LUCA_CONTENT_DIR
	

end

# erase symlink function so it doesnt persist
function erase_all
	functions -e make_symlinks_for_fish_functions
end

# actually run setup now
do_all
erase_all
set_env_vars

if test (uname) = "Darwin"
	set -Ux LUCA_HOST_TYPE "macHost"
	darwin-rebuild switch --flake $HOME/dotfiles#macHost
else
	set -Ux LUCA_HOST_TYPE "nixosHost"
	sudo nixos-rebuild switch --flake $HOME/dotfiles#nixosHost
end
