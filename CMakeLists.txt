project(ApacheThrift)
cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

include(ThriftUtils)

get_filename_component(THRIFT_ABS_PATH ${THRIFT_SRC_ROOT} ABSOLUTE)
thrift_get_version("${THRIFT_ABS_PATH}" THRIFT_MAJOR THRIFT_MINOR THRIFT_PATCH PACKAGE_VERSION)

message("Generating project for Apache Thrift version: ${PACKAGE_VERSION}")

option(WITH_BOOSTTHREADS "Build with Boost::Threads" ON)
option(WITH_TESTS "Build tests" OFF)

if(WITH_BOOSTTHREADS)
    find_package(Boost COMPONENTS thread system REQUIRED)
else()
    find_package(Boost COMPONENTS system REQUIRED)
endif()

add_subdirectory(compiler)
add_subdirectory(lib)
