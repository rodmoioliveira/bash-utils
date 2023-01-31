#!/usr/bin/env bash

install_linux() {
    curl -sL https://git.io/_has | sudo tee /usr/local/bin/has >/dev/null && sudo chmod +x /usr/local/bin/has
    curl -sS https://webi.sh/shfmt | sh
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    cargo install sd
    cargo install fd-find
    cargo install ripgrep
    cargo install exa
    cargo install typos-cli
    cargo install --locked bat
}

install_mac() {
    brew install kdabir/tap/has
    brew install shfmt
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    brew install sd
    brew install fd
    brew install ripgrep
    brew install exa
    brew install typos-cli
    brew install bat
    brew install gnu-getopt
    echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' | sudo tee -a ~/.bash_profile
    echo 'export FLAGS_GETOPT_CMD="$(brew --prefix gnu-getopt)/bin/getopt"' | sudo tee -a ~/.bash_profile
    source ~/.bash_profile
}

install() {
    case "${OS}" in
    Linux)
        install_linux
        ;;
    Mac)
        install_mac
        ;;
    esac
}

check_os() {
    unameOut="$(uname -s)"

    case "${unameOut}" in
    Linux*)
        OS=Linux
        ;;
    Darwin*)
        OS=Mac
        ;;
    CYGWIN* | MINGW* | *)
        printf 1>&2 "No support for OS %s\n" "$OS"
        exit 1
        ;;
    esac
}

main() {
    check_os
    install
}

main
