#!/bin/bash
set -e

echo "==============================="
echo "== generating for arm32 GCC9.3"
echo "==============================="
mkdir -p build/baremetal-gcc9-arm32 && cd build/baremetal-gcc9-arm32
if [ -f ../../conanfile.* ]; then
  conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-baremetal-gcc9-arm32.txt
fi
. ../../cmake/conan/env-arm32-gcc9.sh
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_TOOLCHAIN_FILE=./../../cmake/toolchains/baremetal-gcc9-arm32.cmake ${RB_CMAKE_EXTRA_DEFINES} ../..
cd ../..
