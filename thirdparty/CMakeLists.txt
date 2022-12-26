set(KDDockWidgets_QTQUICK ON CACHE BOOL "Build for QtQuick instead of QtWidgets" FORCE)
set(KDDockWidgets_EXAMPLES OFF CACHE BOOL "Build the examples" FORCE)
set(KDDockWidgets_TESTS OFF CACHE BOOL "Build the tests" FORCE)

add_subdirectory(KDDockWidgets)
add_subdirectory(KDBindings)
