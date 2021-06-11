cmake_minimum_required(VERSION 3.5)
project(ex1)

include_directories(lua/src lua)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
add_subdirectory(lua)
set(SOURCE_FILES main.c)
add_executable(ex1 ${SOURCE_FILES})
target_link_libraries(ex1 lua)
