set -x -e
source commands.sh

pushd "${SRC_DIR}/vim"
sudo $CHECK_INSTALL --pakdir $INSTALL_DIR

sudo $UPDATE_ALTS --install /usr/bin/editor editor $INSTALL_DIR/bin/vim 1
sudo $UPDATE_ALTS --set editor $INSTALL_DIR/bin/vim
sudo $UPDATE_ALTS --install /usr/bin/vi vi $INSTALL_DIR/bin/vim 1
sudo $UPDATE_ALTS --set vi $INSTALL_DIR/bin/vim

if [[ -d ~/.vim ]]
then
    rm -rf ~/.vim
fi
$LINK $DOT_FILES/vim ~/.vim
popd
