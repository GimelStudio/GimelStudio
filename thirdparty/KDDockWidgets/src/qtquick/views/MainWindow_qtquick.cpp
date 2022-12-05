/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "MainWindow_qtquick.h"
#include "kddockwidgets/controllers/Layout.h"
#include "kddockwidgets/controllers/MainWindow.h"
#include "kddockwidgets/private/DockRegistry.h"
#include "private/multisplitter/Item_p.h"
#include "Window.h"

#include <QDebug>
#include <QTimer>

using namespace KDDockWidgets;
using namespace KDDockWidgets::Views;

namespace KDDockWidgets {
class MainWindow_qtquick::Private
{
public:
    Private(MainWindow_qtquick *qq)
        : q(qq)
    {
    }

    void onLayoutGeometryUpdated()
    {
        const QSize minSz = q->minSize();
        const bool mainWindowIsTooSmall = minSz.expandedTo(q->View::size()) != q->View::size();
        if (mainWindowIsTooSmall) {
            if (q->isRootView()) {
                // If we're a top-level, let's go ahead and resize the QWindow
                // any other case is too complex for QtQuick as there's no layout propagation.
                q->window()->resize(minSz.width(), minSz.height());
            }
        }
    }

    MainWindow_qtquick *const q;
};
}


MainWindow_qtquick::MainWindow_qtquick(const QString &uniqueName, MainWindowOptions options,
                                       QQuickItem *parent, Qt::WindowFlags flags)
    : View_qtquick(new Controllers::MainWindow(this, uniqueName, options), Type::MainWindow, parent,
                   flags)
    , MainWindowViewInterface(static_cast<Controllers::MainWindow *>(View::controller()))
    , d(new Private(this))
{
    MainWindowViewInterface::init(uniqueName);
    makeItemFillParent(this);

    Controllers::Layout *lw = m_mainWindow->layout();
    auto layoutView = asView_qtquick(lw->view());
    makeItemFillParent(layoutView);

    // MainWindowQuick has the same constraints as Layout, so just forward the signal
    connect(layoutView, &View_qtquick::geometryUpdated, this, &MainWindow_qtquick::geometryUpdated);

    connect(layoutView, &View_qtquick::geometryUpdated, this,
            [this] { d->onLayoutGeometryUpdated(); });

    {
        // This block silences a benign layouting constraints warning.
        // During initialization, QtQuick will evaluate the width and height bindings separately,
        // meaning our first Layout::setSize() might have height=0 still, as we're processing the
        // width binding.

        auto timer = new QTimer(this);
        timer->setSingleShot(true);
        timer->start();
        Layouting::Item::s_silenceSanityChecks = true;
        timer->callOnTimeout([] { Layouting::Item::s_silenceSanityChecks = false; });
    }
}

MainWindow_qtquick::~MainWindow_qtquick()
{
    if (isRootView()) {
        if (auto window = this->window()) {
            QObject::setParent(nullptr);
            window->destroy();
        }
    }

    delete d;
}

QSize MainWindow_qtquick::minSize() const
{
    return m_mainWindow->layout()->layoutMinimumSize();
}

QSize MainWindow_qtquick::maxSizeHint() const
{
    return m_mainWindow->layout()->layoutMaximumSizeHint();
}

QMargins MainWindow_qtquick::centerWidgetMargins() const
{
    qDebug() << Q_FUNC_INFO << "SideBar hasn't been implemented yet";
    return {};
}

QRect MainWindow_qtquick::centralAreaGeometry() const
{
    qFatal("Not implemented");
    return {};
}

void MainWindow_qtquick::setContentsMargins(int left, int top, int right, int bottom)
{
    Q_UNUSED(left);
    Q_UNUSED(right);
    Q_UNUSED(top);
    Q_UNUSED(bottom);
    qDebug() << Q_FUNC_INFO << "not implemented";
}
