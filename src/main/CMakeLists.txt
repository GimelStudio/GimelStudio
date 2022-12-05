add_executable(gimelstudio)

qt5_add_resources(RCC ${CMAKE_SOURCE_DIR}/share/share.qrc)

target_sources(gimelstudio PRIVATE
    ${RCC}
    ${CMAKE_CURRENT_LIST_DIR}/main.cpp
)

target_link_libraries(gimelstudio PRIVATE
    ${QT_LIBRARIES}
    KDAB::kddockwidgets
    actions
    appshell
    dev
    interactive
    ui
    uicomponents
)
