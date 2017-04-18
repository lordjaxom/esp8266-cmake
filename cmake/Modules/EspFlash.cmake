function(add_esp8266_executable name)
    add_executable("${name}" ${ARGN})

    add_custom_target("${name}_binary" ALL
            COMMAND "${ESP8266_ESPTOOL}" -eo "${ARDUINO_ESP8266_DIR}/bootloaders/eboot/eboot.elf" -bo "${name}.bin" -bf 40 -bz ${ESP8266_FLASH_SIZE} -bs .text -bp 4096 -ec -eo "$<TARGET_FILE:${name}>" -bs .irom0.text -bs .text -bs .data -bs .rodata -bc -ec
    )

    set_directory_properties(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${name}.bin")

    add_dependencies("${name}_binary" "${name}")

    if(NOT "${ESP8266_ESPTOOL_COM_PORT}" STREQUAL "")
        add_custom_target("${name}_flash" COMMAND
                "${ESP8266_ESPTOOL}" -vv -cd ck -cb 115200 -cp ${ESP8266_ESPTOOL_COM_PORT} -ca 0x00000 -cf "${name}.bin"
        )

        add_dependencies("${name}_flash" "${name}_binary")
    else()
        message(WARNING "ESP8266_ESPTOOL_COM_PORT is not set, flashing will not be available")
    endif()
endfunction()
