#!/bin/bash

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

conan install gcc-arm-none-eabi/9.2020.q2@arm/stable -g txt

export   COMPILER_PATH=$(awk -F "=" '/COMPILER_PATH/ {print $2}' conanbuildinfo.txt)

rm conanbuildinfo.txt

echo "COMPILER_PATH=${COMPILER_PATH}"
