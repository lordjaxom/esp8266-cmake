function(add_esp8266_executable name)
    add_executable("${name}" ${ARGN})
    target_link_libraries("${name}" PUBLIC ${ArduinoEsp8266_LIBRARIES})

    include(ArduinoEsp8266Flash)
    set_target_properties("${name}" PROPERTIES LINK_FLAGS "-L\"${ARDUINO_ESP8266_DIR}/tools/sdk/ld\" -Teagle.flash.${ESP8266_FLASH_LAYOUT}.ld")

    add_custom_command(TARGET "${name}" POST_BUILD
            COMMAND "${ESP8266_XTENSA_SIZE}" "$<TARGET_FILE:${name}>")
    add_custom_command(TARGET "${name}" POST_BUILD
            COMMAND "${ESP8266_ESPTOOL}" -eo "${ARDUINO_ESP8266_DIR}/bootloaders/eboot/eboot.elf" -bo "$<TARGET_FILE:${name}>.bin" -bf 40 -bz ${ESP8266_FLASH_SIZE} -bs .text -bp 4096 -ec -eo "$<TARGET_FILE:${name}>" -bs .irom0.text -bs .text -bs .data -bs .rodata -bc -ec)

    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${name}.bin")

    if(NOT "${ESP8266_ESPTOOL_COM_PORT}" STREQUAL "")
        add_custom_target("${name}_flash"
                COMMAND "${ESP8266_ESPTOOL}" -vv -cd ck -cb 115200 -cp ${ESP8266_ESPTOOL_COM_PORT} -ca 0x00000 -cf "$<TARGET_FILE:${name}>.bin")
        add_dependencies("${name}_flash" "${name}")
    endif()
endfunction()
