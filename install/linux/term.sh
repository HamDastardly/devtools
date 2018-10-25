#!/usr/bin/env bash
set -x -e

sudo apt install xterm

ln -s $(realpath ../../dotfiles/term/Xresources) $HOME/.Xresources
ln -s $(realpath ../../dotfiles/term/xsessionrc) $HOME/.xsessionrc
