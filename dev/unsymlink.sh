#!/usr/bin/env bash

readonly SCRIPTS=($(fd . -e sh scripts | awk -F'/' '{print $2}'))
for script in "${SCRIPTS[@]}"; do
    program=$(echo "$script" | sd '\.sh$' "")
    dir=/usr/local/bin/"$program"
    printf 1>&2 "Uninstalling %s from %s ...\n" "$program" "$dir"
    sudo rm "$dir"
done

printf 1>&2 "Done!\n"
