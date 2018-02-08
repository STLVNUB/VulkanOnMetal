cmake_minimum_required(VERSION 3.0)

file(GLOB HEADERS *.h)
file(GLOB SOURCES *.cpp)

add_library(spirv_cross STATIC ${HEADERS} ${SOURCES})
set_property(TARGET spirv_cross PROPERTY CXX_STANDARD 14)
