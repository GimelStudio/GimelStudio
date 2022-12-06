set(MODULE_NAME actions)

set(MODULE_SRC
    internal/dispatcher.cpp
    internal/dispatcher.h
    actiontypes.h
    idispatcher.h
    iactionable.h
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
