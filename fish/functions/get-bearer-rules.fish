# retrieves bearer rules from remote and saves them locally to a user-provided directory
# ACCEPTS: directory as input
function get-bearer-rules
	set -l repo "https://github.com/Bearer/bearer-rules.git"
	set -l dest $argv/bearer

	mkdir -p $dest

	if test -d "$dest/.git"
		echo "	bearer rules already present. pulling latest changes instead"
		cd "$dest"
		git pull &> /dev/null
	else
		git clone $repo $dest &> /dev/null
	end

	echo "bearer rules saved at $dest"

end
