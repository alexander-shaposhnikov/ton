#!/bin/bash -e
D=`realpath ../test_data/tests`
echo "$D"
taskset -c 0-7 ./contest/grader/contest-grader --threads 8 --tests $D
