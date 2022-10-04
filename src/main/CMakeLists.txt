add_executable(gimelstudio
    ${CMAKE_CURRENT_LIST_DIR}/main.cpp
)

target_link_libraries(gimelstudio PRIVATE
    ${QT_LIBRARIES}
    actions
    appshell
    interactive
    ui
    uicomponents
)
