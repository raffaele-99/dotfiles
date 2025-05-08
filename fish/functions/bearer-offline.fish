function bearer-offline
	bearer scan $argv --disable-default-rules --external-rule-dir=$LUCA_CONTENT_DIR/bearer/rules
end
