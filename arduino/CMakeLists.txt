set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/../lib")

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
        "${ARDUINO_ESP8266_DIR}/cores/esp8266"
        "${ARDUINO_ESP8266_DIR}/variants/generic"
        "${ARDUINO_ESP8266_DIR}/tools/sdk/include"
        "${ARDUINO_ESP8266_DIR}/tools/sdk/lwip2/include")

target_compile_definitions(arduino PUBLIC
        -DF_CPU=80000000L
        -DARDUINO=10809
        -DARDUINO_ESP8266_GENERIC
        -DARDUINO_ARCH_ESP8266
        -DARDUINO_BOARD="ESP8266_GENERIC"
        -DBEARSSL_SSL_BASIC
        -DESP8266
        -DLWIP_OPEN_SRC
        -DLWIP_FEATURES=1
        -DLWIP_IPV6=0
        -DNONOSDK221=1
        -DTCP_MSS=536)

target_compile_options(arduino PUBLIC)

install(TARGETS arduino ARCHIVE DESTINATION lib)

add_subdirectory(libraries)
