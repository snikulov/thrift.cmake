project(thrift)

# set compiler sources root path
set(THRIFT_SRC_PATH ${THRIFT_SRC_ROOT}/compiler/cpp)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

if(MSVC)
    set(FLEX_INVOCATION_OPTS "--wincompat")
endif()

file(TO_CMAKE_PATH ${THRIFT_SRC_PATH} SRC_PATH)
FLEX_TARGET(thriftl ${SRC_PATH}/src/thriftl.ll 
    ${CMAKE_CURRENT_BINARY_DIR}/thriftl.cc COMPILE_FLAGS ${FLEX_INVOCATION_OPTS})
BISON_TARGET(thrifty ${SRC_PATH}/src/thrifty.yy ${CMAKE_CURRENT_BINARY_DIR}/thrifty.cc)

configure_file(${SRC_PATH}/src/windows/version.h.in ${CMAKE_CURRENT_BINARY_DIR}/version.h COPYONLY)
configure_file(${CMAKE_CURRENT_BINARY_DIR}/thrifty.hh ${CMAKE_CURRENT_BINARY_DIR}/thrifty.h COPYONLY)

include_directories(${SRC_PATH}/src/windows)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${SRC_PATH}/src)
include_directories(${SRC_PATH}/src/generate)
include_directories(${SRC_ROOT}/src/parse)

file(GLOB GENERATE_SRC ${SRC_PATH}/src/generate/*.cc)
file(GLOB GENERATE_HDR ${SRC_PATH}/src/generate/*.h)
file(GLOB PARSE_SRC ${SRC_PATH}/src/parse/*.cc)
file(GLOB PARSE_HDR ${SRC_PATH}/src/parse/*.h)


add_executable(thrift
    ${CMAKE_CURRENT_BINARY_DIR}/thriftl.cc
    ${CMAKE_CURRENT_BINARY_DIR}/thrifty.cc
    ${CMAKE_CURRENT_BINARY_DIR}/version.h
    ${PARSE_SRC}
    ${PARSE_HDR}
    ${GENERATE_SRC}
    ${GENERATE_HDR}
    )


