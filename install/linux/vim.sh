set -x -e
source commands.sh

sudo $APT_REMOVE vim vim-runtime gvim vim-tiny vim-common vim-gui-common
sudo $APT_INSTALL cscope python-dev python3-dev ruby-dev libncurses5-dev checkinstall
# sudo $APT_SANITIZE

pushd "${SRC_DIR}"
$GIT_CLONE https://github.com/vim/vim.git vim
cd vim
./configure                  \
    --prefix=$INSTALL_DIR    \
    --enable-fail-if-missing \
    --with-features=huge     \
    --enable-multibyte       \
    --enable-cscope          \
    --enable-pythoninterp    \
    --enable-python3interp   \
    --enable-rubyinterp
make
popd

source vim_post.sh
