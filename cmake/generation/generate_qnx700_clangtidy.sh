#!/bin/bash
set -e

echo "==============================="
echo "== generating for QNX clang-tidy"
echo "==============================="
mkdir -p build/qnx700-clangtidy && cd build/qnx700-clangtidy
if [ -f ../../conanfile.* ]; then
  conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-qnx700-aarch64.txt
fi
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/qnx700-aarch-toolchain-clangtidy-conan.cmake \
    -DCMAKE_C_CLANG_TIDY="clang-tidy-10;-checks=*" \
    -DCMAKE_CXX_CLANG_TIDY="clang-tidy-10;-checks=*" ${RB_CMAKE_EXTRA_DEFINES} ../..
cd ../..