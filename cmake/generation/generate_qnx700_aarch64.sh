#!/bin/bash
set -e

echo "==============================="
echo "== generating for QNX AARCH64"
echo "==============================="
mkdir -p build/qnx700-aarch64 && cd build/qnx700-aarch64
if [ -f ../../conanfile.* ]; then
  conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-qnx700-aarch64.txt
fi
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/qnx700-aarch-toolchain-conan.cmake ${RB_CMAKE_EXTRA_DEFINES} ../..
cd ../..
