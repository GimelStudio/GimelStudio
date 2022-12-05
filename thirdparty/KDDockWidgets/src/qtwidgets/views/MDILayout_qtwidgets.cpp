/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "MDILayout_qtwidgets.h"
#include "kddockwidgets/controllers/MDILayout.h"

using namespace KDDockWidgets;
using namespace KDDockWidgets::Views;

MDILayout_qtwidgets::MDILayout_qtwidgets(Controllers::MDILayout *controller, View *parent)
    : Views::View_qtwidgets<QWidget>(controller, Type::MDILayout, Views::View_qt::asQWidget(parent))
    , m_controller(controller)
{
    Q_ASSERT(controller);
}

MDILayout_qtwidgets::~MDILayout_qtwidgets()
{
    if (!freed())
        m_controller->viewAboutToBeDeleted();
}
