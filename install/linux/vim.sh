set -x -e

$APT_REMOVE vim vim-runtime gvim vim-tiny vim-common vim-gui-common
$APT_INSTALL cscope python-dev python3-dev ruby-dev libncurses5
$APT_SANITIZE

pushd "${SRC_DIR}"
$GIT_CLONE https://github.com/vim/vim.git vim
cd vim
./configure                  \
    --enable-fail-if-missing \
    --with-features=huge     \
    --enable-multibyte       \
    --enable-cscope          \
    --enable-pythoninterp    \
    --enable-python3interp   \
    --enable-rubyinterp
make
$CHECK_INSTALL
popd

$UPDATE_ALTS --install /usr/bin/editor editor /usr/local/bin/vim 1
$UPDATE_ALTS --set editor /usr/local/bin/vim
$UPDATE_ALTS --install /usr/bin/vi vi /usr/local/bin/vim 1
$UPDATE_ALTS --set vi /usr/local/bin/vim

if [[ -d ~/.vim ]]
then
    rm -rf ~/.vim
fi
$LINK $DOT_FILES/vim ~/.vim
