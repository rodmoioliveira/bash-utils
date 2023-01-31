#!/usr/bin/env bash

source './tests/assert.sh'

mktempdir() {
    if ! tmp_dir=$(mktemp -d -t bash-utils-tests-XXXXXXXXXX); then
        printf 1>&2 "Couldn't create %s\n" "$tmp_dir"
        exit 1
    fi

    cd "$tmp_dir" || exit 1
    printf 1>&2 "%s\n" "$tmp_dir"
}

git_init() {
    git init
    echo "test" >test.txt
    git config --local user.email "rodmoi.oliveira@gmail.com" && git config --local user.name "Rodolfo Mói de Oliveira"
    git add -A && git commit -m "first commit"
    git tag -a 0.1.0 -m "version 0.1.0"
}

assertions() {
    git-bump 2>/dev/null
    exit_st=$?
    if ! assert_eq 0 "$exit_st" "Exit code status should be 1 for command git-bump"; then exit 1; fi

    git-bump -dl patch 2>/dev/null
    exit_st=$?
    if ! assert_eq 1 "$exit_st" "Exit code status should be 1 for command git-bump -dl patch"; then exit 1; fi

    git-bump -l x 2>/dev/null
    exit_st=$?
    if ! assert_eq 1 "$exit_st" "Exit code status should be 1 for command git-bump -l x"; then exit 1; fi

    git-bump -dhl patc 2>/dev/null
    exit_st=$?
    if ! assert_eq 0 "$exit_st" "Exit code status should be 0 for command  git-bump -dhl patc"; then exit 1; fi

    git-bump -dlh patc 2>/dev/null
    exit_st=$?
    if ! assert_eq 1 "$exit_st" "Exit code status should be 1 for command  git-bump -dlh patc"; then exit 1; fi

    git_init
    if ! assert_eq "0.1.1" "$(git-bump -dl patch 2>/dev/null)" "Should bump 0.1.0 to 0.1.1 (patch)"; then exit 1; fi
    if ! assert_eq "0.2.0" "$(git-bump -dl minor 2>/dev/null)" "Should bump 0.1.0 to 0.2.0 (minor)"; then exit 1; fi
    if ! assert_eq "1.0.0" "$(git-bump -dl major 2>/dev/null)" "Should bump 0.1.0 to 1.0.0 (major)"; then exit 1; fi
}

test() {
    mktempdir
    assertions
}

test
