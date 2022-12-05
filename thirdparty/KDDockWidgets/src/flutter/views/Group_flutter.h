/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#pragma once

#include "View_flutter.h"
#include "views/GroupViewInterface.h"
#include "TitleBar_flutter.h"

namespace KDDockWidgets {

namespace Controllers {
class Group;
class DockWidget;
}

namespace Views {

class Stack_flutter;

class DOCKS_EXPORT Group_flutter : public View_flutter, public GroupViewInterface
{
public:
    explicit Group_flutter(Controllers::Group *controller, View *parent = nullptr);
    ~Group_flutter() override;

    /// @reimp
    QSize minSize() const override;

    /// @reimp
    QSize maxSizeHint() const override;

    QRect dragRect() const override;
    int currentIndex() const;

protected:
    int nonContentsHeight() const override;

private:
    void init() override;
};

}
}
