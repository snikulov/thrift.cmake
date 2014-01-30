project(compiler)

# set compiler sources root path
get_filename_component(ABS_PATH ${THRIFT_SRC_ROOT} ABSOLUTE)
set(COMP_SRC_PATH ${ABS_PATH}/compiler/cpp)
message("Thrift absolute source path = ${ABS_PATH}")
message("Thrift compiler path = ${COMP_SRC_PATH}")

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

FLEX_TARGET(thriftl.cc ${COMP_SRC_PATH}/src/thriftl.ll
    ${CMAKE_CURRENT_BINARY_DIR}/thriftl.cc)
BISON_TARGET(thrifty.cc ${COMP_SRC_PATH}/src/thrifty.yy
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

configure_file(${COMP_SRC_PATH}/src/windows/version.h.in ${CMAKE_CURRENT_BINARY_DIR}/version.h @ONLY)

include_directories(${COMP_SRC_PATH}/src/windows)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${COMP_SRC_PATH}/src)
include_directories(${COMP_SRC_PATH}/src/generate)
include_directories(${SRC_ROOT}/src/parse)

file(GLOB GENERATE_SRC ${COMP_SRC_PATH}/src/generate/*.cc)
file(GLOB GENERATE_HDR ${COMP_SRC_PATH}/src/generate/*.h)
file(GLOB PARSE_SRC ${COMP_SRC_PATH}/src/parse/*.cc)
file(GLOB PARSE_HDR ${COMP_SRC_PATH}/src/parse/*.h)

set(CPP_SRC
    ${COMP_SRC_PATH}/src/globals.h
    ${COMP_SRC_PATH}/src/main.cc
    ${COMP_SRC_PATH}/src/main.h
    ${COMP_SRC_PATH}/src/md5.c
    ${COMP_SRC_PATH}/src/md5.h
    ${COMP_SRC_PATH}/src/platform.h
    )


add_executable(compiler
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

set_target_properties(compiler PROPERTIES OUTPUT_NAME thrift)


