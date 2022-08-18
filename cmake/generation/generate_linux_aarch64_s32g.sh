#!/bin/bash
set -e

echo "===================================="
echo "== generating for Linux aarch64 S32G"
echo "===================================="
mkdir -p build/linux-aarch64-s32g && cd build/linux-aarch64-s32g
if [ -f ../../conanfile.* ]; then
    conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-linux-aarch64-s32g.txt
fi
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/linux-aarch64-toolchain.cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ../..
cd ../..
