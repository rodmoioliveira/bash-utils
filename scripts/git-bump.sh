#!/usr/bin/env bash

#########################################################################
##
## TITLE:         git-bump.sh
## AUTHOR:        Rodolfo Mói de Oliveira
## DESCRIPTION:   Bump the current tag version to the next version
##                accordingly to semantic versioning specifications.
## DATE:          27. Jan. 2023
## LICENSE:       MIT
##
#########################################################################

set -eo pipefail

usage_short() {
    HELP_TEXT=$(
        cat <<"EOF"
Bump the current tag version to the next version accordingly to semantic
versioning specifications.

Usage: git-bump [OPTIONS] --level <RELEASE_LEVEL>

Arguments:
  -l, --level <RELEASE_LEVEL>  The release level to bump tag [possible values: patch, minor, major]

Options:
  -m, --message <MESSAGE>      Optional tag message
  -d, --dry-run                Prints the next version without committing anything
  -h, --help                   Print help information (use `--help` for more detail)

Examples:
  git-bump -l patch -m "version %T"
  git-bump -l minor -d
  git-bump -l major
EOF
    )

    printf 1>&2 "%s\n" "$HELP_TEXT"
}

usage_long() {
    HELP_TEXT=$(
        cat <<"EOF"
Bump the current tag version to the next version accordingly to semantic
versioning specifications

Usage: git-bump [OPTIONS] --level <RELEASE_LEVEL>

Arguments:
  -l, --level <RELEASE_LEVEL>
          The release level to bump tag [possible values: patch, minor, major]

Options:
  -m, --message <MESSAGE>
          Optional tag message

  -d, --dry-run
          Prints the next version without committing anything

  -h, --help
          Print help information (use `-h` for a summary)

Examples:
  git-bump -l patch -m "version %T"
  git-bump -l minor -d
  git-bump -l major
EOF
    )

    printf 1>&2 "%s\n" "$HELP_TEXT"
}

readonly SEMVER_REGEX='^(?P<v>v)?(?P<major>0|[1-9]\d*)\.(?P<minor>0|[1-9]\d*)\.(?P<patch>0|[1-9]\d*)(?:-(?P<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?P<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'

args_parse() {
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

error_release() {
    printf 1>&2 "git-bump: '%s' isn't a valid value for '--level <RELEASE_LEVEL>'\n" "$RELEASE_LEVEL"
    printf 1>&2 "  [possible values: patch, minor, major]\n\n"
    printf 1>&2 "For more information try '--help'\n"
    exit 1
}

error_not_git_dir() {
    printf 1>&2 "%s is not a git repository\n" "$(pwd)"
    exit 1
}

error_no_semver() {
    printf 1>&2 "%s repo doesn't have any tag\n\n" "$(pwd)"
    printf 1>&2 "You can create one like this:\n"
    printf 1>&2 "git tag -a 0.1.0 -m \"version 0.1.0\"\n"
    exit 1
}

error_prerelease_buildmetadata() {
    printf 1>&2 "git-bump: bump fail because tag '%s' has additional info.\n\n" "$CURRENT_VERSION"
    printf 1>&2 "      prerelease: '%s'\n" "$prerelease"
    printf 1>&2 "   buildmetadata: '%s'\n" "$buildmetadata"
    exit 1
}

error_invalid_semver() {
    printf 1>&2 "git-bump: last version '%s' isn't a valid semantic version tag.\n" "$CURRENT_VERSION"
    printf 1>&2 "For more info, visit https://semver.org/\n\n"
    printf 1>&2 "You can rename the tag with:\n"
    printf 1>&2 "git tag new old\n"
    printf 1>&2 "git tag -d old\n"
    exit 1
}

args_validate() {
    if [[ -z $RELEASE_LEVEL && -z $MESSAGE && -z $DRY_RUN ]]; then
        usage_long
        exit 0
    fi

    if [[ -z $RELEASE_LEVEL ]]; then
        error_release
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

semver_get() {
    if [[ -z $CURRENT_VERSION ]]; then
        error_no_semver
    fi
}

release_check() {
    case $RELEASE_LEVEL in
    "patch") ;;
    "minor") ;;
    "major") ;;
    *)
        error_release
        ;;
    esac
}

semver_validate() {
    if ! echo "$CURRENT_VERSION" | rg "$SEMVER_REGEX" >/dev/null; then
        error_invalid_semver
    fi
}

semver_parse() {
    v=$(echo "$CURRENT_VERSION" | sd "$SEMVER_REGEX" '${v}')
    major=$(echo "$CURRENT_VERSION" | sd "$SEMVER_REGEX" '${major}')
    minor=$(echo "$CURRENT_VERSION" | sd "$SEMVER_REGEX" '${minor}')
    patch=$(echo "$CURRENT_VERSION" | sd "$SEMVER_REGEX" '${patch}')
    prerelease=$(echo "$CURRENT_VERSION" | sd "$SEMVER_REGEX" '${prerelease}')
    buildmetadata=$(echo "$CURRENT_VERSION" | sd "$SEMVER_REGEX" '${buildmetadata}')

    if [[ -n $prerelease || -n $buildmetadata ]]; then
        error_prerelease_buildmetadata
    fi
}

semver_bump() {
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

    readonly NEXT_VERSION="$v$major.$minor.$patch"
}

semver_next() {
    if [[ "$DRY_RUN" == true ]]; then
        printf 1>&2 "Current version is %s\n" "$CURRENT_VERSION"
        printf 1>&2 "Semantic version will be bumped to %s\n" "$NEXT_VERSION"
        printf "%s\n" "$NEXT_VERSION"
        exit 0
    fi

    if [[ -z "$MESSAGE" ]]; then
        git tag -a "$NEXT_VERSION" -m "version $NEXT_VERSION" && confirm
    else
        str="$MESSAGE"
        substr="%T"

        if [[ $str == *"$substr"* ]]; then
            message_template=$(echo "$MESSAGE" | sd '%T' "%s")
            git tag -a "$NEXT_VERSION" -m "$(printf "$message_template" "$NEXT_VERSION")" && confirm
        else
            git tag -a "$NEXT_VERSION" -m "$MESSAGE" && confirm
        fi
    fi
}

confirm() {
    printf 1>&2 "Last version was %s\n" "$CURRENT_VERSION"
    printf 1>&2 "Current version now is %s\n" "$NEXT_VERSION"
    printf "%s\n" "$NEXT_VERSION"
    exit 0
}

main() {
    args_parse "$@"
    args_validate
    release_check
    is_git_dir
    semver_get
    semver_validate
    semver_parse
    semver_bump
    semver_next
}

main "$@"
