set(MODULE_NAME nodes)

set(MODULE_SRC
    node.cpp
    node.h
    nodesmodule.cpp
    nodesmodule.h
    nodetree.cpp
    nodetree.h
    iproperty.h
)

set(MODULE_LINK
    global
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
