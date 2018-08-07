#!/usr/bin/env bash
set -x -e

sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# # Themes
mkdir -p ~/.oh-my-zsh/themes/
wget -xqO ~/.oh-my-zsh/themes/aphrodite.zsh-theme https://git.io/v5ohc

# install dotfiles
ln -s $(realpath ../../dotfiles/zsh) $HOME/.config/zsh

mv $HOME/.zshrc $HOME/.zshrc_bak
ln -s $(realpath ../../dotfiles/zsh/zshrc) $HOME/.zshrc
