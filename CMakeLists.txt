project(ApacheThrift)
cmake_minimum_required(VERSION 2.8)

set(CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

include(ThriftUtils)

get_filename_component(THRIFT_ABS_PATH ${THRIFT_SRC_ROOT} ABSOLUTE)
thrift_get_version("${THRIFT_ABS_PATH}" THRIFT_MAJOR THRIFT_MINOR THRIFT_PATCH PACKAGE_VERSION)

message("Generating project for Apache Thrift version: ${PACKAGE_VERSION}")
set(VERSION "${PACKAGE_VERSION}")

option(WITH_BOOSTTHREADS "Build with Boost::Threads" ON)
option(WITH_TESTS "Build tests" ON)

set(_boost_COMPONENTS
    system
    )

set(USE_BOOST_THREAD ${WITH_BOOSTTHREADS})
if(WITH_BOOSTTHREADS)
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

find_package(Boost COMPONENTS ${_boost_COMPONENTS} REQUIRED)

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
