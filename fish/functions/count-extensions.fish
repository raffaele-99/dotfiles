function count-extensions -d "Counts occurrences of each extension in a list of URLs"
    set infile $argv[1]
    if not test -f $infile
        echo "File $infile does not exist."
        return 1
    end

    # Arrays to simulate an associative array
    set -l exts
    set -l counts

    for url in (cat $infile)
        # Extract extension with grep; adapt regex if needed
        set ext (echo $url | grep -Eo '(\.[a-zA-Z0-9]+)+(\?.*)?$')
        if test -n "$ext"
            # Check if extension already exists in exts
            set found 0
            for i in (seq (count $exts))
                if test "$exts[$i]" = "$ext"
                    set counts[$i] (math $counts[$i] + 1)
                    set found 1
                    break
                end
            end
            if test $found -eq 0
                set exts $exts $ext
                set counts $counts 1
            end
        end
    end

    # Output the counts
    for i in (seq (count $exts))
        echo "$exts[$i]: $counts[$i]"
    end
end

