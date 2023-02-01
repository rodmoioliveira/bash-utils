#!/usr/bin/env bash

rm README.md

cat <<EOF >>README.md
# bash-utils

This is my collection of useful shell scripts for Linux and Mac.

## Installation

To install all the scripts, run:

\`\`\`sh
make dependencies symlink
\`\`\`

To uninstall all the scripts, you can run:

\`\`\`sh
make unsymlink
\`\`\`

# available scripts

## git-bump

\`\`\`sh
git-bump -h

$(./scripts/git-bump.sh 2>&1 -h)
\`\`\`

# future scripts

- [x] \`git-bump\` - Bump the current tag version to the next version accordingly to
  semantic versioning specifications.
- [ ] \`git-dirty\` - Recursively check your local git repositories for unstaged files.
- [ ] \`git-changelog\` - Recursively generate CHANGELOG files for your git repositories.

# completions

Completions for each script are available for the \`zsh\` shell in the
[complete](https://github.com/rodmoioliveira/bash-utils/tree/main/complete) directory.
To enable shell completion, copy the files to one of your \`\$fpath\` directories

# make recipes

\`\`\`sh
make help

$(make help)
\`\`\`

# style

- [progrium/bashstyle](https://gist.github.com/outro56/4a2403ae8fefdeb832a5)
EOF

sd '(make\[1\]:.+\n)' '' README.md
