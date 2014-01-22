project(libthrift)

# set compiler sources root path
set(LIBTHRIFT_SRC_PATH ${THRIFT_SRC_ROOT}/lib/cpp)
file(TO_CMAKE_PATH ${LIBTHRIFT_SRC_PATH} SRC_PATH)

find_package(Boost COMPONENTS thread system REQUIRED)
if (Boost_FOUND)
    # disable autolinking feature
    include_directories(${Boost_INCLUDE_DIR})
else()
    message(FATAL_ERROR "Boost required to build Apache LibThrift")
endif()

include_directories(${SRC_PATH}/src)

# async subfolder
set(ASYNC_SRC_PATH ${SRC_PATH}/src/thrift/async)
set(ASYNC_SRC
    ${ASYNC_SRC_PATH}/TAsyncChannel.cpp)
set(ASYNC_HDR
    ${ASYNC_SRC_PATH}/TAsyncChannel.h)
source_group("async" FILES ${ASYNC_SRC} ${ASYNC_HDR})


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
source_group("concurrency" FILES ${CONCUR_SRC} ${CONCUR_HDR})

set(PROCESSOR_SRC_PATH ${SRC_PATH}/src/thrift/processor)
set(PROCESSOR_SRC
    ${PROCESSOR_SRC_PATH}/PeekProcessor.cpp
    )
set(PROCESSOR_HDR
    ${PROCESSOR_SRC_PATH}/PeekProcessor.h
    )
source_group("processor" FILES ${PROCESSOR_SRC} ${PROCESSOR_HDR})

# protocol part of the lib
set(PROTO_SRC_PATH ${SRC_PATH}/src/thrift/protocol)
set(PROTO_SRC
    ${PROTO_SRC_PATH}/TBase64Utils.cpp
    ${PROTO_SRC_PATH}/TDebugProtocol.cpp
    ${PROTO_SRC_PATH}/TDenseProtocol.cpp
    ${PROTO_SRC_PATH}/TJSONProtocol.cpp
    )
set(PROTO_HDR
    ${PROTO_SRC_PATH}/TBinaryProtocol.h
    ${PROTO_SRC_PATH}/TBinaryProtocol.tcc
    ${PROTO_SRC_PATH}/TDebugProtocol.h
    ${PROTO_SRC_PATH}/TDenseProtocol.h
    ${PROTO_SRC_PATH}/TJSONProtocol.h
    ${PROTO_SRC_PATH}/TProtocol.h
    ${PROTO_SRC_PATH}/TVirtualProtocol.h
    )
source_group("protocol" FILES ${PROTO_SRC} ${PROTO_HDR})

# server part of the lib
set(SRV_SRC_PATH ${SRC_PATH}/src/thrift/server)
set(SRV_SRC
    ${SRV_SRC_PATH}/TSimpleServer.cpp
    ${SRV_SRC_PATH}/TThreadPoolServer.cpp
    )
set(SRV_HDR
    ${SRV_SRC_PATH}/TServer.h
    ${SRV_SRC_PATH}/TSimpleServer.h
    ${SRV_SRC_PATH}/TThreadPoolServer.h
    )
source_group("server" FILES ${SRV_SRC} ${SRV_HDR})

# transport part of the lib
set(TRANSPORT_SRC_PATH ${SRC_PATH}/src/thrift/transport)
file(GLOB TRANSPORT_SRC ${TRANSPORT_SRC_PATH}/*.cpp)
file(GLOB TRANSPORT_HDR ${TRANSPORT_SRC_PATH}/*.h)
if(NOT OPENSSL_FOUND)
    # hack to remove TSSLSocket.cpp and TSSLServerSocket.cpp
    # from compilation if OPENSSL not found
    set_source_files_properties(
            ${TRANSPORT_SRC_PATH}/TSSLSocket.cpp
            ${TRANSPORT_SRC_PATH}/TSSLServerSocket.cpp
        PROPERTIES HEADER_FILE_ONLY TRUE)
endif()

if(NOT ZLIB_FOUND)
    set_source_files_properties(
            ${TRANSPORT_SRC_PATH}/TZlibTransport.cpp
        PROPERTIES HEADER_FILE_ONLY TRUE)
endif()
source_group("transport" FILES ${TRANSPORT_SRC} ${TRANSPORT_HDR})


add_library(libthrift
    ${ASYNC_SRC}
    ${ASYNC_HDR}
    ${CONCUR_SRC}
    ${CONCUR_HDR}
    ${PROCESSOR_SRC}
    ${PROCESSOR_HDR}
    ${PROTO_SRC}
    ${PROTO_HDR}
    ${SRV_SRC}
    ${SRV_HDR}
    ${TRANSPORT_SRC}
    ${TRANSPORT_HDR}
    )

