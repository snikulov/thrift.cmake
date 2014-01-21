project(libthrift)

# set compiler sources root path
set(LIBTHRIFT_SRC_PATH ${THRIFT_SRC_ROOT}/lib/cpp)
file(TO_CMAKE_PATH ${LIBTHRIFT_SRC_PATH} SRC_PATH)

find_package(Boost COMPONENTS thread system REQUIRED)
if (Boost_FOUND)
    # disable autolinking feature
    add_definitions(-DBOOST_ALL_NO_LIB)
    include_directories(${Boost_INCLUDE_DIR})
else()
    message(FATAL_ERROR "Boost required to build Apache LibThrift")
endif()

include_directories(${SRC_PATH}/src)

# async subfolder
set(ASYNC_SRC_PATH ${SRC_PATH}/src/thrift/async)
#include_directories(${ASYNC_SRC_PATH})
set(ASYNC_SRC
    ${ASYNC_SRC_PATH}/TAsyncChannel.cpp)
set(ASYNC_HDR
    ${ASYNC_SRC_PATH}/TAsyncChannel.h)

set(CONCUR_SRC_PATH ${SRC_PATH}/src/thrift/concurrency)
set(CONCUR_SRC
    ${CONCUR_SRC_PATH}/BoostMonitor.cpp
    ${CONCUR_SRC_PATH}/BoostMutex.cpp
    ${CONCUR_SRC_PATH}/BoostThreadFactory.cpp
    ${CONCUR_SRC_PATH}/StdThreadFactory.cpp
    ${CONCUR_SRC_PATH}/ThreadManager.cpp
    ${CONCUR_SRC_PATH}/TimerManager.cpp
    ${CONCUR_SRC_PATH}/Util.cpp
    )
set(CONCUR_HDR
    ${CONCUR_SRC_PATH}/BoostThreadFactory.h
    ${CONCUR_SRC_PATH}/PlatformThreadFactory.h
    ${CONCUR_SRC_PATH}/StdThreadFactory.h
    )
#BoostMutex.cpp
#Exception.h               FunctionRunner.h          Monitor.cpp
#Monitor.h                 Mutex.cpp                 Mutex.h
#  PosixThreadFactory.cpp    PosixThreadFactory.h
#StdMonitor.cpp            StdMutex.cpp              Thread.h
#ThreadManager.h                    TimerManager.h
#                 Util.h

add_library(libthrift
    ${ASYNC_SRC}
    ${ASYNC_HDR}
    ${CONCUR_SRC}
    ${CONCUR_HDR}
    )

