#!/bin/bash

# https://ilhicas.com/2018/08/08/bash-script-to-install-packages-multiple-os.html
# https://gist.github.com/natefoo/814c5bf936922dad97ff

declare -A osInfo;
osInfo["/etc/debian_version"]="apt-get install -y"
osInfo["/etc/alpine-release"]="apk --update add"
osInfo["/etc/centos-release"]="yum install -y"
osInfo["/etc/fedora-release"]="dnf install -y"
osInfo["/etc/arch-version"]=""
osInfo["/etc/SuSE-release"]=""
osInfo["/etc/gentoo-release"]=""

for f in "${!osInfo[@]}"; do
    if [[ -f $f ]];then
        package_manager=${osInfo[$f]}
    fi
done

# package="git"

echo "${package_manager}"
