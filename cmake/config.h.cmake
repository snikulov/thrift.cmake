/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#ifndef _THRIFT_WINDOWS_CONFIG_H_
#define _THRIFT_WINDOWS_CONFIG_H_ 1

#if defined(_MSC_VER) && (_MSC_VER > 1200)
#pragma once
#endif // _MSC_VER

#ifndef _WIN32
#error This is a MSVC header only.
#endif

#cmakedefine USE_STD_THREAD   ${USE_STD_THREAD} 
#cmakedefine USE_BOOST_THREAD ${USE_BOOST_THREAD}

#ifndef TARGET_WIN_XP
#  define TARGET_WIN_XP 1
#endif

#if TARGET_WIN_XP
#  ifndef WINVER
#    define WINVER 0x0501
#  endif
#  ifndef _WIN32_WINNT
#    define _WIN32_WINNT 0x0501
#  endif
#endif

#ifndef _WIN32_WINNT
#  define _WIN32_WINNT 0x0601
#endif

#pragma warning(disable: 4996) // Deprecated posix name.

#cmakedefine VERSION "${VERSION}" 

#define HAVE_GETTIMEOFDAY 1
#define HAVE_SYS_STAT_H 1

#cmakedefine HAVE_STDINT_H ${HAVE_STDINT_H} 

#ifdef HAVE_STDINT_H
#  include <stdint.h>
#else
#  include <boost/cstdint.hpp>

typedef boost::int64_t    int64_t;
typedef boost::uint64_t  uint64_t;
typedef boost::int32_t    int32_t;
typedef boost::uint32_t  uint32_t;
typedef boost::int16_t    int16_t;
typedef boost::uint16_t  uint16_t;
typedef boost::int8_t      int8_t;
typedef boost::uint8_t    uint8_t;
#endif

#include <thrift/transport/PlatformSocket.h>
#include <thrift/windows/GetTimeOfDay.h>
#include <thrift/windows/Operators.h>
#include <thrift/windows/TWinsockSingleton.h>
#include <thrift/windows/WinFcntl.h>
#include <thrift/windows/SocketPair.h>

// windows
#include <Winsock2.h>
#include <ws2tcpip.h>
#pragma comment(lib, "Ws2_32.lib")
#pragma comment(lib, "advapi32.lib") //For security APIs in TPipeServer

#endif // _THRIFT_WINDOWS_CONFIG_H_