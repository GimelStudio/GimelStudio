set(MODULE_NAME dev)

set(MODULE_SRC
    ${CMAKE_CURRENT_LIST_DIR}/internal/devactionsstore.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/devactionsstore.h
    ${CMAKE_CURRENT_LIST_DIR}/devmodule.cpp
    ${CMAKE_CURRENT_LIST_DIR}/devmodule.h
)

set(MODULE_QRC
    ${CMAKE_CURRENT_LIST_DIR}/dev.qrc
)

set(MODULE_LINK
    actions
    global
    interactive
    ui
    uicomponents
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
