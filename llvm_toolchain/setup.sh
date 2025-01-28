#!/bin/bash -e
rm -rf llvm-project
git clone https://github.com/llvm/llvm-project.git

rm -rf llvm-project/build
mkdir -p llvm-project/build
cp run_cmake_release.sh llvm-project/build/

(cd llvm-project/build && ./run_cmake_release.sh && ninja -j100)

