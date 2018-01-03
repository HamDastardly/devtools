# install vim (from source is important)
brew install -s vim

# symlink dotfiles
ln -s ../../dotfiles/vim ~/.vim
ln -s ../../dotfiles/vim/vimrc ~/.vimrc

# install plugins
vim +PluginInstall +qall

# compile separate components
pushd ../../dotfiles/vim/bundle/YouCompleteMe/
./install.py --clang-completer
popd

pushd ../../dotfiles/vim/bundle/command-t/ruby/command-t/ext/command-t/
ruby extconf.rb
make
popd

