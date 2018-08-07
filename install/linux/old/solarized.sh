set -x -e
source commands.sh

SOLARIZED_AUTHOR=sigurdga
SOLARIZED_REPO=gnome-terminal-colors-solarized.git
SOLARIZED_DIR=solarized

pushd "${SRC_DIR}"
$GIT_CLONE https://github.com/${SOLARIZED_AUTHOR}/${SOLARIZED_REPO} ${SOLARIZED_DIR}
${SOLARIZED_DIR}/install.sh
popd
