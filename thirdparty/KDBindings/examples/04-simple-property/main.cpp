/*
  This file is part of KDBindings.

  SPDX-FileCopyrightText: 2021-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sean Harmer <sean.harmer@kdab.com>

  SPDX-License-Identifier: MIT

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include <kdbindings/property.h>

#include <iostream>
#include <string>

using namespace KDBindings;

class Widget
{
public:
    Widget(std::string const &name)
        : value(0)
        , m_name(name)
    {
    }

    Property<int> value;

private:
    std::string m_name;
};

int main()
{
    Widget w("A cool widget");

    w.value.valueChanged().connect([](int newValue) {
        std::cout << "The new value is " << newValue << std::endl;
    });

    w.value = 42;
    w.value = 69;

    std::cout << "Property value is " << w.value << std::endl;

    return 0;
}
