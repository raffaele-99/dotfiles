function semgrep-offline
	semgrep --config $LUCA_CONTENT_DIR/semgrep/default.yml --disable-version-check --metrics off $argv
end
