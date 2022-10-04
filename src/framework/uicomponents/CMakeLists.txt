set(MODULE_NAME uicomponents)

set(MODULE_SRC
    ${CMAKE_CURRENT_LIST_DIR}/view/dialogview.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/dialogview.h
    ${CMAKE_CURRENT_LIST_DIR}/view/popupview.cpp
    ${CMAKE_CURRENT_LIST_DIR}/view/popupview.h
    ${CMAKE_CURRENT_LIST_DIR}/uicomponentsmodule.cpp
    ${CMAKE_CURRENT_LIST_DIR}/uicomponentsmodule.h
)

set(MODULE_QRC
    uicomponents.qrc
)

set(MODULE_LINK
    ui
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
