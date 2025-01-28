#!/bin/bash -e

rm -rf CMakeCache.txt

cmake -G Ninja \
  -DCMAKE_C_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang \
  -DCMAKE_CXX_COMPILER=$HOME/my_llvm_fork/llvm-project/build/bin/clang++ ../ \
  -DCMAKE_BUILD_TYPE=Release

cmake -G Ninja ../ -DCMAKE_BUILD_TYPE=Release

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

