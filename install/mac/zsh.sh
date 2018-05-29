#!/usr/bin/env bash
set -x -e

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Aphrodite theme
mkdir -p ~/.oh-my-zsh/themes/
wget -xqO ~/.oh-my-zsh/themes/aphrodite.zsh-theme https://git.io/v5ohc
sed -i.bak 's/^[[:space:]]*ZSH_THEME=.*/ZSH_THEME="aphrodite"/' ~/.zshrc
