set(MODULE_NAME interactive)

# TODO: Create the module files (interactivemodule.[cpp,h])
set(MODULE_SRC
    internal/interactive.cpp
    internal/interactive.h
    iinteractive.h
    interactive.h
)

set(MODULE_LINK
    global
)

include(${PROJECT_SOURCE_DIR}/build/module.cmake)
