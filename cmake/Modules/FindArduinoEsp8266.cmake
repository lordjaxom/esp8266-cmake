# Compute the installation prefix relative to this file.
get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)

include(FindPackageHandleStandardArgs)

include(CheckESP8266Flash)
include(CheckESP8266ComPort)

find_library(ESP8266_SDK_LIB_AT at "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_AXTLS axtls "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_CRYPTO crypto "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_ESPNOW espnow "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_HAL hal "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_JSON json "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_LWIP lwip "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_LWIP_GCC lwip_gcc "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_MAIN main "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_MESH mesh "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_NET80211 net80211 "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_PHY phy "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_PP pp "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_PWM pwm "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_SMARTCONFIG smartconfig "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_SSL ssl "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_UPGRADE upgrade "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_WPA wpa "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_WPA2 wpa2 "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")
find_library(ESP8266_SDK_LIB_WPS wps "${ARDUINO_ESP8266_DIR}/tools/sdk/lib")

set(ARDUINO_INC_DIRS
        "${ARDUINO_ESP8266_DIR}/cores/esp8266"
        "${ARDUINO_ESP8266_DIR}/tools/sdk/include"
        "${ARDUINO_ESP8266_DIR}/variants/generic"
        "${ARDUINO_ESP8266_DIR}/tools/sdk/lwip/include")

set(ARDUINO_DEP_LIBS
        "${ESP8266_SDK_LIB_AXTLS}"
        "${ESP8266_SDK_LIB_CRYPTO}"
        "${ESP8266_SDK_LIB_ESPNOW}"
        "${ESP8266_SDK_LIB_HAL}"
        "${ESP8266_SDK_LIB_LWIP_GCC}"
        "${ESP8266_SDK_LIB_MAIN}"
        "${ESP8266_SDK_LIB_MESH}"
        "${ESP8266_SDK_LIB_NET80211}"
        "${ESP8266_SDK_LIB_PHY}"
        "${ESP8266_SDK_LIB_PP}"
        "${ESP8266_SDK_LIB_SMARTCONFIG}"
        "${ESP8266_SDK_LIB_UPGRADE}"
        "${ESP8266_SDK_LIB_WPA}"
        "${ESP8266_SDK_LIB_WPA2}"
        "${ESP8266_SDK_LIB_WPS}"
        m
        c
        gcc
        stdc++)

set(ARDUINO_DEFINITIONS
        F_CPU=80000000L
        ARDUINO=10801
        ARDUINO_ESP8266_ESP01
        ARDUINO_ARCH_ESP8266
        ARDUINO_BOARD="ESP8266_ESP01"
        ESP8266
        LWIP_OPEN_SRC)

set(ARDUINO_OPTIONS
        -U__STRICT_ANSI__
        -include Arduino.h)

find_library(ARDUINO_LIBRARY arduino HINTS "${_IMPORT_PREFIX}/lib")
find_package_handle_standard_args(ArduinoEsp8266 DEFAULT_MSG ARDUINO_LIBRARY)

add_library(arduino STATIC IMPORTED)
set_target_properties(arduino PROPERTIES
        IMPORTED_LOCATION "${ARDUINO_LIBRARY}"
        INTERFACE_LINK_LIBRARIES "${ARDUINO_DEP_LIBS}"
        INTERFACE_INCLUDE_DIRECTORIES "${ARDUINO_INC_DIRS}"
        INTERFACE_COMPILE_DEFINITIONS "${ARDUINO_DEFINITIONS}"
        INTERFACE_COMPILE_OPTIONS "${ARDUINO_OPTIONS}")

list(APPEND ArduinoEsp8266_LIBRARIES "arduino")

foreach(LIB ${ArduinoEsp8266_FIND_COMPONENTS})

    if(IS_DIRECTORY "${ARDUINO_ESP8266_DIR}/libraries/${LIB}")
        set(LIB_DIR "${ARDUINO_ESP8266_DIR}/libraries/${LIB}")
    elseif(IS_DIRECTORY "${ARDUINO_HOME}/libraries/${LIB}")
        set(LIB_DIR "${ARDUINO_HOME}/libraries/${LIB}")
    elseif(NOT "${ARDUINO_SKETCHBOOK}" STREQUAL "" AND IS_DIRECTORY "${ARDUINO_SKETCHBOOK}/libraries/${LIB}")
        set(LIB_DIR "${ARDUINO_SKETCHBOOK}/libraries/${LIB}")
    else()
        message(FATAL_ERROR "Library ${LIB} not found")
    endif()

    if(IS_DIRECTORY "${LIB_DIR}/src")
        set(LIB_SRC_DIR "${LIB_DIR}/src")
    else()
        set(LIB_SRC_DIR "${LIB_DIR}")
    endif()

    find_library("${LIB}_LIBRARY" "${LIB}" HINTS "${_IMPORT_PREFIX}/lib")
    find_package_handle_standard_args("${LIB}" DEFAULT_MSG "${LIB}_LIBRARY")

    add_library("${LIB}" STATIC IMPORTED)
    set_target_properties("${LIB}" PROPERTIES
            IMPORTED_LOCATION "${${LIB}_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${LIB_SRC_DIR}")

    list(APPEND ArduinoEsp8266_LIBRARIES "${LIB}")

endforeach()

include(FindArduinoEsp8266Targets)