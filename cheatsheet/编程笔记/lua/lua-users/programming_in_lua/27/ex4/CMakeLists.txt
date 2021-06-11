cmake_minimum_required(VERSION 3.5.2)
project(ex4)

set(CMAKE_C_STANDARD 11)

include_directories(lua lua/src)
add_subdirectory(lua)
set(SOURCE_FILES main.c)
add_executable(ex4 ${SOURCE_FILES})
target_link_libraries(ex4 lua)