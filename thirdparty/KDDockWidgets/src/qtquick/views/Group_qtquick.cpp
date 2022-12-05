/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

/**
 * @file
 * @brief The GUI counterpart of Frame.
 *
 * @author Sérgio Martins \<sergio.martins@kdab.com\>
 */

#include "Group_qtquick.h"

#include "kddockwidgets/controllers/Group.h"
#include "kddockwidgets/controllers/Stack.h"
#include "kddockwidgets/controllers/TitleBar.h"
#include "kddockwidgets/controllers/DockWidget.h"
#include "kddockwidgets/controllers/DockWidget_p.h"

#include "qtquick/ViewFactory_qtquick.h"
#include "qtquick/Platform_qtquick.h"
#include "qtquick/views/TabBar_qtquick.h"
#include "qtquick/views/DockWidget_qtquick.h"
#include "qtquick/views/ViewWrapper_qtquick.h"

#include "Stack_qtquick.h"

#include "Config.h"
#include "kddockwidgets/ViewFactory.h"
#include "private/WidgetResizeHandler_p.h"

#include <QDebug>

using namespace KDDockWidgets;
using namespace KDDockWidgets::Views;

Group_qtquick::Group_qtquick(Controllers::Group *controller, QQuickItem *parent)
    : View_qtquick(controller, Type::Frame, parent)
    , GroupViewInterface(controller)
{
}

Group_qtquick::~Group_qtquick()
{
    disconnect(m_group, &Controllers::Group::isMDIChanged, this, &Group_qtquick::isMDIChanged);

    // The QML item must be deleted with deleteLater(), as we might be currently with its mouse
    // handler in the stack. QML doesn't support it being deleted in that case.
    // So unparent it and deleteLater().
    m_visualItem->setParent(nullptr);
    m_visualItem->deleteLater();
}

void Group_qtquick::init()
{
    connect(m_group->tabBar(), &Controllers::TabBar::countChanged, this,
            &Group_qtquick::updateConstriants);

    connect(this, &View_qtquick::geometryUpdated, this,
            [this] { View::d->layoutInvalidated.emit(); });

    /// QML interface connect, since controllers won't be QObjects for much longer:
    connect(m_group, &Controllers::Group::isMDIChanged, this, &Group_qtquick::isMDIChanged);
    connect(m_group->tabBar(), &Controllers::TabBar::currentDockWidgetChanged, this,
            &Group_qtquick::currentDockWidgetChanged);

    // Minor hack: While the controllers keep track of "current widget",
    // the QML StackLayout deals in "current index", these can differ when removing a non-current
    // tab. The currentDockWidgetChanged() won't be emitted but the index did decrement.
    // As a workaround, always emit the signal, which is harmless if not needed.
    connect(m_group, &Controllers::Group::numDockWidgetsChanged, this,
            &Group_qtquick::currentDockWidgetChanged);

    connect(m_group, &Controllers::Group::actualTitleBarChanged, this,
            &Group_qtquick::actualTitleBarChanged);

    connect(this, &View_qtquick::itemGeometryChanged, this, [this] {
        for (auto dw : m_group->dockWidgets()) {
            auto dwView = static_cast<DockWidget_qtquick *>(asView_qtquick(dw->view()));
            dwView->groupGeometryChanged(geometry());
        }
    });

    QQmlComponent component(plat()->qmlEngine(), plat()->viewFactory()->groupFilename());

    m_visualItem = static_cast<QQuickItem *>(component.create());

    if (!m_visualItem) {
        qWarning() << Q_FUNC_INFO << "Failed to create item" << component.errorString();
        return;
    }

    m_visualItem->setProperty("groupCpp", QVariant::fromValue(this));
    m_visualItem->setParentItem(this);
    m_visualItem->setParent(this);
}

void Group_qtquick::updateConstriants()
{
    m_group->onDockWidgetCountChanged();

    // QtQuick doesn't have layouts, so we need to do constraint propagation manually

    setProperty("kddockwidgets_min_size", minSize());
    setProperty("kddockwidgets_max_size", maxSizeHint());

    View::d->layoutInvalidated.emit();
}

void Group_qtquick::removeDockWidget(Controllers::DockWidget *dw)
{
    m_group->tabBar()->removeDockWidget(dw);
}

int Group_qtquick::currentIndex() const
{
    return m_group->currentIndex();
}

void Group_qtquick::insertDockWidget(Controllers::DockWidget *dw, int index)
{
    QPointer<Controllers::Group> oldFrame = dw->d->group();
    m_group->tabBar()->insertDockWidget(index, dw, {}, {});

    dw->setParentView(ViewWrapper_qtquick::create(m_stackLayout).get());
    makeItemFillParent(View_qtquick::asQQuickItem(dw->view()));
    m_group->setCurrentDockWidget(dw);

    if (oldFrame && oldFrame->beingDeletedLater()) {
        // give it a push and delete it immediately.
        // Having too many deleteLater() puts us in an inconsistent state. For example if
        // LayoutSaver::saveState() would to be called while the Frame hadn't been deleted yet
        // it would count with that group unless hacks. Also the unit-tests are full of
        // waitForDeleted() due to deleteLater.

        // Ideally we would just remove the deleteLater from Group.cpp, but
        // QTabWidget::insertTab() would crash, as it accesses the old tab-widget we're stealing
        // from

        delete oldFrame;
    }
}

void Group_qtquick::setStackLayout(QQuickItem *stackLayout)
{
    if (m_stackLayout || !stackLayout) {
        qWarning() << Q_FUNC_INFO << "Shouldn't happen";
        return;
    }

    m_stackLayout = stackLayout;
}

QSize Group_qtquick::minSize() const
{
    const QSize contentsSize = m_group->dockWidgetsMinSize();
    return contentsSize + QSize(0, nonContentsHeight());
}

QObject *Group_qtquick::tabBarObj() const
{
    return tabBarView();
}

QQuickItem *Group_qtquick::visualItem() const
{
    return m_visualItem;
}

int Group_qtquick::nonContentsHeight() const
{
    return m_visualItem->property("nonContentsHeight").toInt();
}

Stack_qtquick *Group_qtquick::stackView() const
{
    if (auto stack = m_group->stack())
        return qobject_cast<Stack_qtquick *>(asQQuickItem(stack->view()));

    return nullptr;
}

TabBar_qtquick *Group_qtquick::tabBarView() const
{
    if (auto tabBar = m_group->tabBar())
        return qobject_cast<TabBar_qtquick *>(asQQuickItem(tabBar->view()));

    return nullptr;
}

KDDockWidgets::Views::TitleBar_qtquick *Group_qtquick::titleBar() const
{
    if (auto tb = m_group->titleBar()) {
        return dynamic_cast<KDDockWidgets::Views::TitleBar_qtquick *>(tb->view());
    }

    return nullptr;
}

KDDockWidgets::Views::TitleBar_qtquick *Group_qtquick::actualTitleBar() const
{
    if (auto tb = m_group->actualTitleBar()) {
        return dynamic_cast<KDDockWidgets::Views::TitleBar_qtquick *>(tb->view());
    }

    return nullptr;
}

int Group_qtquick::userType() const
{
    /// TODOm3
    return 0;
}
