/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#pragma once

#include <kddockwidgets/DockWidget.h>
#include <kddockwidgets/MainWindow.h>

class MyMainWindow : public KDDockWidgets::Views::MainWindow_qtwidgets
{
    Q_OBJECT
public:
    explicit MyMainWindow(const QString &uniqueName, KDDockWidgets::MainWindowOptions options,
                          bool dockWidget0IsNonClosable, bool nonDockableDockWidget9,
                          bool restoreIsRelative, bool maxSizeForDockWidget8,
                          bool dockwidget5DoesntCloseBeforeRestore, bool dock0BlocksCloseEvent,
                          const QString &affinityName = {}, // Usually not needed. Just here to show
                                                            // the feature.
                          QWidget *parent = nullptr);
    ~MyMainWindow() override;

private:
    void createDockWidgets();
    KDDockWidgets::Views::DockWidget_qtwidgets *newDockWidget();
    QMenu *m_toggleMenu = nullptr;
    const bool m_dockWidget0IsNonClosable;
    const bool m_dockWidget9IsNonDockable;
    const bool m_restoreIsRelative;
    const bool m_maxSizeForDockWidget8;
    const bool m_dockwidget5DoesntCloseBeforeRestore;
    const bool m_dock0BlocksCloseEvent;
    QVector<KDDockWidgets::Views::DockWidget_qtwidgets *> m_dockwidgets;
};
