#!/bin/bash

usage() {
    echo "Usage: $0 <feroxbuster-json-output> [options]..."
    echo "Retrieves URLs from feroxbuster's JSON output."
    echo ""
    echo "Options:"
    echo "  -s      Status code to extract. Supports 200 or 301. Defaults to 200 if not specified."
    exit 1
}

STATUS_CODE=200
INFILE=""

parse_args() {
    while getopts "s:" opt; do
        case $opt in
            s)
                STATUS_CODE=$OPTARG
                ;;
            \?)
                usage
                ;;
        esac
    done

    shift $((OPTIND - 1))

    if [ -z "$1" ]; then
        usage
    else
        INFILE=$1
    fi
}

sort_file() {
    sort "$1" | uniq
}

parse_args "$@"

if [[ $STATUS_CODE -eq 200 ]]; then
    jq -r 'select(.status == 200) | .url' "$INFILE" > ferox-temp
elif [[ $STATUS_CODE -eq 301 ]]; then
    jq -r 'select(.status == 301) | [.url, .headers.location] | join(" -> ")' "$INFILE" > ferox-temp
else
    echo "Unsupported status code. Only 200 and 301 are supported."
    exit 1
fi

sort_file ferox-temp
rm ferox-temp
