cmake_minimum_required(VERSION 3.6)
project(ex2)

set(CMAKE_C_STANDARD 11)
include_directories(lua lua/src)
add_subdirectory(lua)
set(SOURCE_FILES main.c)
add_executable(ex2 ${SOURCE_FILES})
target_link_libraries(ex2 lua)