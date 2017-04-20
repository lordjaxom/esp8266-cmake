set(CMAKE_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/cmake/toolchain.ESP8266.cmake")

cmake_minimum_required(VERSION 3.5)
project(ArduinoEsp8266 VERSION 0.1.0 LANGUAGES C CXX ASM)

add_subdirectory(arduino)

if (EXISTS "${ARDUINO_ESP8266_DIR}/platform.txt")
    file(STRINGS "${ARDUINO_ESP8266_DIR}/platform.txt" VERSION_LINES REGEX "^version=")
    if (VERSION_LINES)
        string(REGEX MATCH "[0-9]+\.[0-9]+\.[0-9]+" ARDUINO_VERSION ${VERSION_LINES})
    endif ()
endif ()

install(DIRECTORY cmake/Modules DESTINATION cmake)
install(DIRECTORY cmake DESTINATION / FILES_MATCHING PATTERN "toolchain.*.cmake")
