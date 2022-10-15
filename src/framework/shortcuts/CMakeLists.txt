set(MODULE_NAME shortcuts)

set(MODULE_SRC
    internal/shortcutshandler.cpp
    internal/shortcutshandler.h
    view/shortcutsmodel.cpp
    view/shortcutsmodel.h
)

set(MODULE_LINK
    actions
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
