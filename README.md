# bash-utils

## Installation

To install all the scripts, run:

```sh
make dependencies symlink
```

To uninstall all the scripts, you can run:

```sh
make unsymlink
```

# available scripts

## git-bump

```sh
git-bump -h

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
  git-bump -l patch -m "patch version"
  git-bump -l minor -d
  git-bump -l major
```

# future scripts

- [x] `git-bump` - Bump the current tag version to the next version accordingly to
  semantic versioning specifications.
- [ ] `git-dirty` - Recursively check your local git repositories for unstaged files.
- [ ] `git-changelog` - Recursively generate CHANGELOG files for your git repositories.

# completions

Completions for each script are available for the `zsh` shell in the
[complete](https://github.com/rodmoioliveira/bash-utils/tree/main/complete) directory.
To enable shell completion, copy the files to one of your `$fpath` directories

# make recipes

```sh
make help

dependencies   Install dependencies
fmt-check      Check format bash code
fmt            Format bash code
help           Display this help screen
readme         Write README.md
symlink        Add symlink to scripts in path
tests          Tests utilities
typos          Check typos
typos-fix      Fix typos
unsymlink      Remove symlink to scripts from path
```

# style

- [progrium/bashstyle](https://gist.github.com/outro56/4a2403ae8fefdeb832a5)
