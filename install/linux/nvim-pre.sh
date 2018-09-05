#!/usr/bin/env bash
set -x -e

# install python and ruby dependencies
sudo apt-get install -y python-dev python-pip python3-dev python3-pip
pip install --upgrade neovim
pip3 install --upgrade neovim

curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-installer | bash
mkdir -p "$(rbenv root)"/plugins
if [[ ! -d "$(rbenv root)"/plugins/ruby-build ]]
then
	git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
fi
rbenv install 2.4.2
rbenv global 2.4.2
gem install neovim
