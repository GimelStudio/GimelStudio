set(MODULE_NAME properties)

set(MODULE_SRC
    integerproperty.h
    propertiesmodule.cpp
    propertiesmodule.h
)

set(MODULE_LINK
    global
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
