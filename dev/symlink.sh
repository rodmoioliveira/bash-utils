#!/usr/bin/env bash

readonly SCRIPTS=($(fd . -e sh scripts | awk -F'/' '{print $2}'))
for script in "${SCRIPTS[@]}"; do
    program=$(echo "$script" | sd '\.sh$' "")
    dir=/usr/local/bin/"$program"
    printf 1>&2 "Installing %s in %s ...\n" "$program" "$dir"
    sudo ln -s -f "$(pwd)"/scripts/"$script" "$dir"
done

printf 1>&2 "Done!\n"
