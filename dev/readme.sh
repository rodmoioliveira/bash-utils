#!/usr/bin/env bash

rm README.md
echo "# bash-utils" >>README.md
echo "" >>README.md
echo "# style" >>README.md
echo "" >>README.md
echo "- [progrium/bashstyle](https://gist.github.com/outro56/4a2403ae8fefdeb832a5)" >>README.md
echo "" >>README.md
echo "# utilities" >>README.md
echo "" >>README.md
echo "## git-bump" >>README.md
echo "" >>README.md
echo '```sh' >>README.md
echo 'git-bump --h' >>README.md
echo "" >>README.md
./scripts/git-bump.sh -h 2>>README.md
echo '```' >>README.md
echo "" >>README.md
echo "# make recipes" >>README.md
echo "" >>README.md
echo '```sh' >>README.md
echo "fmt            Format bash code" >>README.md
echo "help           Display this help screen" >>README.md
echo "readme         Write README.md" >>README.md
echo "symlink        Add symlink to scripts in path" >>README.md
echo "tests          Tests utilities" >>README.md
echo "typos-fix      Fix typos" >>README.md
echo "typos          Show typos" >>README.md
echo '```' >>README.md
