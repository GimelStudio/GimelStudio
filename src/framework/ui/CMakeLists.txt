set(MODULE_NAME ui)

set(MODULE_SRC
    uiengines.cpp
    uiengines.h
    uimodule.cpp
    uimodule.h
    uitheme.cpp
    uitheme.h
)

set(MODULE_LINK
    global
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
