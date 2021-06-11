cmake_minimum_required(VERSION 3.5)
project(ex2)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")

include_directories(lua lua/src)
include_directories(expat)
add_subdirectory(lua)
LINK_DIRECTORIES(./expat)
set(SOURCE_FILES main.c)
add_executable(ex2 ${SOURCE_FILES})
target_link_libraries(ex2 lua)
target_link_libraries(ex2 libexpat.dylib)