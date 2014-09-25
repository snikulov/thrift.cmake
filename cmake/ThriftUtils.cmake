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
