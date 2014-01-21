project(thrift)

# set compiler sources root path
set(THRIFT_SRC_PATH ${THRIFT_SRC_ROOT}/compiler/cpp)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

file(TO_CMAKE_PATH ${THRIFT_SRC_PATH} SRC_PATH)
FLEX_TARGET(thriftl.cc ${SRC_PATH}/src/thriftl.ll
    ${CMAKE_CURRENT_BINARY_DIR}/thriftl.cc)
BISON_TARGET(thrifty.cc ${SRC_PATH}/src/thrifty.yy
    ${CMAKE_CURRENT_BINARY_DIR}/thrifty.cc
    COMPILE_FLAGS "-y --defines")

ADD_CUSTOM_COMMAND(
   OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/thrifty.h
   COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/thrifty.hh ${CMAKE_CURRENT_BINARY_DIR}/thrifty.h
   DEPENDS thrifty.cc
   )

if(MSVC)
    # fake empty unistd.h
    file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/unistd.h "/* fake unistd.h for vc compiler */")
    add_definitions(-DYY_NO_UNISTD_H)
endif()

configure_file(${SRC_PATH}/src/windows/version.h.in ${CMAKE_CURRENT_BINARY_DIR}/version.h COPYONLY)

include_directories(${SRC_PATH}/src/windows)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${SRC_PATH}/src)
include_directories(${SRC_PATH}/src/generate)
include_directories(${SRC_ROOT}/src/parse)

file(GLOB GENERATE_SRC ${SRC_PATH}/src/generate/*.cc)
file(GLOB GENERATE_HDR ${SRC_PATH}/src/generate/*.h)
file(GLOB PARSE_SRC ${SRC_PATH}/src/parse/*.cc)
file(GLOB PARSE_HDR ${SRC_PATH}/src/parse/*.h)

set(CPP_SRC
    ${SRC_PATH}/src/globals.h
    ${SRC_PATH}/src/main.cc
    ${SRC_PATH}/src/main.h
    ${SRC_PATH}/src/md5.c
    ${SRC_PATH}/src/md5.h
    ${SRC_PATH}/src/platform.h
    )


add_executable(thrift
    ${CMAKE_CURRENT_BINARY_DIR}/thriftl.cc
    ${CMAKE_CURRENT_BINARY_DIR}/thrifty.cc
    ${CMAKE_CURRENT_BINARY_DIR}/thrifty.h
    ${CMAKE_CURRENT_BINARY_DIR}/version.h
    ${PARSE_SRC}
    ${PARSE_HDR}
    ${GENERATE_SRC}
    ${GENERATE_HDR}
    ${CPP_SRC}
    )

