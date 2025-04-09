function bearer-offline
	bearer scan --disable-default-rules --external-rule-dir=$HOME/.luca/bearer/bearer-rules/rules $argv
end
