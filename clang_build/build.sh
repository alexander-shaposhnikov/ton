#!/bin/bash -e

rm -rf CMakeCache.txt

cmake -G Ninja \
  -DCMAKE_C_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang \
  -DCMAKE_CXX_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang++ ../ \
  -DCMAKE_BUILD_TYPE=Release

cmake --build . --target contest-grader -j

cmake -G Ninja ../ -DCMAKE_BUILD_TYPE=Release

cmake --build . --target contest-grader -j

./run_tests.sh 2>&1 | grep CPU | tee log
