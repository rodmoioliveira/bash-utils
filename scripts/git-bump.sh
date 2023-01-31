#!/usr/bin/env bash

#########################################################################
##
## TITLE:         git-bump.sh
## AUTHOR:        Rodolfo Mói de Oliveira
## DESCRIPTION:   Bumps the current tag version to the next version
## DATE:          27. Jan. 2023
## LICENSE:       MIT
##
#########################################################################

set -eo pipefail

usage_short() {
    HELP_TEXT=$(
        cat <<"EOF"
Bumps the current tag version to the next version

Usage:
  git-bump [OPTIONS] --level <RELEASE_LEVEL>

Arguments:
  -l, --level <RELEASE_LEVEL>  The release level to bump the current version tag to [possible values: patch, minor, major]

Options:
  -m, --message <MESSAGE>      Optional tag message
  -d, --dry-run                Prints the next version without committing anything
  -h, --help                   Print help information (use `--help` for more detail)

Examples:
  git-bump -l patch -m "patch version"
  git-bump -l minor -d
  git-bump -l major
EOF
    )

    printf 1>&2 "%s\n" "$HELP_TEXT"
}

usage_long() {
    HELP_TEXT=$(
        cat <<"EOF"
Bumps the current tag version to the next version

Usage:
  git-bump [OPTIONS] --level <RELEASE_LEVEL>

Arguments:
  -l, --level <RELEASE_LEVEL>
          The release level to bump the current version tag to [possible values: patch, minor, major]

Options:
  -m, --message <MESSAGE>
          Optional tag message

  -d, --dry-run
          Prints the next version without committing anything

  -h, --help
          Print help information (use `-h` for a summary)

Examples:
  git-bump -l patch -m "patch version"
  git-bump -l minor -d
  git-bump -l major
EOF
    )

    printf 1>&2 "%s\n" "$HELP_TEXT"
}

parse_args() {
    if ! ARGS=$(getopt -a -n git-bump -o hdl:m: --long dry-run,help,level:,message: -- "$@"); then
        printf 1>&2 "\nFor more information try '--help'\n"
        exit 1
    fi
    eval set -- "$ARGS"

    while [ $# -gt 0 ]; do
        case "$1" in
        -h)
            usage_short
            exit 0
            ;;
        --help)
            usage_long
            exit 0
            ;;
        -l | --level)
            shift
            readonly RELEASE_LEVEL=$1
            ;;
        -m | --message)
            shift
            readonly MESSAGE=$1
            ;;
        -d | --dry-run)
            readonly DRY_RUN=true
            ;;
        --)
            shift
            break
            ;;
        *) usage_long ;;
        esac
        shift
    done
}

error_flag_level() {
    printf 1>&2 "git-bump: '%s' isn't a valid value for '--level <RELEASE_LEVEL>'\n" "$RELEASE_LEVEL"
    printf 1>&2 "  [possible values: patch, minor, major]\n\n"
    printf 1>&2 "For more information try '--help'\n"
    exit 1
}

error_not_git_dir() {
    printf 1>&2 "%s is not a git repository\n" "$(pwd)"
    exit 1
}

error_no_tags() {
    printf 1>&2 "%s repo doesn't have any tag\n\n" "$(pwd)"
    printf 1>&2 "You can create one like this:\n"
    printf 1>&2 "git tag -a 0.1.0 -m \"version 0.1.0\"\n"
    exit 1
}

validate_args() {
    if [[ -z $RELEASE_LEVEL ]]; then
        error_flag_level
    fi
}

is_git_dir() {
    readonly IS_GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)

    if [[ -n $IS_GIT_DIR ]]; then
        readonly CURRENT_VERSION=$(git tag -l | tail -n1)
    else
        error_not_git_dir
    fi
}

get_current_version() {
    if [[ -z $CURRENT_VERSION ]]; then
        error_no_tags
    fi
}

check_semver() {
    case $RELEASE_LEVEL in
    "patch") ;;
    "minor") ;;
    "major") ;;
    *)
        error_flag_level
        ;;
    esac
}

get_semver() {
    major=$(echo "$CURRENT_VERSION" | sd '(\d{1,})\.(\d{1,})\.(\d{1,})' '${1}')
    minor=$(echo "$CURRENT_VERSION" | sd '(\d{1,})\.(\d{1,})\.(\d{1,})' '${2}')
    patch=$(echo "$CURRENT_VERSION" | sd '(\d{1,})\.(\d{1,})\.(\d{1,})' '${3}')
}

bump_semver() {
    case $RELEASE_LEVEL in
    "patch")
        patch=$((patch + 1))
        ;;
    "minor")
        minor=$((minor + 1))
        patch=0
        ;;
    "major")
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    esac

    readonly NEXT_VERSION="$major.$minor.$patch"
}

set_next_version() {
    if [[ "$DRY_RUN" == true ]]; then
        printf 1>&2 "Current version is %s\n" "$CURRENT_VERSION"
        printf 1>&2 "Semantic Versioning will be bumped to %s\n" "$NEXT_VERSION"
        printf "%s\n" "$NEXT_VERSION"
        exit 0
    fi

    if [[ -z "$MESSAGE" ]]; then
        git tag -a "$NEXT_VERSION" -m "version $NEXT_VERSION" && confirm
    else
        git tag -a "$NEXT_VERSION" -m "$MESSAGE" && confirm
    fi
}

confirm() {
    printf 1>&2 "Last version was %s\n" "$CURRENT_VERSION"
    printf 1>&2 "Current version now is %s\n" "$NEXT_VERSION"
    printf "%s\n" "$NEXT_VERSION"
    exit 0
}

main() {
    parse_args "$@"
    validate_args
    check_semver
    is_git_dir
    get_current_version
    get_semver
    bump_semver
    set_next_version
}

main "$@"
