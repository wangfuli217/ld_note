cmake_minimum_required(VERSION 2.8)
project(libevthr)

include_directories(${CMAKE_INCLUDE_PATH})

add_library(libevthr STATIC evthr.c)
set_target_properties(libevthr PROPERTIES OUTPUT_NAME "evthr")

install (TARGETS libevthr DESTINATION lib)
install (FILES evthr.h DESTINATION include)
