/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

/**
 * @file
 * @brief QMainWindow sub-class to enable KDDockWidgets support.
 *
 * @author Sérgio Martins \<sergio.martins@kdab.com\>
 */

#ifndef KD_MAINWINDOW_H
#define KD_MAINWINDOW_H

#include "View_qtwidgets.h"
#include "kddockwidgets/views/MainWindowViewInterface.h"

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QHBoxLayout;
QT_END_NAMESPACE

namespace KDDockWidgets {

namespace Controllers {
class MainWindow;
class SideBar;
}

namespace Views {

/**
 * @brief The QMainwindow sub-class that the application should use to be able
 * to dock KDDockWidget DockWidget instances.
 */
class DOCKS_EXPORT MainWindow_qtwidgets : public View_qtwidgets<QMainWindow>,
                                          public MainWindowViewInterface
{
    Q_OBJECT
public:
    using MainWindowViewInterface::addDockWidget; // don't consider QMainWindow's one

    ///@brief Constructor. Use it as you would use QMainWindow.
    ///@param uniqueName Mandatory name that should be unique between all MainWindow instances.
    ///       This name won't be user visible and just used internally for the save/restore.
    ///@param options optional MainWindowOptions to use
    ///@param parent QObject *parent to pass to QMainWindow constructor.
    ///@param flags Window flags to  pass to QMainWindow constructor.
    explicit MainWindow_qtwidgets(const QString &uniqueName, MainWindowOptions options = {},
                                  QWidget *parent = nullptr,
                                  Qt::WindowFlags flags = Qt::WindowFlags());


    /// @brief Destructor
    ~MainWindow_qtwidgets() override;

    /// @brief returns the margins for the contents widget
    QMargins centerWidgetMargins() const override;

    /// @brief sets the margins for the contents widget
    void setCenterWidgetMargins(const QMargins &);

    /// @brief Sets the main window's content margins
    void setContentsMargins(int left, int top, int right, int bottom) override;

    void setPersistentCentralWidget(QWidget *widget);
    QWidget *persistentCentralWidget() const;

    ///@brief returns the internal layout
    /// this is rarely needed unless you want to layout other widgets next to the
    /// main dock widget layout
    QHBoxLayout *internalLayout() const;

    /// @brief for internal use only
    void updateMargins();

protected:
    QRect centralAreaGeometry() const override;

private:
    friend class Controllers::MainWindow;
    using QMainWindow::setCentralWidget;
    void setCentralWidget(QWidget *); // overridden just to make it private

    class Private;
    Private *const d;
};
}
}

#endif
