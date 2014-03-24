project(ApacheThrift)
cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

include(ThriftUtils)

get_filename_component(THRIFT_ABS_PATH ${THRIFT_SRC_ROOT} ABSOLUTE)
thrift_get_version("${THRIFT_ABS_PATH}" THRIFT_MAJOR THRIFT_MINOR THRIFT_PATCH PACKAGE_VERSION)

message("Generating project for Apache Thrift version: ${PACKAGE_VERSION}")

option(WITH_BOOSTTHREADS "Build with Boost::Threads" ON)
option(WITH_TESTS "Build tests" OFF)

set(_boost_COMPONENTS
    system
    )

if(WITH_BOOSTTHREADS)
    set(_boost_COMPONENTS
        ${_boost_COMPONENTS}
        thread
        )
endif()

if(WITH_TESTS)
    set(_boost_COMPONENTS
        ${_boost_COMPONENTS}
        unit_test_framework
        )
    include(CTest)
    enable_testing()
endif()

find_package(Boost COMPONENTS ${_boost_COMPONENTS} REQUIRED)

include(CheckIncludeFileCXX)
CHECK_INCLUDE_FILE_CXX(mutex HAVE_STDMUTEX_H)

add_subdirectory(compiler)
add_subdirectory(lib)
