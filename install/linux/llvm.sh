set -x -e

pushd "${SRC_DIR}"
$GIT_CLONE http://llvm.org/git/llvm.git
cd llvm

pushd tools
$GIT_CLONE clone http://llvm.org/git/clang.git
popd

pushd projects
$GIT_CLONE http://llvm.org/git/compiler-rt.git
$GIT_CLONE one http://llvm.org/git/openmp.git
$GIT_CLONE http://llvm.org/git/libcxx.git
$GIT_CLONE http://llvm.org/git/libcxxabi.git
$GIT_CLONE http://llvm.org/git/test-suite.git
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
make check-all -j4
$CHECK_INSTALL
popd
