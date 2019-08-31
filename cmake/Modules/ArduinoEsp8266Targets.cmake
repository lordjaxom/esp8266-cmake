function(add_esp8266_executable name)
    cmake_parse_arguments(ESP8266 "" "FLASH" "" ${ARGN})

    add_executable("${name}" ${ESP8266_UNPARSED_ARGUMENTS})
    target_link_libraries("${name}" PUBLIC ${ArduinoEsp8266_LIBRARIES})

    include(ArduinoEsp8266Flash)
    if(NOT "${ESP8266_FLASH_FOUND}" STREQUAL "TRUE")
        message(FATAL_ERROR "Flash size not set for ${name}")
    endif()
    message(STATUS "Using flash layout ${ESP8266_FLASH_LAYOUT} for target ${name}")

    set_target_properties("${name}" PROPERTIES
            COMPILE_DEFINITIONS "ESP8266_TARGET_NAME=\"${name}\""
            LINK_FLAGS "-L\"${ARDUINO_ESP8266_DIR}/tools/sdk/ld\" -Teagle.flash.${ESP8266_FLASH_LAYOUT}.ld")

    add_custom_command(TARGET "${name}" POST_BUILD
            COMMAND "${ESP8266_XTENSA_SIZE}" "$<TARGET_FILE:${name}>")
    add_custom_command(TARGET "${name}" POST_BUILD
            COMMAND "${ESP8266_PYTHON}" "${ESP8266_ELF2BIN_PY}" --eboot "${ARDUINO_ESP8266_DIR}/bootloaders/eboot/eboot.elf" --app "$<TARGET_FILE:${name}>" --flash_mode dout --flash_freq 40 --flash_size ${ESP8266_FLASH_SIZE} --path "${ESP8266_XTENSA_PATH}" --out "$<TARGET_FILE:${name}>.bin")

    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${name}.bin")

    if(NOT "${ESP8266_ESPTOOL_COM_PORT}" STREQUAL "")
        add_custom_target("${name}_flash"
                COMMAND "${ESP8266_PYTHON}" "${ESP8266_UPLOAD_PY}" --chip esp8266 --port ${ESP8266_ESPTOOL_COM_PORT} --baud 115200 version --end --chip esp8266 --port ${ESP8266_ESPTOOL_COM_PORT} --baud 115200 write_flash 0x0 "$<TARGET_FILE:${name}>.bin" --end)
        add_dependencies("${name}_flash" "${name}")
    endif()
endfunction()
