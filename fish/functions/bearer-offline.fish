function bearer-offline
	bearer scan $argv --disable-default-rules --external-rule-dir=$HOME/.luca/bearer/bearer-rules/rules
end
