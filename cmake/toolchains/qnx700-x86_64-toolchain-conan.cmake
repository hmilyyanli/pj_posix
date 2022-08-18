SET(CMAKE_SYSTEM_NAME QNX)
SET(CMAKE_SYSTEM_VERSION 7.0.0)
# We have to separate PROCESSOR and CMAKE_SYSTEM_PROCESSOR as dependant variable need a suffix.
SET(PROCESSOR x86_64)
SET(CMAKE_SYSTEM_PROCESSOR ${PROCESSOR})
SET(TOOLCHAIN QNX)

if(CMAKE_TOOLCHAIN_FILE)
# touch toolchain variable to suppress "unused variable" warning
endif()

# Use architecture dependent variable to create the parameter given to QCC
set(QNX_ARCH_TARGET ${QNX_COMPILER_VERSION},gcc_nto${CMAKE_SYSTEM_PROCESSOR})

#SET(CMAKE_IMPORT_LIBRARY_SUFFIX ".a")

SET(CMAKE_SHARED_LIBRARY_PREFIX "lib")
SET(CMAKE_SHARED_LIBRARY_SUFFIX ".so")
SET(CMAKE_STATIC_LIBRARY_PREFIX "lib")
SET(CMAKE_STATIC_LIBRARY_SUFFIX ".a")

SET(QNX_HOST    $ENV{QNX_HOST})
SET(QNX_TARGET  $ENV{QNX_TARGET})
SET(MAKEFLAGS   $ENV{MAKEFLAGS})
SET(TMPDIR  $ENV{TMP})

SET(CMAKE_MAKE_PROGRAM  "${QNX_HOST}/usr/bin/make"                                 CACHE PATH "QNX make program")
SET(CMAKE_AR            "${QNX_HOST}/usr/bin/nto${PROCESSOR}-ar"      CACHE PATH "QNX ar program")
SET(CMAKE_RANLIB        "${QNX_HOST}/usr/bin/nto${PROCESSOR}-ranlib"  CACHE PATH "QNX ranlib program")
SET(CMAKE_NM            "${QNX_HOST}/usr/bin/nto${PROCESSOR}-nm"      CACHE PATH "QNX nm program")
SET(CMAKE_OBJCOPY       "${QNX_HOST}/usr/bin/nto${PROCESSOR}-objcopy" CACHE PATH "QNX objcopy program")
SET(CMAKE_OBJDUMP       "${QNX_HOST}/usr/bin/nto${PROCESSOR}-objdump" CACHE PATH "QNX objdump program")
SET(CMAKE_LINKER        "${QNX_HOST}/usr/bin/nto${PROCESSOR}-ld"      CACHE PATH "QNX linker program")
SET(CMAKE_STRIP         "${QNX_HOST}/usr/bin/nto${PROCESSOR}-strip"   CACHE PATH "QNX Strip program")

# C compiler and default flags
SET(CMAKE_C_COMPILER                ${QNX_HOST}/usr/bin/qcc                        CACHE PATH   "QNX C Compiler")
set(CMAKE_C_FLAGS                   "-V${QNX_ARCH_TARGET}"                         CACHE STRING "QNX C Flags")
string(APPEND CMAKE_C_FLAGS         " -Wall -Wextra -Wundef -Wunused -Wpedantic")
set(CMAKE_C_FLAGS_DEBUG             "${CMAKE_C_FLAGS} -g -D_DEBUG"                 CACHE STRING "QNX C flags for Debug")
set(CMAKE_C_FLAGS_RELEASE           "${CMAKE_C_FLAGS} -O2 -DNDEBUG"                CACHE STRING "QNX C flags for Release")
set(CMAKE_C_FLAGS_RELWITHDEBINFO    "${CMAKE_C_FLAGS} -O2 -g"                      CACHE STRING "QNX C flags for RelWithDebInfo")

# C++ compiler and default flags
SET(CMAKE_CXX_COMPILER              ${QNX_HOST}/usr/bin/q++                        CACHE PATH   "QNX CXX Compiler")
set(CMAKE_CXX_FLAGS                 "-V${QNX_ARCH_TARGET} "                        CACHE STRING "QNX CXX Flags")
# -Wundef is removed from CMAKE_CXX_FLAGS because google test files can not be compiled with that flag enabled
string(APPEND CMAKE_CXX_FLAGS       " -Wall -Wextra -Wunused -Wpedantic -D_GLIBCXX_USE_C99=1 -std=gnu++11 -stdlib=libc++")
set(CMAKE_CXX_FLAGS                 "${CMAKE_CXX_FLAGS} -std=gnu++11 -stdlib=libc++")
set(CMAKE_CXX_FLAGS_DEBUG           "${CMAKE_CXX_FLAGS} -g -D_DEBUG"               CACHE STRING "QNX CXX flags for Debug")
set(CMAKE_CXX_FLAGS_RELEASE         "${CMAKE_CXX_FLAGS} -O2 -DNDEBUG"              CACHE STRING "QNX CXX flags for Release")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "${CMAKE_CXX_FLAGS} -O2 -g"                    CACHE STRING "QNX CXX flags for RelWithDebInfo")

SET(CMAKE_FIND_ROOT_PATH ${QNX_TARGET} ${QNX_TARGET}/x86_64)
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
