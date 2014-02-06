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

set(BENCHMARK_SOURCES
    ${TEST_SRC_PATH}/Benchmark.cpp
    )

set(UNITTESTS_SOURCES
    ${TEST_SRC_PATH}/UnitTestMain.cpp
    ${TEST_SRC_PATH}/TMemoryBufferTest.cpp
    ${TEST_SRC_PATH}/TBufferBaseTest.cpp
    ${TEST_SRC_PATH}/Base64Test.cpp
    )
if(NOT WITH_BOOSTTHREADS)
    set(UNITTESTS_SOURCES
        ${UNITTESTS_SOURCES}
        ${TEST_SRC_PATH}/RWMutexStarveTest.cpp
        )
endif()

set(FILETRANSPORTTEST_SOURCES
    ${TEST_SRC_PATH}/TFileTransportTest.cpp
    )


include_directories(${Boost_INCLUDE_DIR})
include_directories(${SRC_PATH}/src)
include_directories(${GEN_FILES_PATH})
include_directories(${CMAKE_BINARY_DIR})

add_library(testgencpp ${LIBGENCPP_SOURCES})

add_executable(benchmark ${BENCHMARK_SOURCES})
set_target_properties(benchmark
    PROPERTIES
        COMPILE_DEFINITIONS _USE_MATH_DEFINES)
target_link_libraries(benchmark testgencpp libthrift)

# TODO: on windows I need static libs for linkage...
set(Boost_USE_STATIC_LIBS ON)
find_package(Boost COMPONENTS ${_boost_COMPONENTS} REQUIRED)

add_executable(unittests ${UNITTESTS_SOURCES})
set_target_properties(unittests
    PROPERTIES
        COMPILE_DEFINITIONS BOOST_ALL_NO_LIB
    )
target_link_libraries(unittests testgencpp libthrift ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
add_test(unittests unittests)

if(NOT MSVC)
add_executable(filetransporttest ${FILETRANSPORTTEST_SOURCES})
set_target_properties(filetransporttest
    PROPERTIES
        COMPILE_DEFINITIONS BOOST_ALL_NO_LIB
    )
target_link_libraries(filetransporttest testgencpp libthrift ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
add_test(filetransporttest filetransporttest)
endif()


