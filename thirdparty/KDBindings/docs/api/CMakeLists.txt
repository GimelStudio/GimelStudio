# This file is part of KDBindings.
#
# SPDX-FileCopyrightText: 2021-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
# Author: Allen Winter <allen.winter@kdab.com>
#
# SPDX-License-Identifier: MIT
#
# Contact KDAB at <info@kdab.com> for commercial licensing options.
#

find_program(DOXYBOOK2_EXECUTABLE doxybook2)
if(NOT DOXYBOOK2_EXECUTABLE)
  message(FATAL_ERROR "\ndoxybook2 (a Doxygen XML to Markdown (or JSON) converter) could not be found. This tool is required to build the API documentation. Consider installing it by following the directions at https://github.com/matusnovak/doxybook2.\nAlternatively, re-run cmake with the -D${PROJECT_NAME}_DOCS=False option.")
endif()

find_program(MKDOCS_EXECUTABLE mkdocs)
if(NOT MKDOCS_EXECUTABLE)
  message(FATAL_ERROR "\nmkdocs (a project documentation tool using Markdown) could not be found. This tool is required to build the API documentation. Consider installing it by following the directions at https://www.mkdocs.org/user-guide/installation.\nAlso you'll need to 'pip install pymdown-extensions mkdocs-material'\nAlternatively, re-run cmake with the -D${PROJECT_NAME}_DOCS=False option.")
endif()

# dot should come with Doxygen find_package(Doxygen)
if(DOXYGEN_DOT_EXECUTABLE)
  set(HAVE_DOT "YES")
else()
  set(HAVE_DOT "NO")
  message(STATUS "Unable to provide inheritance diagrams for the API documentation. To fix, install the graphviz project from https://www.graphviz.org")
endif()

file(GLOB _dox_deps *.dox *.html)
set(DOXYGEN_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR})

#apidox generation using doxygen
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
)
configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/mkdocs/mkdocs.yml.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/mkdocs/mkdocs.yml
)

add_custom_target(docs
  # Execute Doxygen
  COMMAND ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile

  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/mkdocs ${DOXYGEN_OUTPUT_DIR}/mkdocs
  #copy some files by-hand that are referred to by the markdown README.
  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_SOURCE_DIR}/LICENSES/MIT.txt ${DOXYGEN_OUTPUT_DIR}/mkdocs/docs/license.md

  # Run Doxybook2 to generate mkdocs compatible documentation
  COMMAND ${DOXYBOOK2_EXECUTABLE} --config "${CMAKE_CURRENT_SOURCE_DIR}/doxybook/config.json" --input "${DOXYGEN_OUTPUT_DIR}/xml" --output "${DOXYGEN_OUTPUT_DIR}/mkdocs/docs"

  # Run MkDocs to build html documentation
  COMMAND ${MKDOCS_EXECUTABLE} build --config-file "${DOXYGEN_OUTPUT_DIR}/mkdocs/mkdocs.yml" --site-dir "${DOXYGEN_OUTPUT_DIR}/html"

  DEPENDS ${_dox_deps} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  COMMENT "Building Documentation"
)

add_custom_command(TARGET docs
  POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan ""
  COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "Built MkDocs documentation"
  COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan "Use 'mkdocs serve' in the '${DOXYGEN_OUTPUT_DIR}/mkdocs' directory to view the documentation."
  COMMAND ${CMAKE_COMMAND} -E cmake_echo_color --cyan ""
  VERBATIM
)
#The tags file is only created when 'make docs' is run first
if(EXISTS "${DOXYGEN_OUTPUT_DIR}/kdbindings.tags")
  install(FILES ${DOXYGEN_OUTPUT_DIR}/kdbindings.tags DESTINATION ${INSTALL_DOC_DIR})
endif()
