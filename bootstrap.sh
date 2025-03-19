#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git config --global url."https://".insteadOf git://
git submodule update --init --recursive

function link_config() {
  local overwrite_all=false
  local overwrite_none=false
  for path in .config/*; do
    local dst="$HOME/$path"
    if [ -e "$dst" ]; then
      if $overwrite_none; then
        continue
      fi
      if ! $overwrite_all; then
        local overwrite=false
        echo "$dst already exists, overwrite?"
        select answer in "Yes" "No" "All" "None"; do
          case "$answer" in
            Yes ) overwrite=true ; break ;;
            No ) overwrite=false; break ;;
            All )
              overwrite_all=true 
              overwrite=true
              break
              ;;
            None )
              overwrite_none=true
              overwrite=false
              break
              ;;
          esac
        done
      fi
      if $overwrite; then
        echo "overwriting $dst"
        rm -rf "$dst"
      fi
    fi

    ln -s "$(pwd)/$path" "$dst"
  done
}

function install() {
    link_config
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
unset sync_config
