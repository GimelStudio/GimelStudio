cmake_minimum_required(VERSION 3.20)
project(GimelStudio VERSION 1.0)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR})

option(QT_SUPPORT "Build with Qt support" ON)

if (QT_SUPPORT)
    find_package(Qt5 COMPONENTS Core Gui Quick Widgets Xml REQUIRED)
    set(QT_LIBRARIES
        Qt5::Core
        Qt5::Gui
        Qt5::Quick
        Qt5::Widgets
        Qt5::Xml
    )
endif (QT_SUPPORT)

include_directories(PUBLIC
    "${PROJECT_SOURCE_DIR}/src"
)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/build/config.h.in ${CMAKE_BINARY_DIR}/generated/config.h)
include_directories(${CMAKE_BINARY_DIR}/generated)

add_subdirectory(thirdparty)
add_subdirectory(src)

# TODO: Move gimelstudio executable and the required shared libraries (Qt etc.) to "bin"
# install(TARGETS gimelstudio DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
# install(DIRECTORY ${CMAKE_SOURCE_DIR}/share DESTINATION ${CMAKE_INSTALL_PREFIX})
