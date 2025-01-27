#!/bin/bash -e

cmake -G Ninja ../ -DCMAKE_BUILD_TYPE=Release

cmake --build . --target contest-grader -j

./run_tests.sh 2>&1 | grep CPU | tee log
