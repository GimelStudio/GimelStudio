# Overview

## Installation

KDBindings is a header-only library, so you could just add the `/src/kdbindings/` directory to your projects include path or copy it into your project and start using KDBindings.

However, we recommend using [CMake](https://cmake.org/) to install KDBindings so it's available to any CMake project on your computer.

For this, first clone the project and install it:

### Linux/macOS
``` shell
mkdir build
cd build
cmake ..
cmake --build . --target install # this command might need super user privileges (i.e. sudo)
```

### Windows:
Navigate to the repository and create a folder named `build`.  
Navigate into the folder.  
Use `Shift`+`Right Click` and select `Open command window here`.  
In the terminal window, run:  
``` cmd
cmake ..
cmake --build . --target install
```

## Accessing KDBindings

### Linking using CMake
After installation, KDBindings is available using CMakes [find_package](https://cmake.org/cmake/help/latest/command/find_package.html) directive.
This directive then exposes a KDAB::KDBindings library that can be linked against.

Example CMake code:
``` cmake
find_package(KDBindings)
target_link_libraries(${PROJECT_NAME} KDAB::KDBindings)
```

Also make sure C++17 or later is enabled in your project:
``` cmake
set(CMAKE_CXX_STANDARD 17)
```

### Including KDBindings
Once the library is correctly added to your project, the different features of KDBindings are available for include under the `kdbindings` directory.

All parts of KDBindings are then accessible in the [KDBindings namespace](../namespaceKDBindings.md).
``` cpp
// Example includes
#include <kdbindings/signal.h>
#include <kdbindings/property.h>

KDBindings::Signal<std::string> mySignal;

// alternatively add a using directive for the namespace
using namespace KDBindings;
Signal<std::string> myOtherSignal;
```

For the list of files that can be included, see [the files page](../Files.md).

## KDBindings Features

KDBindings uses plain C++17 to give you:

- [Signals & Slots](signals-slots.md)
- [Properties](properties.md)
- [Data Bindings](data-binding.md)
