#!/run/current-system/sw/bin/fish

# not an actual setup script yet

if not set -q CONTENT_DIR
	echo "set CONTENT_DIR globally before running"
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

# ...

# define what actual setup is
function do_all

	make_symlinks_for_fish_functions
	
	get-semgrep-rules $CONTENT_DIR
	get-bearer-rules $CONTENT_DIR
	

end

# erase symlink function so it doesnt persist
function erase_all
	functions -e make_symlinks_for_fish_functions
end

# actually run setup now
do_all
erase_all
