set -x -e
source commands.sh

pushd "${SRC_DIR}"
$WGET https://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz
$TAR gdb-7.12.tar.xz

cd gdb-7.12
./configure --target=mipsel-elf32 --prefix=/home/hamiltonblu/pic32-gdb --program-prefix=pic32-
make

sudo $CHECK_INSTALL --pakdir $INSTALL_DIR
popd
