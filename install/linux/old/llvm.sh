set -x -e

source commands.sh

RELEASE="release_38"

pushd "${SRC_DIR}"
rm -rf llvm
$GIT_CLONE http://llvm.org/git/llvm.git
cd llvm
$GIT_CHECKOUT $RELEASE

pushd tools
$GIT_CLONE http://llvm.org/git/clang.git
cd clang
$GIT_CHECKOUT $RELEASE
popd

pushd projects
$GIT_CLONE http://llvm.org/git/compiler-rt.git
cd compiler-rt
$GIT_CHECKOUT $RELEASE
cd ..

$GIT_CLONE http://llvm.org/git/openmp.git
cd openmp
$GIT_CHECKOUT $RELEASE
cd ..

$GIT_CLONE http://llvm.org/git/libcxx.git
cd libcxx
$GIT_CHECKOUT $RELEASE
cd ..

$GIT_CLONE http://llvm.org/git/libcxxabi.git
cd libcxxabi
$GIT_CHECKOUT $RELEASE
cd ..

$GIT_CLONE http://llvm.org/git/test-suite.git
cd test-suite
$GIT_CHECKOUT $RELEASE
cd ..
popd

$GIT_CONFIG branch.master.rebase true

mkdir build && cd build
CC=/usr/bin/gcc CXX=/usr/bin/g++          \
    cmake -G "Unix Makefiles"             \
        -DCMAKE_C_COMPILER=/usr/bin/gcc   \
        -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
        -DCMAKE_BUILD_TYPE=Release        \
        -DLLVM_BUILD_LLVM_DYLIB=yes       \
    ..
make -j4
make check-all
$CHECK_INSTALL --pkgname=clang
popd
