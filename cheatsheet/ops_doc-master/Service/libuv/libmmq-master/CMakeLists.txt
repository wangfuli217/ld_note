cmake_minimum_required (VERSION 2.8)
project (mmq)
set (LINUX (NOT APPLE AND NOT WIN32))
set (CMAKE_CONFIGURATION_TYPES "Release")


include_directories("${PROJECT_SOURCE_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/libuv/include")


#libuv 
set(LIBUVDIR libuv)

include_directories(${LIBUVDIR}/include ${LIBUVDIR}/src)
set(UVSOURCES
  ${LIBUVDIR}/src/fs-poll.c
  ${LIBUVDIR}/src/inet.c
  ${LIBUVDIR}/src/uv-common.c
  ${LIBUVDIR}/src/version.c
  ${LIBUVDIR}/src/threadpool.c)

if(WIN32)
  add_definitions(-DWIN32_LEAN_AND_MEAN -D_WIN32_WINNT=0x0600 -D_CRT_SECURE_NO_WARNINGS)
  include_directories(${LIBUVDIR}/src/win)
  set(UVSOURCES ${UVSOURCES}
    ${LIBUVDIR}/src/win/getnameinfo.c
    ${LIBUVDIR}/src/win/async.c
    ${LIBUVDIR}/src/win/core.c
    ${LIBUVDIR}/src/win/dl.c
    ${LIBUVDIR}/src/win/error.c
    ${LIBUVDIR}/src/win/fs-event.c
    ${LIBUVDIR}/src/win/fs.c
    ${LIBUVDIR}/src/win/getaddrinfo.c
    ${LIBUVDIR}/src/win/handle.c
    ${LIBUVDIR}/src/win/loop-watcher.c
    ${LIBUVDIR}/src/win/pipe.c
    ${LIBUVDIR}/src/win/poll.c
    ${LIBUVDIR}/src/win/process-stdio.c
    ${LIBUVDIR}/src/win/process.c
    ${LIBUVDIR}/src/win/req.c
    ${LIBUVDIR}/src/win/signal.c
    ${LIBUVDIR}/src/win/stream.c
    ${LIBUVDIR}/src/win/tcp.c
    ${LIBUVDIR}/src/win/thread.c
    ${LIBUVDIR}/src/win/timer.c
    ${LIBUVDIR}/src/win/tty.c
    ${LIBUVDIR}/src/win/udp.c
    ${LIBUVDIR}/src/win/util.c
    ${LIBUVDIR}/src/win/winapi.c
    ${LIBUVDIR}/src/win/winsock.c)
else()
  include_directories(${LIBUVDIR}/src/unix)
  set(UVSOURCES ${UVSOURCES}
    ${LIBUVDIR}/src/unix/getnameinfo.c

    ${LIBUVDIR}/src/unix/async.c
    ${LIBUVDIR}/src/unix/core.c
    ${LIBUVDIR}/src/unix/dl.c
    ${LIBUVDIR}/src/unix/fs.c
    ${LIBUVDIR}/src/unix/fsevents.c
    ${LIBUVDIR}/src/unix/getaddrinfo.c
    ${LIBUVDIR}/src/unix/loop-watcher.c
    ${LIBUVDIR}/src/unix/loop.c
    ${LIBUVDIR}/src/unix/pipe.c
    ${LIBUVDIR}/src/unix/poll.c
    ${LIBUVDIR}/src/unix/process.c
    ${LIBUVDIR}/src/unix/signal.c
    ${LIBUVDIR}/src/unix/stream.c
    ${LIBUVDIR}/src/unix/tcp.c
    ${LIBUVDIR}/src/unix/thread.c
    ${LIBUVDIR}/src/unix/timer.c
    ${LIBUVDIR}/src/unix/tty.c
    ${LIBUVDIR}/src/unix/udp.c)
    if (APPLE)
       set(UVSOURCES ${UVSOURCES}
        ${LIBUVDIR}/src/unix/kqueue.c
        ${LIBUVDIR}/src/unix/darwin.c
        ${LIBUVDIR}/src/unix/darwin-proctitle.c
       )

    endif()
endif()


add_library(
  mmq SHARED
    mmq.h
    mmq_msg.h
    mmq_msg.c 
    mmq_peer.c
    ${UVSOURCES}
)


add_executable(
  mmq_test
    mmq.h
    mmq_test.cpp
    mmq_msg.h
    mmq_msg.c 
    mmq_peer.c
    ${UVSOURCES}
)


if(MSVC)
    foreach(flag_var CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)
        if(${flag_var} MATCHES "/MD")
            string(REGEX REPLACE "/MD" "/MT" ${flag_var} "${${flag_var}}")
        endif(${flag_var} MATCHES "/MD")
        if(${flag_var} MATCHES "/MDd")
            string(REGEX REPLACE "/MDd" "/MTd" ${flag_var} "${${flag_var}}")
        endif(${flag_var} MATCHES "/MDd")
    endforeach(flag_var)
endif()

if (WIN32)
target_link_libraries (
  mmq_test 
    advapi32.lib
    iphlpapi.lib
    psapi.lib
    shell32.lib
    ws2_32.lib
)
target_link_libraries (
  mmq 
    advapi32.lib
    iphlpapi.lib
    psapi.lib
    shell32.lib
    ws2_32.lib
)
endif()
