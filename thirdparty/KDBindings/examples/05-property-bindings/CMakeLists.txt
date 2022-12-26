# This file is part of KDBindings.
#
# SPDX-FileCopyrightText: 2021-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
# Author: Sean Harmer <sean.harmer@kdab.com>
#
# SPDX-License-Identifier: MIT
#
# Contact KDAB at <info@kdab.com> for commercial licensing options.
#

project(05-property-bindings VERSION 0.1 LANGUAGES CXX)

add_executable(${PROJECT_NAME}
    main.cpp
)
target_link_libraries(${PROJECT_NAME} KDAB::KDBindings)
