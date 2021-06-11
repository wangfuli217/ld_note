cmake_minimum_required(VERSION 3.5)
project(ex2)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c99")

include_directories(lua/src lua)
add_subdirectory(lua)

set(SOURCE_FILES main.c)
add_executable(ex2 ${SOURCE_FILES})
target_link_libraries(ex2 lua)