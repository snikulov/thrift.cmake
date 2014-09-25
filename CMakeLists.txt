#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#

cmake_minimum_required(VERSION 2.8)

project(ApacheThrift)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

include(ThriftUtils)

get_filename_component(THRIFT_ABS_PATH ${THRIFT_SRC_ROOT} ABSOLUTE)
thrift_get_version("${THRIFT_ABS_PATH}" THRIFT_MAJOR THRIFT_MINOR THRIFT_PATCH PACKAGE_VERSION)

message(STATUS "Generating project for Apache Thrift version: ${PACKAGE_VERSION}")
set(VERSION "${PACKAGE_VERSION}")

option(WITH_BOOSTTHREADS    "Build with Boost::Threads"       ON)
option(WITH_BOOST_LIBSTATIC "Boost will be statically linked" ON)
option(WITH_TESTS           "Build tests"                     ON)

set(_boost_COMPONENTS
    system
    date_time
    chrono
    )

if(WITH_BOOSTTHREADS)
    set(USE_BOOST_THREAD 1)
    set(_boost_COMPONENTS
        ${_boost_COMPONENTS}
        thread
        )
    add_definitions(-DUSE_BOOST_THREAD)
endif()

if(WITH_TESTS)
    set(_boost_COMPONENTS
        ${_boost_COMPONENTS}
        unit_test_framework
        )
    include(CTest)
    enable_testing()
endif()

set(Boost_USE_STATIC_LIBS ${WITH_BOOST_LIBSTATIC})
find_package(Boost COMPONENTS ${_boost_COMPONENTS} REQUIRED)
find_package(ZLIB)
find_package(OpenSSL)
find_package(Libevent)

# debug print
if(Libevent_FOUND)
    message("Found libevent")
    message("LIBEVENT_INCLUDE_DIRS = ${LIBEVENT_INCLUDE_DIRS}")
    message("LIBEVENT_LIBRARIES = ${LIBEVENT_LIBRARIES}")
else()
    message("libevent does not found")
endif()

include(CheckIncludeFileCXX)
CHECK_INCLUDE_FILE_CXX(mutex HAVE_STDMUTEX_H)
CHECK_INCLUDE_FILE_CXX(thread HAVE_STDTHREAD_H)
CHECK_INCLUDE_FILE_CXX(stdint.h HAVE_STDINT_H)

# todo: fix it for posix platforms
if(NOT WITH_BOOSTTHREADS)
    set(USE_STD_THREAD ${HAVE_STDTHREAD_H})
    if(USE_STD_THREAD)
       add_definitions(-DUSE_STD_THREAD)
    else()
       message(FATAL_ERROR "std::thread not found - enable boost::thread and re-run configuration")
    endif()
endif()

configure_file(${PROJECT_SOURCE_DIR}/cmake/config.h.cmake ${THRIFT_ABS_PATH}/lib/cpp/src/thrift/windows/config.h)

add_subdirectory(compiler)
add_subdirectory(lib)
