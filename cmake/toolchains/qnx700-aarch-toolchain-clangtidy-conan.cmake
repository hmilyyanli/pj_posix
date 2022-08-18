SET(CMAKE_SYSTEM_NAME QNX)
SET(CMAKE_SYSTEM_VERSION 7.0.0)
SET(CMAKE_SYSTEM_PROCESSOR aarch64)
SET(TOOLCHAIN QNX)

if(CMAKE_TOOLCHAIN_FILE)
# touch toolchain variable to suppress "unused variable" warning
endif()

#SET(CMAKE_IMPORT_LIBRARY_SUFFIX ".a")

SET(CMAKE_SHARED_LIBRARY_PREFIX "lib")
SET(CMAKE_SHARED_LIBRARY_SUFFIX ".so")
SET(CMAKE_STATIC_LIBRARY_PREFIX "lib")
SET(CMAKE_STATIC_LIBRARY_SUFFIX ".a")

SET(QNX_HOST   $ENV{QNX_HOST})
SET(QNX_TARGET $ENV{QNX_TARGET})
SET(MAKEFLAGS  $ENV{MAKEFLAGS})
SET(TMPDIR     $ENV{TMP})

SET(CMAKE_MAKE_PROGRAM "${QNX_HOST}/usr/bin/make"                                 CACHE PATH "QNX make program")
SET(CMAKE_AR           "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-ar"      CACHE PATH "QNX ar program")
SET(CMAKE_RANLIB       "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-ranlib"  CACHE PATH "QNX ranlib program")
SET(CMAKE_NM           "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-nm"      CACHE PATH "QNX nm program")
SET(CMAKE_OBJCOPY      "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-objcopy" CACHE PATH "QNX objcopy program")
SET(CMAKE_OBJDUMP      "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-objdump" CACHE PATH "QNX objdump program")
SET(CMAKE_LINKER       "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-ld"      CACHE PATH "QNX linker program")
SET(CMAKE_STRIP        "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-strip"   CACHE PATH "QNX Strip program")

## specific for clang-tidy
# defines
SET(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -D__QNX__=1 -D__QNXNTO__=1 -D__aarch64__=1 -D__ORDER_LITTLE_ENDIAN__=1234 -D__FLOAT_WORD_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__ORDER_PDP_ENDIAN__=3412 -D__LITTLEENDIAN__=1 -D__ORDER_BIG_ENDIAN__=4321 -D__BYTE_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__EXT=1 -nostdinc")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D__QNX__=1 -D__QNXNTO__=1 -D__aarch64__=1 -D__ORDER_LITTLE_ENDIAN__=1234 -D__FLOAT_WORD_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__ORDER_PDP_ENDIAN__=3412 -D__LITTLEENDIAN__=1 -D__ORDER_BIG_ENDIAN__=4321 -D__BYTE_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__EXT=1 -nostdinc++")
# includes
SET(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -isystem ${QNX_HOST}/usr/lib/gcc/aarch64-unknown-nto-qnx7.0.0/5.4.0/include -isystem ${QNX_TARGET}/usr/include -isystem ${QNX_TARGET}/usr/include/aarch64")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem ${QNX_HOST}/usr/lib/gcc/aarch64-unknown-nto-qnx7.0.0/5.4.0/include -isystem ${QNX_TARGET}/usr/include -isystem ${QNX_TARGET}/usr/include/aarch64 -isystem ${QNX_TARGET}/usr/include/c++/5.4.0/ -isystem ${QNX_TARGET}/usr/include/c++/5.4.0/aarch64-unknown-nto-qnx7.0.0")

# C compiler and default flags
SET(CMAKE_C_COMPILER               ${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-gcc)
set(CMAKE_C_FLAGS                  "${CMAKE_C_FLAGS} -Wall")
set(CMAKE_C_FLAGS_DEBUG            "${CMAKE_C_FLAGS} -g -D_DEBUG"                 CACHE STRING "QNX C flags for Debug")
set(CMAKE_C_FLAGS_RELEASE          "${CMAKE_C_FLAGS} -O2 -DNDEBUG"                CACHE STRING "QNX C flags for Release")
set(CMAKE_C_FLAGS_RELWITHDEBINFO   "${CMAKE_C_FLAGS} -O2 -g"                      CACHE STRING "QNX C flags for RelWithDebInfo")

# C++ compiler and default flags
SET(CMAKE_CXX_COMPILER             ${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-g++)
set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -Wall -D_GLIBCXX_USE_C99=1")
set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -std=gnu++11 -stdlib=libc++")
set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS} -g -D_DEBUG"               CACHE STRING "QNX CXX flags for Debug")
set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS} -O2 -DNDEBUG"              CACHE STRING "QNX CXX flags for Release")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS} -O2 -g"                    CACHE STRING "QNX CXX flags for RelWithDebInfo")

SET(CMAKE_FIND_ROOT_PATH ${QNX_TARGET} ${QNX_TARGET}/aarch64le)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
