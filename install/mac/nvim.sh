#!/usr/bin/env bash
set -x -e

# install nvim
brew install nvim

# symlink dotfiles for nvim
dotfiles='~/.config/nvim'
ln -s ../../dotfiles/vim $dotfiles

pushd $dotfiles
ln -s vimrc init.vim
curl -fLo autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
popd

# install plugins
nvim +PluginInstall +qall

# compile separate components
pushd $dotfiles/bundle/YouCompleteMe/
./install.py --clang-completer
popd

pushd $dotfiles/bundle/command-t/ruby/command-t/ext/command-t/
ruby extconf.rb
make
popd

