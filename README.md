# bash-utils

[![Makefile CI](https://github.com/rodmoioliveira/bash-utils/actions/workflows/makefile.yml/badge.svg)](https://github.com/rodmoioliveira/bash-utils/actions/workflows/makefile.yml)

This is my collection of useful shell scripts for Linux (ubuntu-latest) and Mac
(macos-latest).

# index

- [installation](https://github.com/rodmoioliveira/bash-utils#installation)
- [scripts descriptions](https://github.com/rodmoioliveira/bash-utils#scripts-descriptions)
  - [git-bump](https://github.com/rodmoioliveira/bash-utils#git-bump)
  - [pfmt](https://github.com/rodmoioliveira/bash-utils#pfmt)
- [future scripts](https://github.com/rodmoioliveira/bash-utils#future-scripts)
- [completions](https://github.com/rodmoioliveira/bash-utils#completions)
- [make recipes](https://github.com/rodmoioliveira/bash-utils#make-recipes)
- [style](https://github.com/rodmoioliveira/bash-utils#style)
- [reference](https://github.com/rodmoioliveira/bash-utils#reference)

# installation

To install all the scripts, run:

```txt
make dependencies symlink
```

To uninstall all the scripts, you can run:

```txt
make unsymlink
```

# scripts descriptions

## git-bump

```txt
git-bump --help

Bump the current tag version to the next version according to the semantic
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
```

## pfmt

```txt
pfmt --help

Format plain text with sd.

Usage:
  pfmt [OPTIONS] <FILES>...
  pfmt [OPTIONS] <<(echo <TEXT>)

Arguments:
  <FILES>...
          A list of space-separated FILES as positional arguments, or

  <TEXT>
          A TEXT from standard input

Options:
  -h, --help
          Print help information (use `-h` for a summary)

Formatting Rules:
  - Enforce a single space between words.
  - Remove spaces between words and punctuation.
  - Add only one space between punctuation and words.
  - Remove spaces surrounding words inside square brackets, brackets, and parentheses.
  - Trim the spaces at the end of the line.
  - Add double spaces between sentences.

Examples (positional arguments):
  find . -type f -name "*.md" | xargs pfmt
  pfmt *.md

Examples (standard input):
  pfmt <<(echo "some     text to     format    ...")
  cat README.md | pfmt
  echo "some     text to     format    ..." | pfmt
```

# future scripts

- [ ] `fm` - Filter and transform text and files accordingly predefined regex rules.
- [x] `git-bump` - Bump the current tag version to the next version accordingly to
  semantic versioning specifications.
- [ ] `git-dirty` - Recursively check your local git repositories for unstaged files.
- [ ] `git-changelog` - Recursively generate CHANGELOG files for your git repositories.
- [x] `pfmt` - Format plain text with sd.

# completions

Completions for each script are available for the `zsh` shell in the
[complete](https://github.com/rodmoioliveira/bash-utils/tree/main/complete) directory.
To enable shell completion, copy the files to one of your `$fpath` directories.

# make recipes

```txt
make help

all-check      Run all checks
dependencies   Install dependencies
fmt-check      Check format bash code
fmt            Format bash code
help           Display this help screen
lint-check     Check lint bash code
readme         Write README.md
symlink        Add symlink to scripts in path
tests          Tests utilities
typos          Check typos
typos-fix      Fix typos
unsymlink      Remove symlink to scripts from path
```

# style

- [progrium/bashstyle](https://github.com/progrium/bashstyle/blob/master/README.md)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

# reference
- [Bash Reference Manual](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html)
- [Bash script setup](https://caiustheory.com/bash-script-setup/)
- [Use Bash Strict Mode (Unless You Love Debugging)](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
- [How "Exit Traps" Can Make Your Bash Scripts Way More Robust And Reliable](http://redsymbol.net/articles/bash-exit-traps/)
- [How can I read a file (data stream, variable) line-by-line (and/or field-by-field)?](http://mywiki.wooledge.org/BashFAQ/001)
- [Obsolete and deprecated syntax](https://wiki.bash-hackers.org/scripting/obsolete)
- [Portability talk](https://wiki.bash-hackers.org/scripting/nonportable)
- [Using Trap to Exit Bash Scripts Cleanly](https://www.putorius.net/using-trap-to-exit-bash-scripts-cleanly.html)
- [Bash | Tips & Tricks I would have wanted to know when I started](https://ricma.co/posts/tech/tutorials/bash-tip-tricks/)
