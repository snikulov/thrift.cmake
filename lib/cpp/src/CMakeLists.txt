project(libraries)

# set compiler sources root path
set(LIBTHRIFT_SRC_PATH ${THRIFT_SRC_ROOT}/lib/cpp)
file(TO_CMAKE_PATH ${LIBTHRIFT_SRC_PATH} SRC_PATH)

if(WITH_BOOSTTHREADS)
    set(LIBTHRIFT_SOURCES
        ${SRC_PATH}/src/thrift/concurrency/BoostThreadFactory.cpp
        ${SRC_PATH}/src/thrift/concurrency/BoostMonitor.cpp
        ${SRC_PATH}/src/thrift/concurrency/BoostMutex.cpp
    )
else()
    if(HAVE_STDMUTEX_H)
        set(LIBTHRIFT_SOURCES
            ${SRC_PATH}/src/thrift/concurrency/StdMutex.cpp
            ${SRC_PATH}/src/thrift/concurrency/StdMonitor.cpp
            ${SRC_PATH}/src/thrift/concurrency/StdThreadFactory.cpp
        )
    else()
        set(LIBTHRIFT_SOURCES
            ${SRC_PATH}/src/thrift/concurrency/Mutex.cpp
            ${SRC_PATH}/src/thrift/concurrency/Monitor.cpp
            ${SRC_PATH}/src/thrift/concurrency/PosixThreadFactory.cpp
        )
        set(ENABLE_POSIX_RWMUTEX_STARVE_TEST ON PARENT_SCOPE)
    endif()
endif()

find_package(ZLIB)
find_package(OpenSSL)

include_directories(${Boost_INCLUDE_DIR})
include_directories(${SRC_PATH}/src)

set(LIBTHRIFT_SOURCES
    ${LIBTHRIFT_SOURCES}
    ${SRC_PATH}/src/thrift/Thrift.cpp
    ${SRC_PATH}/src/thrift/TApplicationException.cpp
    ${SRC_PATH}/src/thrift/VirtualProfiling.cpp
    ${SRC_PATH}/src/thrift/concurrency/ThreadManager.cpp
    ${SRC_PATH}/src/thrift/concurrency/TimerManager.cpp
    ${SRC_PATH}/src/thrift/concurrency/Util.cpp
    ${SRC_PATH}/src/thrift/protocol/TDebugProtocol.cpp
    ${SRC_PATH}/src/thrift/protocol/TDenseProtocol.cpp
    ${SRC_PATH}/src/thrift/protocol/TJSONProtocol.cpp
    ${SRC_PATH}/src/thrift/protocol/TBase64Utils.cpp
    ${SRC_PATH}/src/thrift/protocol/TMultiplexedProtocol.cpp
    ${SRC_PATH}/src/thrift/transport/TTransportException.cpp
    ${SRC_PATH}/src/thrift/transport/TFDTransport.cpp
    ${SRC_PATH}/src/thrift/transport/TFileTransport.cpp
    ${SRC_PATH}/src/thrift/transport/TSimpleFileTransport.cpp
    ${SRC_PATH}/src/thrift/transport/THttpTransport.cpp
    ${SRC_PATH}/src/thrift/transport/THttpClient.cpp
    ${SRC_PATH}/src/thrift/transport/THttpServer.cpp
    ${SRC_PATH}/src/thrift/transport/TSocket.cpp
    ${SRC_PATH}/src/thrift/transport/TPipe.cpp
    ${SRC_PATH}/src/thrift/transport/TPipeServer.cpp
    ${SRC_PATH}/src/thrift/transport/TSSLSocket.cpp
    ${SRC_PATH}/src/thrift/transport/TSocketPool.cpp
    ${SRC_PATH}/src/thrift/transport/TServerSocket.cpp
    ${SRC_PATH}/src/thrift/transport/TSSLServerSocket.cpp
    ${SRC_PATH}/src/thrift/transport/TTransportUtils.cpp
    ${SRC_PATH}/src/thrift/transport/TBufferTransports.cpp
    ${SRC_PATH}/src/thrift/server/TServer.cpp
    ${SRC_PATH}/src/thrift/server/TSimpleServer.cpp
    ${SRC_PATH}/src/thrift/server/TThreadPoolServer.cpp
    ${SRC_PATH}/src/thrift/server/TThreadedServer.cpp
    ${SRC_PATH}/src/thrift/async/TAsyncChannel.cpp
    ${SRC_PATH}/src/thrift/processor/PeekProcessor.cpp
)

set(LIBTHRIFTNB_SOURCES
    ${SRC_PATH}/src/thrift/server/TNonblockingServer.cpp
    ${SRC_PATH}/src/thrift/async/TAsyncProtocolProcessor.cpp
    ${SRC_PATH}/src/thrift/async/TEvhttpServer.cpp
    ${SRC_PATH}/src/thrift/async/TEvhttpClientChannel.cpp
)

set(LIBTHRIFTZ_SOURCES
    ${SRC_PATH}/src/thrift/transport/TZlibTransport.cpp
)

set(LIBTHRIFTQT_SOURCES
    ${SRC_PATH}/src/thrift/qt/moc_TQTcpServer.cpp
    ${SRC_PATH}/src/thrift/qt/TQIODeviceTransport.cpp
    ${SRC_PATH}/src/thrift/qt/TQTcpServer.cpp
)

if(NOT OPENSSL_FOUND)
    # hack to remove TSSLSocket.cpp and TSSLServerSocket.cpp
    # from compilation if OPENSSL not found
    set_source_files_properties(
            ${SRC_PATH}/src/thrift/transport/TSSLSocket.cpp
            ${SRC_PATH}/src/thrift/transport/TSSLServerSocket.cpp
        PROPERTIES HEADER_FILE_ONLY TRUE)
else()
    include_directories(${OPENSSL_INCLUDE_DIR})
endif()

# msvc only??? will check this later
if(MSVC)
    # windows part of the lib
    file(GLOB WIN_SRC ${SRC_PATH}/src/thrift/windows/*.cpp)
    file(GLOB WIN_HDR ${SRC_PATH}/src/thrift/windows/*.h)
    list(APPEND LIBTHRIFT_SOURCES ${WIN_SRC} ${WIN_HDR})
    source_group("libthrift" FILES ${LIBTHRIFT_SOURCES})
endif()

add_library(libthrift ${LIBTHRIFT_SOURCES})

list(APPEND __install_tgts libthrift)

if(ZLIB_FOUND)
    if(MSVC)
        source_group("libthriftz" FILES ${LIBTHRIFTZ_SOURCES})
    endif()

    include_directories(${ZLIB_INCLUDE_DIRS})
    add_library(libthriftz ${LIBTHRIFTZ_SOURCES})
    list(APPEND __install_tgts libthriftz)
endif()

if(LIBEVENT_FOUND)
    if(MSVC)
        source_group("libthriftnb" FILES ${LIBTHRIFTNB_SOURCES})
    endif()

    add_library(libthriftnb ${LIBTHRIFTNB_SOURCES})
    list(APPEND __install_tgts libthriftnb)
endif()

if(QT_FOUND)
    if(MSVC)
        source_group("libthriftqt" FILES ${LIBTHRIFTQT_SOURCES})
    endif()

    add_library(libthriftqt ${LIBTHRIFTQT_SOURCES})
    list(APPEND __install_tgts libthriftqt)
endif()

install(TARGETS ${__install_tgts}
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

install(DIRECTORY ${SRC_PATH}/src/thrift/
    DESTINATION include/thrift FILES_MATCHING PATTERN "*.h")
install(DIRECTORY ${SRC_PATH}/src/thrift/
    DESTINATION include/thrift FILES_MATCHING PATTERN "*.tcc")
