project(libraries_test)

# set compiler sources root path
file(TO_CMAKE_PATH ${THRIFT_SRC_ROOT} THRIFT_PATH)

set(SRC_PATH ${THRIFT_PATH}/lib/cpp)
set(TEST_PATH ${THRIFT_PATH}/test)
set(TEST_SRC_PATH ${SRC_PATH}/test)

set(THRIFT_TEST_DESC
    ${TEST_PATH}/OptionalRequiredTest.thrift
    ${TEST_PATH}/StressTest.thrift
    ${TEST_PATH}/ThriftTest.thrift
    )
set(GEN_FILES_PATH ${CMAKE_BINARY_DIR}/gen-cpp)

add_custom_command(
    OUTPUT
        ${GEN_FILES_PATH}/DebugProtoTest_types.cpp
        ${GEN_FILES_PATH}/DebugProtoTest_types.h
    COMMAND
        $<TARGET_FILE:compiler> --gen cpp:dense ${TEST_PATH}/DebugProtoTest.thrift
    DEPENDS
        compiler
    WORKING_DIRECTORY
        ${CMAKE_BINARY_DIR}
    )

add_custom_command(
    OUTPUT
        ${GEN_FILES_PATH}/OptionalRequiredTest_types.cpp
        ${GEN_FILES_PATH}/OptionalRequiredTest_types.h
    COMMAND
        $<TARGET_FILE:compiler> --gen cpp:dense ${TEST_PATH}/OptionalRequiredTest.thrift
    DEPENDS
        compiler
    WORKING_DIRECTORY
        ${CMAKE_BINARY_DIR}
    )

add_custom_command(
    OUTPUT
        ${GEN_FILES_PATH}/Service.cpp
        ${GEN_FILES_PATH}/StressTest_types.cpp
    COMMAND
        $<TARGET_FILE:compiler> --gen cpp:dense ${TEST_PATH}/StressTest.thrift
    DEPENDS
        compiler
    WORKING_DIRECTORY
        ${CMAKE_BINARY_DIR}
    )

add_custom_command(
    OUTPUT
        ${GEN_FILES_PATH}/SecondService.cpp
        ${GEN_FILES_PATH}/ThriftTest_constants.cpp
        ${GEN_FILES_PATH}/ThriftTest.cpp
        ${GEN_FILES_PATH}/ThriftTest_types.cpp
        ${GEN_FILES_PATH}/ThriftTest_types.h
    COMMAND
        $<TARGET_FILE:compiler> --gen cpp:dense ${TEST_PATH}/ThriftTest.thrift
    DEPENDS
        compiler
    WORKING_DIRECTORY
        ${CMAKE_BINARY_DIR}
    )

add_custom_command(
    OUTPUT
        ${GEN_FILES_PATH}/ChildService.cpp
    COMMAND
        $<TARGET_FILE:compiler> --gen cpp:templates,cob_style ${TEST_SRC_PATH}/processor/proc.thrift
    DEPENDS
        compiler
    WORKING_DIRECTORY
        ${CMAKE_BINARY_DIR}
    )



set(GEN_SOURCES
    ${GEN_FILES_PATH}/DebugProtoTest_types.cpp
    ${GEN_FILES_PATH}/DebugProtoTest_types.h
    ${GEN_FILES_PATH}/OptionalRequiredTest_types.cpp
    ${GEN_FILES_PATH}/OptionalRequiredTest_types.h
    ${GEN_FILES_PATH}/Service.cpp
    ${GEN_FILES_PATH}/StressTest_types.cpp
    ${GEN_FILES_PATH}/SecondService.cpp
    ${GEN_FILES_PATH}/ThriftTest_constants.cpp
    ${GEN_FILES_PATH}/ThriftTest.cpp
    ${GEN_FILES_PATH}/ThriftTest_types.cpp
    ${GEN_FILES_PATH}/ThriftTest_types.h
    ${GEN_FILES_PATH}/ChildService.cpp
    )

set(LIBGENCPP_SOURCES
    ${GEN_FILES_PATH}/DebugProtoTest_types.cpp
    ${GEN_FILES_PATH}/DebugProtoTest_types.h
    ${GEN_FILES_PATH}/OptionalRequiredTest_types.cpp
    ${GEN_FILES_PATH}/OptionalRequiredTest_types.h
    ${GEN_FILES_PATH}/ThriftTest_types.cpp
    ${GEN_FILES_PATH}/ThriftTest_types.h
    ${TEST_SRC_PATH}/ThriftTest_extras.cpp
    ${TEST_SRC_PATH}/DebugProtoTest_extras.cpp
    )


include_directories(${Boost_INCLUDE_DIR})
include_directories(${SRC_PATH}/src)
include_directories(${GEN_FILES_PATH})
include_directories(${CMAKE_BINARY_DIR})

add_library(testgencpp ${LIBGENCPP_SOURCES})
