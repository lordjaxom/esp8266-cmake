cmake_minimum_required(VERSION 3.5)
project(ArduinoBuild VERSION 0.9.0 LANGUAGES C CXX ASM)

cmake_policy(SET CMP0048 NEW)

if ("${ARDUINO_ESP8266_DIR}" STREQUAL "")
    message(FATAL_ERROR "ARDUINO_ESP8266_DIR not set, did you forget CMAKE_TOOLCHAIN_FILE?")
endif ()
if ("${ARDUINO_ESP8266_TOOLS}" STREQUAL "")
    message(FATAL_ERROR "ARDUINO_ESP8266_TOOLS not set, did you forget CMAKE_TOOLCHAIN_FILE?")
endif ()

add_subdirectory(arduino)

if (EXISTS "${ARDUINO_ESP8266_DIR}/platform.txt")
    file(STRINGS "${ARDUINO_ESP8266_DIR}/platform.txt" VERSION_LINES REGEX "^version=")
    if (VERSION_LINES)
        string(REGEX MATCH "[0-9]+\.[0-9]+\.[0-9]+" ARDUINO_VERSION ${VERSION_LINES})
    endif ()
endif ()

install(DIRECTORY cmake/Modules DESTINATION cmake)
install(DIRECTORY cmake DESTINATION / FILES_MATCHING PATTERN "toolchain.*.cmake")

set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_FILE_NAME Arduino-${ARDUINO_VERSION})
set(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)

include(CPack)
