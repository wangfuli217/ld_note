cmake_minimum_required(VERSION 3.5)
project(untitled)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")

set(SOURCE_FILES main.c)
#search path
include_directories(lua/src)
include_directories(lua)
#sub cmake
add_subdirectory (lua)

add_executable(untitled ${SOURCE_FILES})
#link lua
target_link_libraries(untitled lua)