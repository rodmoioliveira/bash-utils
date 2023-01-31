#!/usr/bin/env bash

rm README.md

cat <<EOF >>README.md
# bash-utils

# style

- [progrium/bashstyle](https://gist.github.com/outro56/4a2403ae8fefdeb832a5)

# utilities

## git-bump

\`\`\`sh
git-bump -h

$(./scripts/git-bump.sh 2>&1 -h)
\`\`\`

# make recipes

\`\`\`sh
make help

$(make help)
\`\`\`
EOF

sd '(make\[1\]:.+\n)' '' README.md
