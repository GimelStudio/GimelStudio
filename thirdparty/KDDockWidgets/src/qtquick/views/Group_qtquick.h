/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/


#ifndef KD_FRAME_QUICK_P_H
#define KD_FRAME_QUICK_P_H
#pragma once

#include "View_qtquick.h"
#include "views/GroupViewInterface.h"
#include "TitleBar_qtquick.h"

QT_BEGIN_NAMESPACE
class QQuickItem;
QT_END_NAMESPACE

namespace KDDockWidgets {

namespace Controllers {
class Group;
class DockWidget;
}

namespace Views {

class TabBar_qtquick;
class Stack_qtquick;

class DOCKS_EXPORT Group_qtquick : public View_qtquick, public GroupViewInterface
{
    Q_OBJECT
    Q_PROPERTY(QObject *tabBar READ tabBarObj CONSTANT)
    Q_PROPERTY(KDDockWidgets::Views::TitleBar_qtquick *titleBar READ titleBar CONSTANT)
    Q_PROPERTY(int userType READ userType CONSTANT)
    Q_PROPERTY(KDDockWidgets::Views::TitleBar_qtquick *actualTitleBar READ actualTitleBar NOTIFY
                   actualTitleBarChanged)
    Q_PROPERTY(int currentIndex READ currentIndex NOTIFY currentDockWidgetChanged)
    Q_PROPERTY(bool isMDI READ isMDI NOTIFY isMDIChanged)

public:
    explicit Group_qtquick(Controllers::Group *controller, QQuickItem *parent = nullptr);
    ~Group_qtquick() override;

    /// @reimp
    QSize minSize() const override;

    /// @brief Returns the QQuickItem which represents this group on the screen
    QQuickItem *visualItem() const override;

    int currentIndex() const;

    // QML interface:
    KDDockWidgets::Views::TitleBar_qtquick *titleBar() const;
    KDDockWidgets::Views::TitleBar_qtquick *actualTitleBar() const;
    int userType() const;
    QObject *tabBarObj() const;

protected:
    void removeDockWidget(Controllers::DockWidget *dw) override;
    void insertDockWidget(Controllers::DockWidget *dw, int index) override;

    Q_INVOKABLE void setStackLayout(QQuickItem *);

    int nonContentsHeight() const override;

Q_SIGNALS:
    void isMDIChanged();
    void currentDockWidgetChanged();
    void actualTitleBarChanged();

public Q_SLOTS:
    void updateConstriants();

private:
    void init() override;
    Stack_qtquick *stackView() const;
    TabBar_qtquick *tabBarView() const;

    QQuickItem *m_stackLayout = nullptr;
    QQuickItem *m_visualItem = nullptr;
};

}
}

#endif
