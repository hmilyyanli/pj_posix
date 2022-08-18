#!/bin/bash
set -e

echo "======================================="
echo "== generating for Linux x86_64 clang"
echo "======================================="
mkdir -p build/linux-x86_64-clang && cd build/linux-x86_64-clang
if [ -f ../../conanfile.* ]; then
  conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-osd5-x86_64_clang.txt
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/linux-x86_64-clang-toolchain.cmake ../..
cd ../..
