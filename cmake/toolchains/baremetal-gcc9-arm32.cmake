set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cortex-m4)

set(CMAKE_SHARED_LIBRARY_PREFIX "lib")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".so")
set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")

if(CMAKE_HOST_WIN32)
  set(HOST_EXE_SUFFIX ".exe")
endif()

set(TOOLCHAIN_ROOT     "$ENV{COMPILER_PATH}" CACHE PATH "NXP Toolchain path")
set(SYSROOT            "${TOOLCHAIN_ROOT}/../arm-none-eabi/lib/arm/v5te/hard" CACHE PATH "NXP Toolchain sysroot")
set(LINKER_FILE_DIR    "$ENV{LINKER_FILE_DIR}" CACHE PATH "NXP Linker file path")

set(CMAKE_AR           "${TOOLCHAIN_ROOT}/arm-none-eabi-ar${HOST_EXE_SUFFIX}"      CACHE FILEPATH "The toolchain ar command " FORCE)
set(CMAKE_RANLIB       "${TOOLCHAIN_ROOT}/arm-none-eabi-ranlib${HOST_EXE_SUFFIX}"  CACHE FILEPATH "The toolchain ranlib command " FORCE)
set(CMAKE_NM           "${TOOLCHAIN_ROOT}/arm-none-eabi-nm${HOST_EXE_SUFFIX}"      CACHE FILEPATH "The toolchain nm command " FORCE)
set(CMAKE_OBJCOPY      "${TOOLCHAIN_ROOT}/arm-none-eabi-objcopy${HOST_EXE_SUFFIX}" CACHE FILEPATH "The toolchain objcopy command " FORCE)
set(CMAKE_OBJDUMP      "${TOOLCHAIN_ROOT}/arm-none-eabi-objdump${HOST_EXE_SUFFIX}" CACHE FILEPATH "The toolchain objdump command " FORCE)
set(CMAKE_LINKER       "${TOOLCHAIN_ROOT}/arm-none-eabi-ld${HOST_EXE_SUFFIX}"      CACHE FILEPATH "The toolchain ld command " FORCE)
set(CMAKE_STRIP        "${TOOLCHAIN_ROOT}/arm-none-eabi-strip${HOST_EXE_SUFFIX}"   CACHE FILEPATH "The toolchain strip command " FORCE)

set(CMAKE_C_COMPILER   "${TOOLCHAIN_ROOT}/arm-none-eabi-gcc${HOST_EXE_SUFFIX}")
set(CMAKE_CXX_COMPILER "${TOOLCHAIN_ROOT}/arm-none-eabi-g++${HOST_EXE_SUFFIX}")

# C compiler and default flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99 -DCPU_S32G274A -DDEV_ERROR_DETECT -DAUTOSAR_OS_NOT_USED -DUSING_OS_FREERTOS -fshort-enums -fno-jump-tables")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -funsigned-char -pedantic -Wall -Wextra -c -fmessage-length=0 -funsigned-bitfields -ffunction-sections -fdata-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fno-common -Wstrict-prototypes -Wsign-compare -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --sysroot=\"${SYSROOT}\"")

if (LINKER_FILE_DIR)
  set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -T \"${LINKER_FILE_DIR}/S32G274A_common_ram.ld\"")
  set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -T \"${LINKER_FILE_DIR}/S32G274A_0/S32G274A_ram.ld\"")
else()
  set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -T \"${SYSROOT}/redboot.ld\"")
endif()
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} --entry=Reset_Handler -Wl,-Map=main.map -Xlinker --gc-sections -n -mcpu=cortex-m7 -mthumb -mfloat-abi=hard -mfpu=fpv5-sp-d16")
set(CMAKE_C_LINK_FLAGS "${CMAKE_C_LINK_FLAGS} -specs=${SYSROOT}/nano.specs --sysroot=\"${SYSROOT}\"")

set(CMAKE_EXE_LINKER_FLAGS "-mthumb -mcpu=cortex-m7 -nostartfiles -Wl,--gc-sections" CACHE INTERNAL "exe link flags")

set(CMAKE_C_FLAGS_DEBUG            "${CMAKE_C_FLAGS} -g -O1 -D_DEBUG"             CACHE STRING "QNX C flags for Debug")
set(CMAKE_C_FLAGS_RELEASE          "${CMAKE_C_FLAGS} -O2 -DNDEBUG"                CACHE STRING "QNX C flags for Release")
set(CMAKE_C_FLAGS_RELWITHDEBINFO   "${CMAKE_C_FLAGS} -O2 -g"                      CACHE STRING "QNX C flags for RelWithDebInfo")

# C++ compiler and default flags
# TODO: rework for GCCv9.2 BareMetal
set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -Wall")
set(CMAKE_CXX_FLAGS                "${CMAKE_CXX_FLAGS} -std=gnu++11")
set(CMAKE_CXX_FLAGS_DEBUG          "${CMAKE_CXX_FLAGS} -g -O1 -D_DEBUG"           CACHE STRING "QNX CXX flags for Debug")
set(CMAKE_CXX_FLAGS_RELEASE        "${CMAKE_CXX_FLAGS} -O2 -DNDEBUG"              CACHE STRING "QNX CXX flags for Release")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS} -O2 -g"                    CACHE STRING "QNX CXX flags for RelWithDebInfo")
