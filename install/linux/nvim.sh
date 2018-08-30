#!/usr/bin/env bash
set -x -e

# install python and ruby dependencies
sudo apt-get install -y python-dev python-pip python3-dev python3-pip
pip install --upgrade neovim
pip3 install --upgrade neovim

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
mkdir -p $HOME/.rbenv/plugins
if [[ ! -d $HOME/.rbenv/plugins/ruby-build ]]
then
	git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build
fi
rbenv install 2.4.2
rbenv global 2.4.2
gem install neovim

# install nvim
sudo apt-get -y install neovim

# symlink dotfiles for nvim
dotfiles="$HOME/.config/nvim"
ln -s $(realpath ../../dotfiles/vim) $dotfiles

# install Plug package manager
pushd $dotfiles
curl -fLo autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
popd

# Update all plugins
nvim +PlugInstall +qall
