set -x -e
source commands.sh

pushd "${SRC_DIR}"
$GIT_CLONE https://github.com/powerline/fonts powerline-fonts
cd powerline-fonts
./install.sh
popd
