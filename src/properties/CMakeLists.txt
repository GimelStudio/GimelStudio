set(MODULE_NAME properties)

set(MODULE_SRC
    propertiesmodule.cpp
    propertiesmodule.h
)

set(MODULE_LINK
    global
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
