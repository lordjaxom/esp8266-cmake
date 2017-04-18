# Compute the installation prefix relative to this file.
get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)

find_library(ESP8266_SDK_LIB_AT at ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_AXTLS axtls ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_CRYPTO crypto ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_ESPNOW espnow ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_HAL hal ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_JSON json ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_LWIP lwip ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_LWIP_GCC lwip_gcc ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_MAIN main ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_MESH mesh ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_NET80211 net80211 ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_PHY phy ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_PP pp ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_PWM pwm ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_SMARTCONFIG smartconfig ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_SSL ssl ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_UPGRADE upgrade ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_WPA wpa ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_WPA2 wpa2 ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)
find_library(ESP8266_SDK_LIB_WPS wps ${ARDUINO_ESP8266_DIR}/tools/sdk/lib)

add_library(arduino STATIC IMPORTED)

set(ARDUINO_INC_DIRS
    ${_IMPORT_PREFIX}/h
    ${_IMPORT_PREFIX}/h/variants/generic
    ${_IMPORT_PREFIX}/h/tools/sdk/include
    ${_IMPORT_PREFIX}/h/libraries/SPI
    ${_IMPORT_PREFIX}/h/libraries/Wire
    ${_IMPORT_PREFIX}/h/tools/sdk/lwip/include
    ${_IMPORT_PREFIX}/h/libraries/ESP8266WiFi
    ${_IMPORT_PREFIX}/h/libraries/ESP8266WiFi/include
    ${_IMPORT_PREFIX}/h/libraries/ESP8266Webserver
)

set(ARDUINO_DEP_LIBS
    ${ESP8266_SDK_LIB_AXTLS}
    ${ESP8266_SDK_LIB_CRYPTO}
    ${ESP8266_SDK_LIB_ESPNOW}
    ${ESP8266_SDK_LIB_HAL}
    ${ESP8266_SDK_LIB_LWIP_GCC}
    ${ESP8266_SDK_LIB_MAIN}
    ${ESP8266_SDK_LIB_MESH}
    ${ESP8266_SDK_LIB_NET80211}
    ${ESP8266_SDK_LIB_PHY}
    ${ESP8266_SDK_LIB_PP}
    ${ESP8266_SDK_LIB_SMARTCONFIG}
    ${ESP8266_SDK_LIB_UPGRADE}
    ${ESP8266_SDK_LIB_WPA}
    ${ESP8266_SDK_LIB_WPA2}
    ${ESP8266_SDK_LIB_WPS}
    m
    c
    gcc
    stdc++
)

set(ARDUINO_DEFINITIONS
    F_CPU=80000000L
    ARDUINO=10801
    ARDUINO_ESP8266_ESP01
    ARDUINO_ARCH_ESP8266
    ARDUINO_BOARD="ESP8266_ESP01"
    ESP8266
    LWIP_OPEN_SRC
)

set(ARDUINO_OPTIONS
    -U__STRICT_ANSI__
)

set_target_properties(arduino PROPERTIES
    IMPORTED_LOCATION ${_IMPORT_PREFIX}/lib/libarduino.a
    INTERFACE_LINK_LIBRARIES "${ARDUINO_DEP_LIBS}"
    INTERFACE_INCLUDE_DIRECTORIES "${ARDUINO_INC_DIRS}"
    INTERFACE_COMPILE_DEFINITIONS "${ARDUINO_DEFINITIONS}"
    INTERFACE_COMPILE_OPTIONS "${ARDUINO_OPTIONS}"
)
