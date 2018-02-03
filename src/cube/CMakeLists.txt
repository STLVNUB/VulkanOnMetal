cmake_minimum_required(VERSION 3.0)

add_definitions("-DVK_USE_PLATFORM_MACOS_MVK")

file(GLOB HEADERS *.h)
file(GLOB SOURCES *.m)

set(SOURCES
    ${SOURCES}
    Resources/Info.plist
    Resources/Main.storyboard
)

add_executable(cube MACOSX_BUNDLE ${HEADERS} ${SOURCES})
target_link_libraries(cube VulkanOnMetal)
target_link_libraries(cube objc "-framework Foundation -framework Cocoa -framework CoreVideo -framework QuartzCore")
set_target_properties(
    cube
    PROPERTIES
    RESOURCE Resources/Main.storyboard
    MACOSX_BUNDLE_INFO_PLIST ${CMAKE_CURRENT_SOURCE_DIR}/Resources/Info.plist
)
