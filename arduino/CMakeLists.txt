set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/../lib")

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

file(GLOB_RECURSE ARDUINO_SRC_C "${ARDUINO_ESP8266_DIR}/cores/esp8266/*.c")
file(GLOB_RECURSE ARDUINO_SRC_CXX "${ARDUINO_ESP8266_DIR}/cores/esp8266/*.cpp")
file(GLOB_RECURSE ARDUINO_SRC_ASM "${ARDUINO_ESP8266_DIR}/cores/esp8266/*.S")

set_source_files_properties(${ARDUINO_SRC_ASM} PROPERTIES
        LANGUAGE ASM
        COMPILE_FLAGS "${CMAKE_C_FLAGS} ${CMAKE_C_FLAGS_DEBUG}")

add_library(arduino STATIC
        ${ARDUINO_SRC_C}
        ${ARDUINO_SRC_CXX}
        ${ARDUINO_SRC_ASM})

target_include_directories(arduino PUBLIC
        ${ARDUINO_ESP8266_DIR}/cores/esp8266
        ${ARDUINO_ESP8266_DIR}/tools/sdk/include
        ${ARDUINO_ESP8266_DIR}/variants/generic
        ${ARDUINO_ESP8266_DIR}/tools/sdk/lwip/include)

target_compile_definitions(arduino PUBLIC
        -DF_CPU=80000000L
        -DARDUINO=10801
        -DARDUINO_ESP8266_ESP01
        -DARDUINO_ARCH_ESP8266
        -DARDUINO_BOARD="ESP8266_ESP01"
        -DESP8266
        -DLWIP_OPEN_SRC)

target_compile_options(arduino PUBLIC
        -U__STRICT_ANSI__)

install(TARGETS arduino ARCHIVE DESTINATION lib)

add_subdirectory(libraries)
#add_subdirectory(extlib)
