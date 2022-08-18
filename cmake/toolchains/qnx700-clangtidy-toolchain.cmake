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

IF(CMAKE_HOST_WIN32)
  SET(HOST_EXECUTABLE_SUFFIX ".exe")
  SET(HOST_DIR "win64/x86_64")
  SET(SEARCH_DIRS C:/qnx700 D:/qnx700)
ELSE()
  SET(HOST_DIR "linux/x86_64")
  SET(SEARCH_DIRS /home/user/qnx700 /opt/qnx700 /opt/qnx/qnx700)
ENDIF(CMAKE_HOST_WIN32)


# Find QNX base directory
FIND_PATH(QNX_BASE
  NAME host/${HOST_DIR}/usr/bin/qcc${HOST_EXECUTABLE_SUFFIX}
  PATHS $ENV{QNX700} ${SEARCH_DIRS}
  NO_CMAKE_PATH
  NO_CMAKE_ENVIRONMENT_PATH
)

if(NOT QNX_BASE)
  message(FATAL_ERROR "QNX base path not found, please set environment variable QNX700")
endif()

IF(CMAKE_HOST_WIN32)
  FIND_PATH(QNX_CONFIGURATION
    NAME license/licenses
    PATHS $ENV{QNX_CONFIGURATION} $ENV{USERPROFILE}/.qnx
    $ENV{USERPROFILE}/.qnx
    NO_CMAKE_PATH
    NO_CMAKE_ENVIRONMENT_PATH
 )
ENDIF(CMAKE_HOST_WIN32)

SET(QNX_HOST ${QNX_BASE}/host/${HOST_DIR})
SET(QNX_TARGET ${QNX_BASE}/target/qnx7)
SET(MAKEFLAGS $ENV{MAKEFLAGS} -I${QNX_TARGET}/usr/include)
SET(TMPDIR $ENV{TMP})

SET(ENV{QNX_HOST} ${QNX_HOST})
SET(ENV{QNX_TARGET} ${QNX_TARGET})
SET(ENV{MAKEFLAGS} ${MAKEFLAGS})
IF(CMAKE_HOST_WIN32)
  SET(ENV{QNX_CONFIGURATION} ${QNX_CONFIGURATION})
  SET(ENV{PATH} "${QNX_HOST}/usr/bin;$ENV{PATH}")
ENDIF(CMAKE_HOST_WIN32)

SET(CMAKE_MAKE_PROGRAM "${QNX_HOST}/usr/bin/make${HOST_EXECUTABLE_SUFFIX}"                                 CACHE PATH "QNX make program")
SET(CMAKE_SH           "${QNX_HOST}/usr/bin/sh${HOST_EXECUTABLE_SUFFIX}"                                   CACHE PATH "QNX shell program")
SET(CMAKE_AR           "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-ar${HOST_EXECUTABLE_SUFFIX}"      CACHE PATH "QNX ar program")
SET(CMAKE_RANLIB       "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-ranlib${HOST_EXECUTABLE_SUFFIX}"  CACHE PATH "QNX ranlib program")
SET(CMAKE_NM           "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-nm${HOST_EXECUTABLE_SUFFIX}"      CACHE PATH "QNX nm program")
SET(CMAKE_OBJCOPY      "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-objcopy${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "QNX objcopy program")
SET(CMAKE_OBJDUMP      "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-objdump${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "QNX objdump program")
SET(CMAKE_LINKER       "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-ld"                               CACHE PATH "QNX linker program")
SET(CMAKE_STRIP        "${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-strip${HOST_EXECUTABLE_SUFFIX}"   CACHE PATH "QNX Strip program")

## specific for clang-tidy
# defines
SET(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -D__QNX__=1 -D__QNXNTO__=1 -D__aarch64__=1 -D__ORDER_LITTLE_ENDIAN__=1234 -D__FLOAT_WORD_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__ORDER_PDP_ENDIAN__=3412 -D__LITTLEENDIAN__=1 -D__ORDER_BIG_ENDIAN__=4321 -D__BYTE_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__EXT=1 -nostdinc")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D__QNX__=1 -D__QNXNTO__=1 -D__aarch64__=1 -D__ORDER_LITTLE_ENDIAN__=1234 -D__FLOAT_WORD_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__ORDER_PDP_ENDIAN__=3412 -D__LITTLEENDIAN__=1 -D__ORDER_BIG_ENDIAN__=4321 -D__BYTE_ORDER__=__ORDER_LITTLE_ENDIAN__ -D__EXT=1 -nostdinc++")
# includes
SET(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -isystem /opt/qnx700/host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx7.0.0/5.4.0/include -isystem /opt/qnx700/target/qnx7/usr/include -isystem /opt/qnx700/target/qnx7/usr/include/aarch64")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -isystem /opt/qnx700/host/linux/x86_64/usr/lib/gcc/aarch64-unknown-nto-qnx7.0.0/5.4.0/include -isystem /opt/qnx700/target/qnx7/usr/include -isystem /opt/qnx700/target/qnx7/usr/include/aarch64 -isystem /opt/qnx700/target/qnx7/usr/include/c++/5.4.0/ -isystem /opt/qnx700/target/qnx7/usr/include/c++/5.4.0/aarch64-unknown-nto-qnx7.0.0")

# C compiler and default flags
SET(CMAKE_C_COMPILER               ${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-gcc${HOST_EXECUTABLE_SUFFIX})
set(CMAKE_C_FLAGS_DEBUG            "${CMAKE_C_FLAGS} -g -D_DEBUG"                                CACHE STRING "QNX C flags for Debug")
set(CMAKE_C_FLAGS_RELEASE          "${CMAKE_C_FLAGS} -O2 -DNDEBUG"                               CACHE STRING "QNX C flags for Release")
set(CMAKE_C_FLAGS_RELWITHDEBINFO   "${CMAKE_C_FLAGS} -O2 -g"                                     CACHE STRING "QNX C flags for RelWithDebInfo")

# C++ compiler and default flags
SET(CMAKE_CXX_COMPILER             ${QNX_HOST}/usr/bin/nto${CMAKE_SYSTEM_PROCESSOR}-c++${HOST_EXECUTABLE_SUFFIX})
set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++")
set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS} -g -D_DEBUG"                 CACHE STRING "QNX CXX flags for Debug")
set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS} -O2 -DNDEBUG"                CACHE STRING "QNX CXX flags for Release")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS} -O2 -g"                      CACHE STRING "QNX CXX flags for RelWithDebInfo")

SET(CMAKE_FIND_ROOT_PATH ${QNX_TARGET} ${QNX_TARGET}/aarch64le)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Dump toolchain info
get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)
if(NOT _CMAKE_IN_TRY_COMPILE AND NOT _TOOLCHAIN_INFO)
message("===========================================================================")
message(" TOOLCHAIN: ${TOOLCHAIN}")
message("---------------------------------------------------------------------------")
message("- QNX_BASE:               " ${QNX_BASE})
message("- QNX_HOST:               " ${QNX_HOST})
message("- QNX_TARGET:             " ${QNX_TARGET})
message("- QNX_CONFIGURATION:      " ${QNX_CONFIGURATION})
message("- MAKEFLAGS:              " ${MAKEFLAGS})
message("- TMPDIR:                 " ${TMPDIR})
message("- CMAKE_MAKE_PROGRAM:     " ${CMAKE_MAKE_PROGRAM})
message("- CMAKE_C_COMPILER:       " ${CMAKE_C_COMPILER})
message("- CMAKE_CXX_COMPILER:     " ${CMAKE_CXX_COMPILER})
message("- CMAKE_BUILD_TYPE:       " ${CMAKE_BUILD_TYPE})
message("- CMAKE_SYSTEM_NAME:      " ${CMAKE_SYSTEM_NAME})
message("- CMAKE_SYSTEM_VERSION:   " ${CMAKE_SYSTEM_VERSION})
message("- CMAKE_SYSTEM_PROCESSOR: " ${CMAKE_SYSTEM_PROCESSOR})
message("===========================================================================")
SET(_TOOLCHAIN_INFO 1)
endif()
