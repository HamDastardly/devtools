#!/usr/bin/env bash
set -x -e

sudo apt install ranger

ln -s $(realpath ../../dotfiles/ranger) $HOME/.config/ranger
