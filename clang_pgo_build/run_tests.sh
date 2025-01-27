#!/bin/bash -e
export LD_LIBRARY_PATH=$HOME/my_llvm_fork/llvm-project/build/lib/x86_64-unknown-linux-gnu
D=`realpath ../test_data/tests`
echo "$D"
taskset -c 0-0 ./contest/grader/contest-grader --threads 1 --tests $D
