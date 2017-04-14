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
include(CheckESP8266Flash)
include(CheckESP8266ComPort)

set(ESP8266_XTENSA_C_COMPILER "${ARDUINO_ESP8266_TOOLS}/xtensa-lx106-elf/bin/xtensa-lx106-elf-gcc${ESP8266_EXEC_SUFFIX}")
set(ESP8266_XTENSA_CXX_COMPILER "${ARDUINO_ESP8266_TOOLS}/xtensa-lx106-elf/bin/xtensa-lx106-elf-g++${ESP8266_EXEC_SUFFIX}")
set(ESP8266_XTENSA_SIZE "${ARDUINO_ESP8266_TOOLS}/xtensa-lx106-elf/bin/xtensa-lx106-elf-size${ESP8266_EXEC_SUFFIX}")
set(ESP8266_ESPTOOL "${ARDUINO_ESP8266_TOOLS}/esptool/esptool${ESP8266_EXEC_SUFFIX}")

message(STATUS "Using ARDUINO_ESP8266_DIR ${ARDUINO_ESP8266_DIR}")
message(STATUS "Using ARDUINO_ESP8266_TOOLS ${ARDUINO_ESP8266_TOOLS}")
message(STATUS "Using ${ESP8266_XTENSA_C_COMPILER} C compiler")
message(STATUS "Using ${ESP8266_XTENSA_CXX_COMPILER} C++ compiler")
message(STATUS "Using ${ESP8266_XTENSA_SIZE} size")
message(STATUS "Using ${ESP8266_ESPTOOL} esptool")

set(CMAKE_C_COMPILER "${ESP8266_XTENSA_C_COMPILER}")
set(CMAKE_CXX_COMPILER "${ESP8266_XTENSA_CXX_COMPILER}")

set(COMMON_FLAGS "-ffunction-sections -fdata-sections -falign-functions=4 -mlongcalls -nostdlib -mtext-section-literals -DICACHE_FLASH -D__ets__")
set(OPTIMIZE_FLAGS "-Os -g")

set(CMAKE_C_FLAGS "-std=gnu99 -pipe -Wpointer-arith -Wno-implicit-function-declaration -fno-inline-functions ${COMMON_FLAGS} ${OPTIMIZE_FLAGS}" CACHE STRING "C compiler flags" FORCE)
set(CMAKE_CXX_FLAGS "-std=c++11 -fno-exceptions -fno-rtti -MMD ${COMMON_FLAGS} ${OPTIMIZE_FLAGS}" CACHE STRING "C++ compiler flags" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "-nostdlib -Wl,--no-check-sections -Wl,-static -Wl,--gc-sections -L\"${ARDUINO_ESP8266_DIR}/tools/sdk/libc/xtensa-lx106-elf/lib\" -L\"${ARDUINO_ESP8266_DIR}/tools/sdk/ld\" -Teagle.flash.${ESP8266_FLASH_LAYOUT}.ld -u call_user_start -u _printf_float -u _scanf_float -Wl,-wrap,system_restart_local -Wl,-wrap,spi_flash_read" CACHE STRING "Linker flags" FORCE)

set(CMAKE_C_LINK_EXECUTABLE "<CMAKE_C_COMPILER> <FLAGS> <CMAKE_C_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> -o <TARGET> -Wl,--start-group <OBJECTS> <LINK_LIBRARIES> -Wl,--end-group")
