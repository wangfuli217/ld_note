cmake_minimum_required(VERSION 3.5)
project(mylib)
include_directories( ../lua/src)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")

set(SOURCE_FILES mylib.c)
link_directories(/Users/xinlei.fan/Documents/workspace/programming_in_lua/27/ex6/lua)

add_library(mylib MODULE ${SOURCE_FILES})
target_link_libraries(mylib liblua.dylib)



