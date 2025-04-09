function get-semgrep-rules
	set -l dir $argv/semgrep
	set -l dest $dir/default.yml

	mkdir -p $dir

	curl -sS https://semgrep.dev/c/p/default > $dest && echo "semgrep rules saved at $dest"; or echo "error getting semgrep rules"
end
