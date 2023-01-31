# bash-utils

# style

- [progrium/bashstyle](https://gist.github.com/outro56/4a2403ae8fefdeb832a5)

# utilities

## git-bump

```sh
git-bump -h

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
```

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
```
