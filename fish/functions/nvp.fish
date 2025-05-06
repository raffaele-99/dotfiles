function nvp
    navi --path $NAVI_PATH/personal/luca --print | perl -0777 -pe 'chop' | pbcopy
end
