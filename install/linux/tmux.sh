#!/usr/bin/env bash
set -x -e

sudo apt-get install -y tmux
ln -s $(realpath ../../dotfiles/tmux.conf) $HOME/.tmux.conf
