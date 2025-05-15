function oscp
    set -l path "$NAVI_PATH/personal/pen200"
    navi --path $path --print | perl -0777 -pe 'chop' | pbcopy
end
