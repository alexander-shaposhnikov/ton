#!/bin/bash -e

rm -rf CMakeCache.txt

PGO_DIR=pgo_dir
rm -rf $PGO_DIR
mkdir -p $PGO_DIR

LLVM_HOME="`realpath ../llvm_toolchain/llvm-project/`"

CXX_FLAGS="-fprofile-generate=$PGO_DIR -Wno-unused-command-line-argument --rtlib=compiler-rt -Wno-unused-command-line-argument -L$LLVM_HOME/build/lib/x86_64-unknown-linux-gnu -lunwind -lclang_rt.profile"

export LD_LIBRARY_PATH=$LLVM_HOME/build/lib/x86_64-unknown-linux-gnu

cmake -G Ninja -DCMAKE_CXX_FLAGS="$CXX_FLAGS" -DCMAKE_C_FLAGS="$CXX_FLAGS" \
  -DCMAKE_C_COMPILER=$LLVM_HOME/build/bin/clang \
  -DCMAKE_CXX_COMPILER=$LLVM_HOME/build/bin/clang++ \
  ../ -DCMAKE_BUILD_TYPE=Release

cmake --build . --target contest-grader -j

./run_tests.sh 1>/dev/null 2>&1

LLVM_PROFDATA=$LLVM_HOME/build/bin/llvm-profdata
(cd $PGO_DIR && $LLVM_PROFDATA merge -output=default.profdata *.profraw)

OPT_CXX_FLAGS="-fprofile-use=$PGO_DIR -Wno-unused-command-line-argument --rtlib=compiler-rt -Wno-unused-command-line-argument -L$HOME/my_llvm_fork/llvm-project/build/lib/x86_64-unknown-linux-gnu -lunwind -lclang_rt.profile"

export LD_LIBRARY_PATH=$LLVM_HOME/build/lib/x86_64-unknown-linux-gnu

cmake -G Ninja -DCMAKE_CXX_FLAGS="$OPT_CXX_FLAGS" -DCMAKE_C_FLAGS="$OPT_CXX_FLAGS" \
  -DCMAKE_C_COMPILER=$LLVM_HOME/build/bin/clang \
  -DCMAKE_CXX_COMPILER=$LLVM_HOME/build/bin/clang++ \
  ../ -DCMAKE_BUILD_TYPE=Release

cmake --build . --target contest-grader -j

N=10

for i in `seq $N`; do
  rm -f log$i
done

for i in `seq $N`; do
  ./run_tests.sh 2>&1 | grep CPU | tail -n 1 | cut -d ' ' -f 8 >log$i
done

sum=0
for i in `seq $N`; do
  num=$(cat "log$i")
  sum=$(bc <<< "$sum + $num")
done

A=$(bc -l <<< "1000 * $sum/$N")

echo "average = $A"

