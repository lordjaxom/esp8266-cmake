if(NOT "${ESP8266_FLASH}" STREQUAL "")
    set(ESP8266_FLASH_FOUND TRUE)
    if("${ESP8266_FLASH}" MATCHES "^512[kK](0[kK]?)?")
        set(ESP8266_FLASH_SIZE "512K")
        set(ESP8266_FLASH_LAYOUT "512k")
    elseif("${ESP8266_FLASH}" MATCHES "512[kK]64[kK]")
        set(ESP8266_FLASH_SIZE "512K")
        set(ESP8266_FLASH_LAYOUT "512k64")
    elseif("${ESP8266_FLASH}" MATCHES "512k128[kK]")
        set(ESP8266_FLASH_SIZE "512K")
        set(ESP8266_FLASH_LAYOUT "512k128")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM](0[kK]?)?")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM]64[kK]")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m64")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM]128[kK]")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m128")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM]144[kK]")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m144")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM]160[kK]")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m160")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM]192[kK]")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m192")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM]256[kK]")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m256")
    elseif("${ESP8266_FLASH}" MATCHES "1[mM]512[kK]")
        set(ESP8266_FLASH_SIZE "1M")
        set(ESP8266_FLASH_LAYOUT "1m512")
    elseif("${ESP8266_FLASH}" MATCHES "2[mM](0[kK]?)?")
        set(ESP8266_FLASH_SIZE "2M")
        set(ESP8266_FLASH_LAYOUT "2m")
    elseif("${ESP8266_FLASH}" MATCHES "4[mM](0[kK]?)?")
        set(ESP8266_FLASH_SIZE "4M")
        set(ESP8266_FLASH_LAYOUT "4m")
    elseif("${ESP8266_FLASH}" MATCHES "4[mM]1[mM]")
        set(ESP8266_FLASH_SIZE "4M")
        set(ESP8266_FLASH_LAYOUT "4m1m")
    elseif("${ESP8266_FLASH}" MATCHES "8[mM](0[kK]?)?")
        set(ESP8266_FLASH_SIZE "8M")
        set(ESP8266_FLASH_LAYOUT "8m")
    elseif("${ESP8266_FLASH}" MATCHES "16[mM](0[kK]?)?")
        set(ESP8266_FLASH_SIZE "16M")
        set(ESP8266_FLASH_LAYOUT "16m")
    else()
        set(ESP8266_FLASH_FOUND)
        message(FATAL_ERROR "Unknown value ${ESP8266_FLASH} for ESP8266_FLASH")
    endif()
endif()
