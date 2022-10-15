set(MODULE_NAME shortcuts)

set(MODULE_SRC
    internal/shortcutsregister.cpp
    internal/shortcutsregister.h
)

set(MODULE_LINK
    actions
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
