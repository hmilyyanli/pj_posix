#!/bin/bash

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

conan install qnx7-aarch64-toolchain/7.0.4.202010@bosch/stable -g txt

export   QNX_HOST=$(awk -F "=" '/QNX_HOST/ {print $2}' conanbuildinfo.txt)
export QNX_TARGET=$(awk -F "=" '/QNX_TARGET/ {print $2}' conanbuildinfo.txt)
export  MAKEFLAGS=$(awk -F "=" '/MAKEFLAGS/ {print $2}' conanbuildinfo.txt)

rm conanbuildinfo.txt

echo "QNX_HOST=${QNX_HOST}"
echo "QNX_TARGET=${QNX_TARGET}"
echo "MAKEFLAGS=${MAKEFLAGS}"
