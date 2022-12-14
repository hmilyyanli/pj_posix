set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

if (NOT CMAKE_SYSROOT)
    message(FATAL_ERROR "CMAKE_SYSROOT isn't provided via command line...aborting!")
endif()
set(CMAKE_SYSROOT      ${TOOLCHAIN_SYSROOT_PATH})

set(COMPILER_PREFIX    aarch64-linux-gnu-)
set(CMAKE_C_COMPILER   ${COMPILER_PREFIX}gcc)
set(CMAKE_CXX_COMPILER ${COMPILER_PREFIX}gcc)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

add_compile_options(-O2 --sysroot ${TOOLCHAIN_SYSROOT_PATH})

## kernel module defines
set(LINUX_KERNEL_ARCH            "ARCH=arm64")
set(LINUX_KERNEL_CROSS_COMPILE   "CROSS_COMPILE=${COMPILER_PREFIX}")
set(LINUX_KERNEL_BUILD_DIRECTORY "${CMAKE_SYSROOT}/usr/src/kernel/")