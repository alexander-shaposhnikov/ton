#!/bin/bash

cmake -G Ninja -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_SPLIT_DWARF=ON -DLLVM_ENABLE_ASSERTIONS=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      -DLLVM_TARGETS_TO_BUILD="X86;AArch64" \
      -DLIBCXX_ENABLE_INCOMPLETE_FEATURES=ON \
      -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD="AArch64" \
      -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;compiler-rt;libunwind" \
               -DLLVM_USE_LINKER=lld \
               -DCMAKE_C_COMPILER=clang \
               -DCMAKE_CXX_COMPILER=clang++ \
               -DLLVM_ENABLE_PROJECTS="bolt;mlir;flang;llvm;clang;lld;clang-tools-extra" ../llvm
