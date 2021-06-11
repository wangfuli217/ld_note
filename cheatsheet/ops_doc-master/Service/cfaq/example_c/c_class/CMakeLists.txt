cmake_minimum_required(VERSION 2.8.11)

project(c_class)



include_directories(
    E:/data/example/c_class/
    E:/data/example/c_class/
    E:/data/example/c_class/inc

)

# Linker options
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS}  ")

# Library path
set(CMAKE_LDFLAGS "${CMAKE_LDFLAGS} -L\".\" ")

# Define the C sources
set ( C_SRCS
    main.c
    employee.c
    person.c
)

set_source_files_properties(
    ${C_SRCS} PROPERTIES COMPILE_FLAGS 
    " -g -O2 -Wall")

add_executable(c_class ${CXX_SRCS} ${C_SRCS})

