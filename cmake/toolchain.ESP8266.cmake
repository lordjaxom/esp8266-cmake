# Sets up a toolchain from Arduino ESP8266 core
#
# Reads settings from the following variables:
#
#   ESP8266_FLASH          - The flash memory layout of the ESP8266
#   ARDUINO_ESP8266_DIR    - ESP8266 core directory
#   ARDUINO_ESP8266_TOOLS  - ESP8266 tools directory
#   ARDUINO_SKETCHES_DIR   - Path to Arduino sketches directory
#   ARDUINO_LIBRARIES      - List of libraries to include from Arduino
#
#
# Uses hints from the following variables:
#
#   ARDUINO_HOME           - Arduino installation directory
#   ARDUINO_USER           - Arduino user settings directory
#

set(CMAKE_SYSTEM_NAME ESP8266)
set(CMAKE_SYSTEM_VERSION 1)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/Modules")

include(CheckESP8266HostDefaults)
include(CheckESP8266CoreDir)
include(CheckESP8266ToolsDir)

file(GLOB_RECURSE ESP8266_XTENSA_C_COMPILER "${ARDUINO_ESP8266_TOOLS}/xtensa-lx106-elf-gcc${ESP8266_EXEC_SUFFIX}")
get_filename_component(ESP8266_XTENSA_PATH "${ESP8266_XTENSA_C_COMPILER}" DIRECTORY)
set(ESP8266_XTENSA_CXX_COMPILER "${ESP8266_XTENSA_PATH}/xtensa-lx106-elf-g++${ESP8266_EXEC_SUFFIX}")
set(ESP8266_XTENSA_SIZE "${ESP8266_XTENSA_PATH}/xtensa-lx106-elf-size${ESP8266_EXEC_SUFFIX}")
file(GLOB_RECURSE ESP8266_PYTHON "${ARDUINO_ESP8266_TOOLS}/python${ESP8266_EXEC_SUFFIX}")

message(STATUS "Using ARDUINO_ESP8266_DIR ${ARDUINO_ESP8266_DIR}")
message(STATUS "Using ARDUINO_ESP8266_TOOLS ${ARDUINO_ESP8266_TOOLS}")
message(STATUS "Using ${ESP8266_XTENSA_PATH} xtensa path")
message(STATUS "Using ${ESP8266_XTENSA_C_COMPILER} C compiler")
message(STATUS "Using ${ESP8266_XTENSA_CXX_COMPILER} C++ compiler")
message(STATUS "Using ${ESP8266_XTENSA_SIZE} size")
message(STATUS "Using ${ESP8266_PYTHON} python")

set(ESP8266_ELF2BIN_PY "${ARDUINO_ESP8266_DIR}/tools/elf2bin.py")
set(ESP8266_UPLOAD_PY "${ARDUINO_ESP8266_DIR}/tools/upload.py")

set(CMAKE_C_COMPILER "${ESP8266_XTENSA_C_COMPILER}")
set(CMAKE_CXX_COMPILER "${ESP8266_XTENSA_CXX_COMPILER}")

set(COMMON_FLAGS "-ffunction-sections -fdata-sections -falign-functions=4 -mlongcalls -nostdlib -mtext-section-literals -DICACHE_FLASH -D__ets__ -U__STRICT_ANSI__")
set(OPTIMIZE_FLAGS "-Os")

set(CMAKE_C_FLAGS "-std=gnu99 -pipe -Wpointer-arith -Wno-implicit-function-declaration -fno-inline-functions ${COMMON_FLAGS} ${OPTIMIZE_FLAGS}" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_CXX_FLAGS "-std=c++11 -fno-exceptions -fno-rtti ${COMMON_FLAGS} ${OPTIMIZE_FLAGS}" CACHE STRING "C++ compiler flags" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG" CACHE STRING "C++ compiler flags release" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "-nostdlib -Wl,--no-check-sections -Wl,-static -Wl,--gc-sections -L\"${ARDUINO_ESP8266_DIR}/tools/sdk/libc/xtensa-lx106-elf/lib\" -u app_entry -u _printf_float -u _scanf_float -Wl,-wrap,system_restart_local -Wl,-wrap,spi_flash_read" CACHE STRING "Linker flags" FORCE)

set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")
