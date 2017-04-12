message("****** CORE")
message("Hier ARDUINO_ESP8266_TOOLS: ${ARDUINO_ESP8266_TOOLS}")
message("Hier ARDUINO_ESP8266_DIR: ${ARDUINO_ESP8266_DIR}")
message("Hier ARDUINO_HOME: ${ARDUINO_HOME}")
message("Hier ARDUINO_USER: ${ARDUINO_USER}")
if("${ARDUINO_ESP8266_DIR}" STREQUAL "" AND NOT "${ARDUINO_USER}" STREQUAL "")
    if(EXISTS "${ARDUINO_USER}/packages/esp8266/hardware/esp8266/2.3.0/cores/esp8266")
        set(ARDUINO_ESP8266_DIR "${ARDUINO_USER}/packages/esp8266/hardware/esp8266/2.3.0" CACHE PATH "Path to the directory containing ESP8266 core")
    endif()
endif()
if("${ARDUINO_ESP8266_DIR}" STREQUAL "" AND NOT "${ARDUINO_HOME}" STREQUAL "")
    if(EXISTS "${ARDUINO_HOME}/hardware/esp8266com/esp8266/cores/esp8266")
        set(ARDUINO_ESP8266_DIR "${ARDUINO_HOME}/hardware/esp8266com/esp8266" CACHE PATH "Path to the directory containing ESP8266 core")
    endif()
endif()
if(NOT "${ARDUINO_ESP8266_DIR}" STREQUAL "")
    message(STATUS "Using ARDUINO_ESP8266_DIR ${ARDUINO_ESP8266_DIR}")
else()
    message(FATAL_ERROR "ARDUINO_ESP8266_DIR is not set and ESP8266 core files could not be found")
endif()
