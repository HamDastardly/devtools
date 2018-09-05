#!/usr/bin/env bash
set -x -e

sudo apt install ranger

dotfiles=$HOME/.config/ranger
if [[ -d $dotfiles ]]
then
    mv $dotfiles "${dotfiles}_bak"
fi

ln -s $(realpath ../../dotfiles/ranger) $dotfiles
