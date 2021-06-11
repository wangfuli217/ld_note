cmake_minimum_required(VERSION 3.5)
project(ex3)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")

include_directories(lua lua/src expat)
add_subdirectory(lua)
link_directories(expat)
set(SOURCE_FILES main.c)
add_executable(ex3 ${SOURCE_FILES})
target_link_libraries(ex3 lua)
target_link_libraries(ex3 libexpat.dylib)