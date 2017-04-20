set(ARDUINO_ESP8266_LIBRARIES
        EEPROM
        ESP8266HTTPClient
        ESP8266HTTPUpdateServer
        ESP8266WebServer
        ESP8266WiFi
        Hash
        SD
        SPI
        SPISlave
        Ticker
        Wire)

if(NOT "$ENV{ARDUINO_ESP8266_LIBRARIES}" STREQUAL "")
    list(APPEND ARDUINO_ESP8266_LIBRARIES $ENV{ARDUINO_ESP8266_LIBRARIES})
endif()

list(REMOVE_DUPLICATES ARDUINO_ESP8266_LIBRARIES)

get_target_property(LIB_INCLUDES arduino INCLUDE_DIRECTORIES)
get_target_property(LIB_DEFINITIONS arduino COMPILE_DEFINITIONS)
get_target_property(LIB_OPTIONS arduino COMPILE_OPTIONS)

set(LIBS_RETRY ${ARDUINO_ESP8266_LIBRARIES})
while(NOT "${LIBS_RETRY}" STREQUAL "${LIBS_BUILD}")

    set(LIBS_BUILD ${LIBS_RETRY})
    set(LIBS_RETRY)

    foreach(LIB ${LIBS_BUILD})

        if(IS_DIRECTORY "${ARDUINO_ESP8266_DIR}/libraries/${LIB}")
            set(LIB_DIR "${ARDUINO_ESP8266_DIR}/libraries/${LIB}")
        else()
            message(FATAL_ERROR "Library ${LIB} not found")
        endif()

        if(IS_DIRECTORY "${LIB_DIR}/src")
            set(LIB_SRC_DIR "${LIB_DIR}/src")
        else()
            set(LIB_SRC_DIR "${LIB_DIR}")
        endif()

        file(GLOB_RECURSE LIB_SRC_C "${LIB_SRC_DIR}/*.c")
        file(GLOB_RECURSE LIB_SRC_CXX "${LIB_SRC_DIR}/*.cpp")
        file(GLOB LIB_HDR "${LIB_SRC_DIR}/*.h")
        list(APPEND LIB_SRC_CXX ${LIB_HDR})

        set(LIB_RETRY FALSE)
        set(LIBS_ERRORS)
        foreach(LANG C CXX)
            foreach(SRC ${LIB_SRC_${LANG}})
                set(LIB_TEST_FLAGS "${CMAKE_${LANG}_FLAGS}")
                separate_arguments(LIB_TEST_FLAGS)
                list(APPEND LIB_TEST_FLAGS ${LIB_OPTIONS})
                foreach(LIB_DEFINITION ${LIB_DEFINITIONS})
                    list(APPEND LIB_TEST_FLAGS "-D${LIB_DEFINITION}")
                endforeach()
                foreach(LIB_INCLUDE ${LIB_INCLUDES})
                    list(APPEND LIB_TEST_FLAGS "-I${LIB_INCLUDE}")
                endforeach()
                list(APPEND LIB_TEST_FLAGS "-I${LIB_SRC_DIR}")

                execute_process(
                        COMMAND "${CMAKE_${LANG}_COMPILER}" ${LIB_TEST_FLAGS} -E "${SRC}"
                        RESULT_VARIABLE LIB_DEPS_RESULT
                        ERROR_VARIABLE LIB_DEPS_ERROR
                        OUTPUT_QUIET)

                if(NOT "${LIB_DEPS_RESULT}" EQUAL 0)
                    set(LIB_RETRY TRUE)
                    set(LIBS_ERRORS "${LIBS_ERRORS}\n${LIB_DEPS_ERROR}")
                    break()
                endif()

            endforeach()

            if("${LIB_RETRY}")
                break()
            endif()

        endforeach()

        if("${LIB_RETRY}")
            list(APPEND LIBS_RETRY "${LIB}")
            continue()
        endif()

        list(APPEND LIB_SRC_CXX "empty.cpp")

        add_library("${LIB}" STATIC ${LIB_SRC_C} ${LIB_SRC_CXX})
        target_include_directories("${LIB}" PUBLIC "${LIB_SRC_DIR}")
        target_include_directories("${LIB}" PRIVATE ${LIB_INCLUDES})
        target_link_libraries("${LIB}" PUBLIC arduino)

        install(TARGETS "${LIB}" ARCHIVE DESTINATION lib)

        list(APPEND LIB_INCLUDES "${LIB_SRC_DIR}")

        message(STATUS "Added library ${LIB}")

    endforeach()

endwhile()

if(NOT "${LIBS_RETRY}" STREQUAL "")
    set(LIBS_MESSAGE "Following libraries failed to build:")
    foreach(LIB LIBS_RETRY)
        set(LIBS_MESSAGE "${LIBS_MESSAGE} ${LIB}")
    endforeach()
    set(LIBS_MESSAGE "${LIBS_MESSAGE}${LIBS_ERRORS}")
    message(FATAL_ERROR " Following libraries failed to build: ${LIBS_MESSAGE} ")
endif()