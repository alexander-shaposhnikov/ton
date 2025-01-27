#!/bin/bash -e

rm -rf CMakeCache.txt

PGO_DIR=pgo_dir
rm -rf $PGO_DIR
mkdir -p $PGO_DIR

CXX_FLAGS="-fprofile-generate=$PGO_DIR -Wno-unused-command-line-argument --rtlib=compiler-rt -Wno-unused-command-line-argument -L$HOME/my_llvm_fork/llvm-project/build/lib/x86_64-unknown-linux-gnu -lunwind -lclang_rt.profile"

export LD_LIBRARY_PATH=$HOME/my_llvm_fork/llvm-project/build/lib/x86_64-unknown-linux-gnu

cmake -G Ninja -DCMAKE_CXX_FLAGS="$CXX_FLAGS" -DCMAKE_C_FLAGS="$CXX_FLAGS" \
  -DCMAKE_C_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang \
  -DCMAKE_CXX_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang++ \
  ../ -DCMAKE_BUILD_TYPE=Release

cmake --build . --target contest-grader -j

./run_tests.sh 1>/dev/null 2>&1

LLVM_PROFDATA=$HOME/my_llvm_fork/llvm-project/build/bin/llvm-profdata
(cd $PGO_DIR && $LLVM_PROFDATA merge -output=default.profdata *.profraw)

OPT_CXX_FLAGS="-fprofile-use=$PGO_DIR -Wno-unused-command-line-argument --rtlib=compiler-rt -Wno-unused-command-line-argument -L$HOME/my_llvm_fork/llvm-project/build/lib/x86_64-unknown-linux-gnu -lunwind -lclang_rt.profile"

export LD_LIBRARY_PATH=$HOME/my_llvm_fork/llvm-project/build/lib/x86_64-unknown-linux-gnu

cmake -G Ninja -DCMAKE_CXX_FLAGS="$OPT_CXX_FLAGS" -DCMAKE_C_FLAGS="$OPT_CXX_FLAGS" \
  -DCMAKE_C_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang \
  -DCMAKE_CXX_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang++ \
  ../ -DCMAKE_BUILD_TYPE=Release

cmake --build . --target contest-grader -j

./run_tests.sh 2>&1 | grep CPU



