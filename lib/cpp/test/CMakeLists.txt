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

if(ENABLE_POSIX_RWMUTEX_STARVE_TEST)
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

# TODO: on windows I need static libs for linkage...
set(Boost_USE_STATIC_LIBS ON)
find_package(Boost COMPONENTS ${_boost_COMPONENTS} date_time chrono REQUIRED)

add_executable(benchmark ${BENCHMARK_SOURCES})
set_target_properties(benchmark
    PROPERTIES
        COMPILE_DEFINITIONS _USE_MATH_DEFINES)
target_link_libraries(benchmark testgencpp libthrift ${Boost_LIBRARIES})

add_executable(unittests ${UNITTESTS_SOURCES})
set_target_properties(unittests
    PROPERTIES
        COMPILE_DEFINITIONS BOOST_ALL_NO_LIB
    )
target_link_libraries(unittests testgencpp libthrift ${Boost_LIBRARIES})
add_test(NAME unittests COMMAND unittests)

if(NOT MSVC)
    add_executable(filetransporttest ${FILETRANSPORTTEST_SOURCES})
    set_target_properties(filetransporttest
        PROPERTIES
            COMPILE_DEFINITIONS BOOST_ALL_NO_LIB
        )
    target_link_libraries(filetransporttest testgencpp libthrift ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY})
    add_test(NAME filetransporttest COMMAND filetransporttest)
endif()

if(ZLIB_FOUND)
    set(ZLIBTEST_SOURCES
        ${TEST_SRC_PATH}/ZlibTest.cpp
        )
    include_directories(${ZLIB_INCLUDE_DIRS})
    add_executable(zlibtest ${ZLIBTEST_SOURCES})
    target_link_libraries(zlibtest
       testgencpp libthrift libthriftz
       ${Boost_UNIT_TEST_FRAMEWORK_LIBRARY}
       ${ZLIB_LIBRARIES})
   add_test(NAME zlibtest COMMAND zlibtest)
endif()

set(DebugProtoTest_SOURCES
    ${TEST_SRC_PATH}/DebugProtoTest.cpp)
add_executable(DebugProtoTest ${DebugProtoTest_SOURCES})
target_link_libraries(DebugProtoTest testgencpp libthrift ${Boost_LIBRARIES})
add_test(NAME debugprototest COMMAND DebugProtoTest)

set(JSONProtoTest_SOURCES
    ${TEST_SRC_PATH}/JSONProtoTest.cpp)
add_executable(JSONProtoTest ${JSONProtoTest_SOURCES})
target_link_libraries(JSONProtoTest testgencpp libthrift ${Boost_LIBRARIES})
add_test(NAME jsonprototest COMMAND JSONProtoTest)

set(TFDTransportTest_SOURCES
    ${TEST_SRC_PATH}/TFDTransportTest.cpp)
add_executable(TFDTransportTest ${TFDTransportTest_SOURCES})
target_link_libraries(TFDTransportTest testgencpp libthrift ${Boost_LIBRARIES})
add_test(NAME tfdtransporttest COMMAND TFDTransportTest)

set(TPipedTransportTest_SOURCES
    ${TEST_SRC_PATH}/TPipedTransportTest.cpp)
add_executable(TPipedTransportTest ${TPipedTransportTest_SOURCES})
target_link_libraries(TPipedTransportTest testgencpp libthrift ${Boost_LIBRARIES})
add_test(NAME tpipedtransporttest COMMAND TPipedTransportTest)

if(NOT MSVC)
    # got error 
    # lib\cpp\src\thrift/protocol/TCompactProtocol.tcc(32) :
    # fatal error C1060: compiler is out of heap space
    #TODO: Need to hack SIGNED_RIGHT_SHIFT_IS macro
set(AllProtocolsTest_SOURCES
    ${TEST_SRC_PATH}/AllProtocolTests.cpp
    ${TEST_SRC_PATH}/AllProtocolTests.tcc
    ${TEST_SRC_PATH}/GenericHelpers.h)
add_executable(AllProtocolTests ${AllProtocolsTest_SOURCES})
target_link_libraries(AllProtocolTests testgencpp libthrift)
add_test(NAME allprotocoltest COMMAND AllProtocolTests)
endif()

set(OptionalRequiredTest_SOURCES
    ${TEST_SRC_PATH}/OptionalRequiredTest.cpp)
add_executable(OptionalRequiredTest ${OptionalRequiredTest_SOURCES})
target_link_libraries(OptionalRequiredTest testgencpp libthrift ${Boost_LIBRARIES})
add_test(NAME optionalrequiredtest COMMAND OptionalRequiredTest)

set(SpecializationTest_SOURCES
    ${TEST_SRC_PATH}/SpecializationTest.cpp)
add_executable(SpecializationTest ${SpecializationTest_SOURCES})
target_link_libraries(SpecializationTest testgencpp libthrift ${Boost_LIBRARIES})
add_test(NAME specializationtest COMMAND SpecializationTest)

set(ConcurrencyTest_SOURCES
    ${TEST_SRC_PATH}/concurrency/Tests.cpp
    ${TEST_SRC_PATH}/concurrency/ThreadFactoryTests.h
    ${TEST_SRC_PATH}/concurrency/ThreadManagerTests.h
    ${TEST_SRC_PATH}/concurrency/TimerManagerTests.h)
add_executable(ConcurrencyTest ${ConcurrencyTest_SOURCES})
target_link_libraries(ConcurrencyTest testgencpp libthrift)
add_test(NAME concurrencytest COMMAND ConcurrencyTest)
