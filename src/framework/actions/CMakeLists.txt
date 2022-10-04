set(MODULE_NAME actions)

set(MODULE_SRC
    internal/dispatcher.cpp
    internal/dispatcher.h
    actiontypes.h
    dispatcher.h
    idispatcher.h
    istore.h
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
