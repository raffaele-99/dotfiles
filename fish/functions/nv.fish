function nv
    set -l base_path "$NAVI_PATH/personal/pen200"
    set -l paths "$base_path/main"

    for arg in $argv
        switch $arg
            case "--powersploit"
                set -a paths "$base_path/powersploit"
            case "--tests"
                set -a paths "$base_path/tests"
        end
    end


    set -l joined_paths (string join ":" $paths)

    navi --path $joined_paths --print | perl -0777 -pe 'chop'
end
