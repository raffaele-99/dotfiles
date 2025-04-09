#!/bin/bash

# counts occurrences of each extension in a list of URLs
# useful for quickly seeing if theres any interesting files (mainly .txt)

INFILE=$1

declare -A extension_counts

while IFS= read -r url; do
  if [[ $url =~ (\.[a-zA-Z0-9]+)+(\?.*)?$ ]]; then
    extension="${BASH_REMATCH[0]}"
    ((extension_counts[$extension]++))
  fi
done < "$INFILE"

for ext in "${!extension_counts[@]}"; do
  echo "$ext: ${extension_counts[$ext]}"
done
