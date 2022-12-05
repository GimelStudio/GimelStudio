set(MODULE_NAME shortcuts)

set(MODULE_SRC
    view/shortcutsmodel.cpp
    view/shortcutsmodel.h
    shortcutsmodule.cpp
    shortcutsmodule.h
)

set(MODULE_QRC
    ${CMAKE_CURRENT_LIST_DIR}/shortcuts.qrc
)

set(MODULE_LINK
    actions
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
