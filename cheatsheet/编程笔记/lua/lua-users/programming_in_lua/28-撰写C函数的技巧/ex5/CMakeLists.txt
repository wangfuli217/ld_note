cmake_minimum_required(VERSION 3.5)
project(ex5)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")

include_directories(lua lua/src)

add_subdirectory(lua)
set(SOURCE_FILES main.c)
add_executable(ex5 ${SOURCE_FILES})
target_link_libraries(ex5 lua)