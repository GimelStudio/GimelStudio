set(MODULE_NAME appshell)

set(MODULE_SRC
    ${CMAKE_CURRENT_LIST_DIR}/internal/appshellactionsstore.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/appshellactionsstore.h
    ${CMAKE_CURRENT_LIST_DIR}/appshell.cpp
    ${CMAKE_CURRENT_LIST_DIR}/appshell.h
    ${CMAKE_CURRENT_LIST_DIR}/appshellmodule.cpp
    ${CMAKE_CURRENT_LIST_DIR}/appshellmodule.h
)

set(MODULE_QRC
    ${CMAKE_CURRENT_LIST_DIR}/appshell.qrc
)

set(MODULE_LINK
    actions
    global
    interactive
    uicomponents
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
