/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2020-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "TitleBar.h"
#include "Config.h"
#include "kddockwidgets/ViewFactory.h"
#include "View.h"
#include "private/WindowBeingDragged_p.h"
#include "private/Utils_p.h"
#include "private/Logging_p.h"

#include "views/TitleBarViewInterface.h"
#include "controllers/DockWidget_p.h"
#include "controllers/FloatingWindow.h"
#include "controllers/TabBar.h"
#include "controllers/MainWindow.h"
#include "controllers/MDILayout.h"
#include "controllers/Stack.h"

#include <QTimer>

using namespace KDDockWidgets;
using namespace KDDockWidgets::Controllers;


TitleBar::TitleBar(Group *parent)
    : Controller(
        Type::TitleBar,
        Config::self().viewFactory()->createTitleBar(this, parent ? parent->view() : nullptr))
    , Draggable(view())
    , m_group(parent)
    , m_floatingWindow(nullptr)
    , m_supportsAutoHide(Config::self().flags() & Config::Flag_AutoHideSupport)
{
    init();
    connect(m_group, &Group::numDockWidgetsChanged, this, &TitleBar::updateCloseButton);
    connect(m_group, &Group::numDockWidgetsChanged, this, &TitleBar::numDockWidgetsChanged);
    connect(m_group, &Group::isFocusedChanged, this, &TitleBar::isFocusedChanged);
    connect(m_group, &Group::isInMainWindowChanged, this, &TitleBar::updateAutoHideButton);
}

TitleBar::TitleBar(FloatingWindow *parent)
    : Controller(
        Type::TitleBar,
        Config::self().viewFactory()->createTitleBar(this, parent ? parent->view() : nullptr))
    , Draggable(view())
    , m_group(nullptr)
    , m_floatingWindow(parent)
    , m_supportsAutoHide(Config::self().flags() & Config::Flag_AutoHideSupport)
{
    init();
    connect(m_floatingWindow, &FloatingWindow::numFramesChanged, this, &TitleBar::updateButtons);
    connect(m_floatingWindow, &FloatingWindow::numDockWidgetsChanged, this,
            &TitleBar::numDockWidgetsChanged);
    connect(m_floatingWindow, &FloatingWindow::windowStateChanged, this,
            &TitleBar::updateMaximizeButton);
    connect(m_floatingWindow, &FloatingWindow::activatedChanged, this, &TitleBar::isFocusedChanged);
}

void TitleBar::init()
{
    view()->init();
    view()->setSizePolicy(SizePolicy::Minimum, SizePolicy::Fixed);

    connect(this, &TitleBar::isFocusedChanged, this, [this] {
        // repaint
        view()->update();
    });

    updateButtons();
    QTimer::singleShot(0, this, &TitleBar::updateAutoHideButton); // have to wait after the group is
                                                                  // constructed
}

TitleBar::~TitleBar()
{
}

bool TitleBar::titleBarIsFocusable() const
{
    return Config::self().flags() & Config::Flag_TitleBarIsFocusable;
}


MainWindow *TitleBar::mainWindow() const
{
    if (m_floatingWindow)
        return nullptr;

    if (m_group)
        return m_group->mainWindow();

    qWarning() << Q_FUNC_INFO << "null group and null floating window";
    return nullptr;
}

bool TitleBar::isMDI() const
{
    auto p = view()->asWrapper();
    while (p) {
        if (p->is(Type::MDILayout))
            return true;

        if (p->is(Type::DropArea)) {
            // Note that the TitleBar can be inside a DropArea that's inside a MDIArea
            // so we need this additional check
            return false;
        }

        p = p->parentView();
    }

    return false;
}

QString TitleBar::title() const
{
    return m_title;
}

QIcon TitleBar::icon() const
{
    return m_icon;
}

bool TitleBar::onDoubleClicked()
{
    if ((Config::self().flags() & Config::Flag_DoubleClickMaximizes) && m_floatingWindow) {
        // Not using isFloating(), as that can be a dock widget nested in a floating window. By
        // convention it's floating, but it's not the title bar of the top-level window.
        toggleMaximized();
        return true;
    } else if (supportsFloatingButton()) {
        onFloatClicked();
        return true;
    }

    return false;
}

bool TitleBar::floatButtonVisible() const
{
    return m_floatButtonVisible;
}

bool TitleBar::maximizeButtonVisible() const
{
    return m_maximizeButtonVisible;
}

bool TitleBar::supportsFloatingButton() const
{
    if (Config::self().flags() & Config::Flag_TitleBarHasMaximizeButton) {
        // Apps having a maximize/restore button traditionally don't have a floating one,
        // QDockWidget style only has floating and no maximize/restore.
        // We can add an option later if we need them to co-exist
        return false;
    }

    if (Config::self().flags() & Config::Flag_TitleBarNoFloatButton) {
        // Was explicitly disabled
        return false;
    }

    if (DockWidget *dw = singleDockWidget()) {
        // Don't show the dock/undock button if the window is not dockable
        if (dw->options() & DockWidgetOption_NotDockable)
            return false;
    }

    // If we have a floating window with nested dock widgets we can't re-attach, because we don't
    // know where to
    return !m_floatingWindow || m_floatingWindow->hasSingleFrame();
}

bool TitleBar::supportsMaximizeButton() const
{
    return m_floatingWindow && m_floatingWindow->supportsMaximizeButton();
}

bool TitleBar::supportsMinimizeButton() const
{
    return m_floatingWindow && m_floatingWindow->supportsMinimizeButton();
}

bool TitleBar::supportsAutoHideButton() const
{
    // Only dock widgets docked into the MainWindow can minimize
    return m_supportsAutoHide && m_group && (m_group->isInMainWindow() || m_group->isOverlayed());
}

#ifdef DOCKS_DEVELOPER_MODE
bool TitleBar::isFloatButtonVisible() const
{
    return dynamic_cast<Views::TitleBarViewInterface *>(view())->isFloatButtonVisible();
}

bool TitleBar::isCloseButtonVisible() const
{
    return dynamic_cast<Views::TitleBarViewInterface *>(view())->isCloseButtonVisible();
}

bool TitleBar::isCloseButtonEnabled() const
{
    return dynamic_cast<Views::TitleBarViewInterface *>(view())->isCloseButtonEnabled();
}
#endif

bool TitleBar::hasIcon() const
{
    return !m_icon.isNull();
}

Controllers::Group *TitleBar::group() const
{
    return m_group;
}

Controllers::FloatingWindow *TitleBar::floatingWindow() const
{
    return m_floatingWindow;
}

void TitleBar::focusInEvent(QFocusEvent *ev)
{
    if (!m_group || !(Config::self().flags() & Config::Flag_TitleBarIsFocusable))
        return;

    // For some reason QWidget::setFocusProxy() isn't working, so forward manually
    m_group->FocusScope::focus(ev->reason());
}

void TitleBar::updateButtons()
{
    updateCloseButton();
    updateFloatButton();
    updateMaximizeButton();

    Q_EMIT minimizeButtonChanged(supportsMinimizeButton(), true);

    updateAutoHideButton();
}

void TitleBar::updateAutoHideButton()
{
    const bool visible = m_supportsAutoHide;
    const bool enabled = true;
    TitleBarButtonType type = TitleBarButtonType::AutoHide;

    if (const Controllers::Group *g = group()) {
        if (g->isOverlayed())
            type = TitleBarButtonType::UnautoHide;
    }

    Q_EMIT autoHideButtonChanged(visible, enabled, type);
}

void TitleBar::updateMaximizeButton()
{
    m_maximizeButtonVisible = false;
    m_maximizeButtonType = TitleBarButtonType::Maximize;

    if (auto fw = floatingWindow()) {
        m_maximizeButtonType =
            fw->view()->isMaximized() ? TitleBarButtonType::Normal : TitleBarButtonType::Maximize;
        m_maximizeButtonVisible = supportsMaximizeButton();
    }

    Q_EMIT maximizeButtonChanged(m_maximizeButtonVisible, /*enabled=*/true, m_maximizeButtonType);
}

void TitleBar::updateCloseButton()
{

    const bool anyNonClosable = group()
        ? group()->anyNonClosable()
        : (floatingWindow() ? floatingWindow()->anyNonClosable() : false);

    setCloseButtonEnabled(!anyNonClosable);
}

void TitleBar::toggleMaximized()
{
    if (!m_floatingWindow)
        return;

    if (m_floatingWindow->view()->isMaximized())
        m_floatingWindow->view()->showNormal();
    else
        m_floatingWindow->view()->showMaximized();
}

bool TitleBar::isOverlayed() const
{
    return m_group && m_group->isOverlayed();
}

void TitleBar::setCloseButtonEnabled(bool enabled)
{
    if (enabled != m_closeButtonEnabled) {
        m_closeButtonEnabled = enabled;
        Q_EMIT closeButtonEnabledChanged(enabled);
    }
}

void TitleBar::setFloatButtonVisible(bool visible)
{
    if (visible != m_floatButtonVisible) {
        m_floatButtonVisible = visible;
        Q_EMIT floatButtonVisibleChanged(visible);
    }
}

void TitleBar::setFloatButtonToolTip(const QString &tip)
{
    if (tip != m_floatButtonToolTip) {
        m_floatButtonToolTip = tip;
        Q_EMIT floatButtonToolTipChanged(tip);
    }
}

void TitleBar::setTitle(const QString &title)
{
    if (title != m_title) {
        m_title = title;
        view()->update();
        Q_EMIT titleChanged();
    }
}

void TitleBar::setIcon(const QIcon &icon)
{
    m_icon = icon;
    Q_EMIT iconChanged();
}

void TitleBar::onCloseClicked()
{
    const bool closeOnlyCurrentTab = Config::self().flags() & Config::Flag_CloseOnlyCurrentTab;

    if (m_group) {
        if (closeOnlyCurrentTab) {
            if (auto dw = m_group->currentDockWidget()) {
                dw->view()->close();
            } else {
                // Doesn't happen
                qWarning() << Q_FUNC_INFO << "Frame with no dock widgets";
            }
        } else {
            if (m_group->isTheOnlyFrame() && m_group->isInFloatingWindow()) {
                m_group->view()->closeRootView();
            } else {
                m_group->view()->close();
            }
        }
    } else if (m_floatingWindow) {

        if (closeOnlyCurrentTab) {
            if (Group *f = m_floatingWindow->singleFrame()) {
                if (DockWidget *dw = f->currentDockWidget()) {
                    dw->view()->close();
                } else {
                    // Doesn't happen
                    qWarning() << Q_FUNC_INFO << "Frame with no dock widgets";
                }
            } else {
                m_floatingWindow->view()->close();
            }
        } else {
            m_floatingWindow->view()->close();
        }
    }
}

void TitleBar::onFloatClicked()
{
    const DockWidget::List dockWidgets = this->dockWidgets();
    if (isFloating()) {
        // Let's dock it

        if (dockWidgets.isEmpty()) {
            qWarning() << "TitleBar::onFloatClicked: empty list. Shouldn't happen";
            return;
        }

        if (dockWidgets.size() == 1) {
            // Case 1: Single dockwidget floating
            dockWidgets[0]->setFloating(false);
        } else {
            // Case 2: Multiple dockwidgets are tabbed together and floating
            // TODO: Just reuse the whole group and put it back. The group currently doesn't
            // remember the position in the main window so use an hack for now

            if (!dockWidgets.isEmpty()) { // could be empty during destruction, maybe
                if (!dockWidgets.constFirst()->hasPreviousDockedLocation()) {
                    // Don't attempt, there's no previous docked location
                    return;
                }

                int i = 0;
                DockWidget *current = nullptr;
                for (auto dock : qAsConst(dockWidgets)) {

                    if (!current && dock->isCurrentTab())
                        current = dock;

                    dock->setFloating(true);
                    dock->dptr()->m_lastPosition->m_tabIndex = i;
                    dock->setFloating(false);
                    ++i;
                }

                // Restore the current tab
                if (current)
                    current->setAsCurrentTab();
            }
        }
    } else {
        // Let's float it
        if (dockWidgets.size() == 1) {
            // If there's a single dock widget, just call DockWidget::setFloating(true). The only
            // difference is that it has logic for using the last used geometry for the floating
            // window
            dockWidgets[0]->setFloating(true);
        } else {
            makeWindow();
        }
    }
}

void TitleBar::onMaximizeClicked()
{
    toggleMaximized();
}

void TitleBar::onMinimizeClicked()
{
    if (!m_floatingWindow)
        return;

    if (KDDockWidgets::usesUtilityWindows()) {
        // Qt::Tool windows don't appear in the task bar.
        // Unless someone tells me a good reason to allow this situation.
        return;
    }

    m_floatingWindow->view()->showMinimized();
}

void TitleBar::onAutoHideClicked()
{
    if (!m_group) {
        // Doesn't happen
        qWarning() << Q_FUNC_INFO << "Minimize not supported on floating windows";
        return;
    }

    const auto &dockwidgets = m_group->dockWidgets();
    for (DockWidget *dw : dockwidgets) {
        if (dw->isOverlayed()) {
            // restore
            MainWindow *mainWindow = dw->mainWindow();
            mainWindow->restoreFromSideBar(dw);
        } else {
            dw->moveToSideBar();
        }
    }
}

bool TitleBar::closeButtonEnabled() const
{
    return m_closeButtonEnabled;
}

std::unique_ptr<KDDockWidgets::WindowBeingDragged> TitleBar::makeWindow()
{
    if (!isVisible() && view()->rootView()->controller()->isVisible()
        && !(Config::self().flags() & Config::Flag_ShowButtonsOnTabBarIfTitleBarHidden)) {

        // When using Flag_ShowButtonsOnTabBarIfTitleBarHidden we forward the call from the tab
        // bar's buttons to the title bar's buttons, just to reuse logic

        qWarning() << "TitleBar::makeWindow shouldn't be called on invisible title bar" << this
                   << view()->rootView()->controller()->isVisible();
        if (m_group) {
            qWarning() << "this=" << this << "; actual=" << m_group->actualTitleBar();
        } else if (m_floatingWindow) {
            qWarning() << "Has floating window with titlebar=" << m_floatingWindow->titleBar()
                       << "; fw->isVisible=" << m_floatingWindow->isVisible();
        }

        Q_ASSERT(false);
        return {};
    }

    if (m_floatingWindow) {
        // We're already a floating window, no detach needed
        return std::unique_ptr<WindowBeingDragged>(new WindowBeingDragged(m_floatingWindow, this));
    }

    if (FloatingWindow *fw = floatingWindow()) { // Already floating
        if (m_group->isTheOnlyFrame()) { // We don't detach. This one drags the entire window
                                         // instead.
            qCDebug(hovering) << "TitleBar::makeWindow no detach needed";
            return std::unique_ptr<WindowBeingDragged>(new WindowBeingDragged(fw, this));
        }
    }

    QRect r = m_group->view()->geometry();
    r.moveTopLeft(m_group->mapToGlobal(QPoint(0, 0)));

    auto floatingWindow = new Controllers::FloatingWindow(m_group, {});
    floatingWindow->setSuggestedGeometry(r, SuggestedGeometryHint_GeometryIsFromDocked);
    floatingWindow->view()->show();

    auto draggable = KDDockWidgets::usesNativeTitleBar() ? static_cast<Draggable *>(floatingWindow)
                                                         : static_cast<Draggable *>(this);
    return std::unique_ptr<WindowBeingDragged>(new WindowBeingDragged(floatingWindow, draggable));
}

bool TitleBar::isWindow() const
{
    return m_floatingWindow != nullptr;
}

Controllers::DockWidget::List TitleBar::dockWidgets() const
{
    if (m_floatingWindow) {
        DockWidget::List result;
        for (Group *group : m_floatingWindow->groups()) {
            result << group->dockWidgets();
        }
        return result;
    }

    if (m_group)
        return m_group->dockWidgets();

    qWarning() << "TitleBar::dockWidget: shouldn't happen";
    return {};
}

Controllers::DockWidget *TitleBar::singleDockWidget() const
{
    const DockWidget::List dockWidgets = this->dockWidgets();
    return dockWidgets.isEmpty() ? nullptr : dockWidgets.first();
}

bool TitleBar::isFloating() const
{
    if (m_floatingWindow)
        return true;

    if (m_group)
        return m_group->isFloating();

    qWarning() << "TitleBar::isFloating: shouldn't happen";
    return false;
}

bool TitleBar::isFocused() const
{
    if (m_group)
        return m_group->isFocused();
    else if (m_floatingWindow)
        return m_floatingWindow->view()->isActiveWindow();

    return false;
}

void TitleBar::updateFloatButton()
{
    setFloatButtonToolTip(floatingWindow() ? tr("Dock window") : tr("Undock window"));
    setFloatButtonVisible(supportsFloatingButton());
}

QString TitleBar::floatButtonToolTip() const
{
    return m_floatButtonToolTip;
}

TabBar *TitleBar::tabBar() const
{
    if (m_floatingWindow && m_floatingWindow->hasSingleFrame()) {
        if (Group *group = m_floatingWindow->singleFrame()) {
            return group->stack()->tabBar();
        } else {
            // Shouldn't happen
            qWarning() << Q_FUNC_INFO << "Expected a group";
        }

    } else if (m_group) {
        return m_group->stack()->tabBar();
    }

    return nullptr;
}

TitleBarButtonType TitleBar::maximizeButtonType() const
{
    return m_maximizeButtonType;
}
