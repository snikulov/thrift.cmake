project(ApacheThrift)
cmake_minimum_required(VERSION 2.8)

macro(thrift_get_version _config_ac_PATH vmajor vminor vpatch verstr)
    file(STRINGS "${_config_ac_PATH}/configure.ac" _thrift_VER_STRING_AUX REGEX "^AC_INIT")
    #    message("_trift_VER_STRING_AUX = ${_thrift_VER_STRING_AUX}")
    string(REGEX MATCH "[0-9]+[.][0-9]+[.][0-9]+" _thrift_VER_STR ${_thrift_VER_STRING_AUX})
    string(REGEX MATCH "-dev" _thrift_DEV_PROP ${_thrift_VER_STRING_AUX})
    #    message("_thrift_VER_STR = ${_thrift_VER_STR}")
    string(REGEX MATCHALL "[0-9]+" _thrift_VER_LIST ${_thrift_VER_STR})
    #    message("_thrift_VER_LIST = ${_thrift_VER_LIST}")
    list(GET _thrift_VER_LIST 0 ${vmajor})
    list(GET _thrift_VER_LIST 1 ${vminor})
    list(GET _thrift_VER_LIST 2 ${vpatch})
    set(${verstr} "${_thrift_VER_STR}${_thrift_DEV_PROP}")
endmacro()

get_filename_component(THRIFT_ABS_PATH ${THRIFT_SRC_ROOT} ABSOLUTE)
thrift_get_version("${THRIFT_ABS_PATH}" THRIFT_MAJOR THRIFT_MINOR THRIFT_PATCH PACKAGE_VERSION)

message("Generating project for Apache Thrift version: ${PACKAGE_VERSION}")

add_subdirectory(compiler)
add_subdirectory(lib)
