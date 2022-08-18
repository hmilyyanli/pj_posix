set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(TOOLCHAIN Cross)
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE arm64)

set(CROSS_COMPILE   "aarch64-linux-gnu-")

# Executable suffix
IF(CMAKE_HOST_WIN32)
  SET(HOST_EXECUTABLE_SUFFIX ".exe")
ENDIF(CMAKE_HOST_WIN32)

# Library prefix and suffix
set(CMAKE_SHARED_LIBRARY_PREFIX "lib")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".so")
set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")

# C compiler and default flags
set(CMAKE_C_COMPILER   	           "${CROSS_COMPILE}gcc${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "Cross C compiler")
set(CMAKE_C_FLAGS                  "${CMAKE_C_FLAGS} -Wall -Wextra -Wundef -Wunused -Wpedantic" CACHE STRING "Cross C Flags")
set(CMAKE_C_FLAGS_DEBUG            "${CMAKE_C_FLAGS} -g -D_DEBUG"                 CACHE STRING "Cross C Flags Debug")
set(CMAKE_C_FLAGS_RELEASE          "${CMAKE_C_FLAGS} -O2 -DNDEBUG"                CACHE STRING "Cross C Flags Release")
set(CMAKE_C_FLAGS_RELWITHDEBINFO   "${CMAKE_C_FLAGS} -O2 -g"                      CACHE STRING "Cross C Flags RelWithDebInfo")

# C++ compiler and default flags
set(CMAKE_CXX_COMPILER             "${CROSS_COMPILE}g++${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "Cross C++ compiler")
set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wunused -Wpedantic" CACHE STRING "Cross CXX Flags") # -Wundef is removed because google test files can not be compiled with that flag enabled
set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS} -std=c++11 -g -D_DEBUG"  CACHE STRING "Cross CXX Flags Debug")
set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS} -std=c++11 -O2 -DNDEBUG" CACHE STRING "Cross CXX Flags Release")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS} -std=c++11 -O2 -g"       CACHE STRING "Cross CXX Flags RelWithDebInfo")

# Other tools
set(CMAKE_AR           "${CROSS_COMPILE}ar${HOST_EXECUTABLE_SUFFIX}"      CACHE PATH "Cross ar")
set(CMAKE_RANLIB       "${CROSS_COMPILE}ranlib${HOST_EXECUTABLE_SUFFIX}"  CACHE PATH "Cross ranlib")
set(CMAKE_NM           "${CROSS_COMPILE}nm${HOST_EXECUTABLE_SUFFIX}"      CACHE PATH "Cross nm")
set(CMAKE_OBJCOPY      "${CROSS_COMPILE}objcopy${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "Cross objcopy")
set(CMAKE_OBJDUMP      "${CROSS_COMPILE}objdump${HOST_EXECUTABLE_SUFFIX}" CACHE PATH "Cross objdump")
set(CMAKE_LINKER       "${CROSS_COMPILE}ld{HOST_EXECUTABLE_SUFFIX}"       CACHE PATH "Cross linker")
set(CMAKE_STRIP        "${CROSS_COMPILE}strip${HOST_EXECUTABLE_SUFFIX}"   CACHE PATH "Cross strip")

SET(CMAKE_SYSROOT        $ENV{SYSROOT})
SET(CMAKE_FIND_ROOT_PATH $ENV{SYSROOT})
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)