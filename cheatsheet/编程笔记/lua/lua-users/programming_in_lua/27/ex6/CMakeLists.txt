cmake_minimum_required(VERSION 3.5)
project(ex6)

include_directories(lua lua/src)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
add_subdirectory(lua)

set(SOURCE_FILES main.c )

add_executable(ex6 ${SOURCE_FILES})
target_link_libraries(ex6 lua)