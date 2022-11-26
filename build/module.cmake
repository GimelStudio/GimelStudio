message(STATUS "Configuring " ${MODULE_NAME})

if (NOT PROJECT_ROOT_DIR)
    set(PROJECT_ROOT_DIR ${PROJECT_SOURCE_DIR})
endif()

add_library(${MODULE_NAME} STATIC)

qt5_add_resources(MODULE_RCC ${MODULE_QRC})
qt5_add_big_resources(MODULE_BIG_RCC ${MODULE_BIG_QRC})

target_sources(${MODULE_NAME} PRIVATE
    ${MODULE_RCC}
    ${MODULE_BIG_RCC}
    ${MODULE_SRC}
)

target_include_directories(${MODULE_NAME} PUBLIC
    ${PROJECT_BINARY_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${PROJECT_ROOT_DIR}
    ${PROJECT_ROOT_DIR}/src
    ${PROJECT_ROOT_DIR}/src/framework
    ${PROJECT_ROOT_DIR}/src/framework/global
    ${MODULE_INCLUDE}
)

set(MODULE_LINK ${QT_LIBRARIES} ${MODULE_LINK})
target_link_libraries(${MODULE_NAME} PRIVATE ${MODULE_LINK})
