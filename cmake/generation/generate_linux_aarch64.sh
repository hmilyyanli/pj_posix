#!/bin/bash
set -e

echo "==============================="
echo "== generating for Linux aarch64"
echo "==============================="
mkdir -p build/linux-aarch64 && cd build/linux-aarch64
if [ -f ../../conanfile.* ]; then
  conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-yocto-aarch64-v3h.txt
fi
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/linux-aarch64-toolchain.cmake \
    -DCMAKE_BUILD_TYPE=RelWithDebInfo ../..
cd ../..