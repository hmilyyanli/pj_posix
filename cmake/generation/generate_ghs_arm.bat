#!/bin/bash
set -e

echo "==============================="
echo "== generating for arm32 GCC9.3"
echo "==============================="

set BUILD_FOLDER=build\baremetal-ghs-arm
mkdir %BUILD_FOLDER%
cd %BUILD_FOLDER%
if exist ..\..\conanfile.txt conan install ../../ -g cmake --build=missing --profile ../../cmake/conan/profile-baremetal-ghs-arm.txt

if exist ..\..\deactivate.bat CALL ..\..\deactivate.bat
CALL .\..\..\cmake\conan\env-ghs-arm.bat

cmake -G "MinGW Makefiles" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=.\..\..\cmake\toolchains\baremetal-ghs-arm-toolchain.cmake %RB_CMAKE_EXTRA_DEFINES% ..\..

cd ..\..
