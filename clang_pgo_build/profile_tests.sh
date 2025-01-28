#!/bin/bash -e
export LD_LIBRARY_PATH=$HOME/my_llvm_fork/llvm-project/build/lib/x86_64-unknown-linux-gnu
D=`realpath ../test_data/tests`
echo "$D"

rm -rf test.prof_*

LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libprofiler.so.0.5.11" CPUPROFILE=test.prof \
  taskset -c 0-7 ./contest/grader/contest-grader --threads 8 --tests $D



google-pprof --pdf ./contest/grader/contest-grader test.prof_* >profile.pdf
