function nvw
    navi --path $NAVI_PATH/work --print | perl -0777 -pe 'chop' | pbcopy
end
