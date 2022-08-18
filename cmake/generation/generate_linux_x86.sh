#!/bin/bash
set -e

echo "==============================="
echo "== generating for Linux x86"
echo "==============================="
mkdir -p build/linux-x86 && cd build/linux-x86
if [ -f ../../conanfile.* ]; then
  conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-osd5-x86_64.txt
fi
cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/linux-x86-toolchain.cmake ../..

cd ../..
