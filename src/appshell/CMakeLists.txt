set(MODULE_NAME appshell)

set(MODULE_SRC
    ${CMAKE_CURRENT_LIST_DIR}/internal/appshelluiactions.cpp
    ${CMAKE_CURRENT_LIST_DIR}/internal/appshelluiactions.h
    ${CMAKE_CURRENT_LIST_DIR}/view/gsviewfactory.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/gsviewfactory.h
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
    shortcuts
    uicomponents
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
