/*
  This file is part of KDBindings.

  SPDX-FileCopyrightText: 2021-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sean Harmer <sean.harmer@kdab.com>

  SPDX-License-Identifier: MIT

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include <kdbindings/binding.h>
#include <kdbindings/property.h>
#include <kdbindings/signal.h>

#include <iostream>

using namespace KDBindings;

static BindingEvaluator evaluator;

class Image
{
public:
    const int bytesPerPixel = 4;
    Property<int> width{ 800 };
    Property<int> height{ 600 };
    const Property<int> byteSize = makeBoundProperty(evaluator, bytesPerPixel *width *height);
};

int main()
{
    Image img;
    std::cout << "The initial size of the image = " << img.byteSize.get() << " bytes" << std::endl;

    img.byteSize.valueChanged().connect([](const int &newValue) {
        std::cout << "The new size of the image = " << newValue << " bytes" << std::endl;
    });

    img.width = 1920;
    img.height = 1080;

    evaluator.evaluateAll();

    return 0;
}
