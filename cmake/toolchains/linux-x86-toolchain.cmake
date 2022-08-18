set(LINUX_KERNEL_BUILD_DIRECTORY /usr/src/linux-headers-4.9.0-9-amd64/)
set(LINUX_KERNEL_ARCH "ARCH=generic")

# C compiler and default flags
set(CMAKE_C_COMPILER               "gcc" CACHE PATH "Cross C compiler")
set(CMAKE_C_FLAGS                  "${CMAKE_C_FLAGS} -Wall -Wextra -Wundef -Wunused -Wpedantic" CACHE STRING "C Flags")
set(CMAKE_C_FLAGS_DEBUG            "${CMAKE_C_FLAGS} -g -D_DEBUG"                 CACHE STRING "C Flags Debug")
set(CMAKE_C_FLAGS_RELEASE          "${CMAKE_C_FLAGS} -O2 -DNDEBUG"                CACHE STRING "C Flags Release")
set(CMAKE_C_FLAGS_RELWITHDEBINFO   "${CMAKE_C_FLAGS} -O2 -g"                      CACHE STRING "C Flags RelWithDebInfo")

# C++ compiler and default flags
set(CMAKE_CXX_COMPILER             "g++" CACHE PATH "Cross C++ compiler")
set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -Wall -Wextra -Wunused -Wpedantic" CACHE STRING "CXX Flags") # -Wundef is removed because google test files can not be compiled with that flag enabled
set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS} -std=c++11 -g -D_DEBUG"  CACHE STRING "CXX Flags Debug")
set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS} -std=c++11 -O2 -DNDEBUG" CACHE STRING "CXX Flags Release")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS} -std=c++11 -O2 -g"       CACHE STRING "CXX Flags RelWithDebInfo")
