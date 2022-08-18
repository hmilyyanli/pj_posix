#!/bin/bash
set -e

echo "==============================="
echo "== generating for QNX x86_64"
echo "==============================="
mkdir -p build/qnx700-x86_64 && cd build/qnx700-x86_64
if [ -f ../../conanfile.* ]; then
  conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-qnx700-x86_64.txt
fi
cmake -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/qnx700-x86_64-toolchain-conan.cmake ${RB_CMAKE_EXTRA_DEFINES} ../..
cd ../..
