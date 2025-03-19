#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git config --global url."https://".insteadOf git://
git submodule update --init --recursive

function write_config() {
    rsync --exclude ".git/" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~
    source ~/.bash_profile
}

function install() {
    write_config

}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    install
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install
    fi;
fi
unset write_config
