# This file is part of KDBindings.
#
# SPDX-FileCopyrightText: 2021-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
# Author: Sean Harmer <sean.harmer@kdab.com>
#
# SPDX-License-Identifier: MIT
#
# Contact KDAB at <info@kdab.com> for commercial licensing options.
#

# This is the top-level CMakeLists.txt file for the KDBindings project.
#
# Pass the following variables to cmake to control the build:
# (See INSTALL.txt for more information)
#
# -DKDBindings_TESTS=[true|false]
#  Build the test harness.
#  Default=true
#
# -DKDBindings_EXAMPLES=[true|false]
#  Build the examples.
#  Default=true
#
# -DKDBindings_DOCS=[true|false]
#  Build the API documentation. Enables the 'docs' build target.
#  Default=false
#

cmake_minimum_required(VERSION 3.12) # for `project(... HOMEPAGE_URL ...)`

project(KDBindings
  DESCRIPTION "Bindings, from the comfort and speed of C++ and without Qt"
  LANGUAGES CXX
  VERSION 1.0.1
  HOMEPAGE_URL "https://github.com/KDAB/KDBindings"
)

include(FeatureSummary)

option(${PROJECT_NAME}_TESTS "Build the tests" ON)
option(${PROJECT_NAME}_EXAMPLES "Build the examples" ON)
option(${PROJECT_NAME}_DOCS "Build the API documentation" OFF)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/ECM/modules)

# Set a default build type if none was specified
set(default_build_type "Release")
if(EXISTS "${CMAKE_SOURCE_DIR}/.git")
  set(default_build_type "Debug")
endif()
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message(STATUS "Setting build type to ${default_build_type} as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# setup default install locations
include(InstallLocation)

if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  set(${PROJECT_NAME}_IS_ROOT_PROJECT TRUE)

  message(STATUS "Building ${PROJECT_NAME} ${${PROJECT_NAME}_VERSION} in ${CMAKE_BUILD_TYPE} mode.")

  install(FILES README.md DESTINATION ${INSTALL_DOC_DIR})
  install(DIRECTORY LICENSES DESTINATION ${INSTALL_DOC_DIR})
else()
  #Always disable tests, examples, docs when used as a submodule
  set(${PROJECT_NAME}_IS_ROOT_PROJECT FALSE)
  set(${PROJECT_NAME}_TESTS FALSE)
  set(${PROJECT_NAME}_EXAMPLES FALSE)
  set(${PROJECT_NAME}_DOCS FALSE)
endif()

if(${PROJECT_NAME}_TESTS)
  enable_testing()
endif()

add_subdirectory(src/kdbindings)

if(${PROJECT_NAME}_TESTS)
  add_subdirectory(tests)
endif()
if(${PROJECT_NAME}_EXAMPLES)
  add_subdirectory(examples)
endif()

if(${PROJECT_NAME}_DOCS)
  add_subdirectory(docs) # needs to go last, in case there are build source files
else()
  add_custom_target(docs
    COMMAND ${CMAKE_COMMAND} -E echo "Sorry, there is no docs target since KDBindings_DOCS=OFF."
    "Re-run cmake with the -DKDBindings_DOCS=ON option if you want to generate the documentation.")
endif()

if(${PROJECT_NAME}_IS_ROOT_PROJECT)
  # Add uninstall target (not for submodules since parent projects typically have uninstall too)
  include(ECMUninstallTarget)
endif()

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
