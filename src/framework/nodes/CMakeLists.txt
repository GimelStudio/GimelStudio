set(MODULE_NAME nodes)

set(MODULE_SRC
    nodesmodule.cpp
    nodesmodule.h
)

set(MODULE_LINK
    global
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
