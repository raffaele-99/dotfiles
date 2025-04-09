function semgrep-offline
	set -l content_name .luca
	set -l content $HOME/$content_name
	set -l rules $content/semgrep/default.yml

	semgrep --config $rules --disable-version-check --metrics off $argv
end
