/*
  This file is part of KDBindings.

  SPDX-FileCopyrightText: 2021-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sean Harmer <sean.harmer@kdab.com>

  SPDX-License-Identifier: MIT

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include <kdbindings/signal.h>

#include <iostream>
#include <string>

using namespace KDBindings;

class Button
{
public:
    Signal<> clicked;
};

class Message
{
public:
    void display() const
    {
        std::cout << "Hello World!" << std::endl;
    }
};

int main()
{
    Button button;
    Message message;

    button.clicked.connect(&Message::display, &message);
    button.clicked.emit();

    return 0;
}
