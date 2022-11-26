set(MODULE_NAME global)

include(${CMAKE_CURRENT_LIST_DIR}/modularity/modularity.cmake)

set(MODULE_SRC
    ${MODULARITY_SRC}
    ret.cpp
    ret.h
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
