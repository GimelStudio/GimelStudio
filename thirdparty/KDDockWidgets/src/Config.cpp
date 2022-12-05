/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

/**
 * @file
 * @brief Application wide config to tune certain beahviours of the framework.
 *
 * @author Sérgio Martins \<sergio.martins@kdab.com\>
 */

#include "Config.h"
#include "Platform.h"
#include "View.h"
#include "private/multisplitter/Item_p.h"
#include "DockRegistry.h"
#include "private/Utils_p.h"
#include "private/DragController_p.h"
#include "kddockwidgets/ViewFactory.h"
#include "controllers/Separator.h"

#include <QDebug>
#include <QOperatingSystemVersion>

namespace KDDockWidgets {

class Config::Private
{
public:
    Private()
        : m_viewFactory(Platform::instance()->createDefaultViewFactory())
    {
    }

    ~Private()
    {
        delete m_viewFactory;
    }

    void fixFlags();

    DockWidgetFactoryFunc m_dockWidgetFactoryFunc = nullptr;
    MainWindowFactoryFunc m_mainWindowFactoryFunc = nullptr;
    TabbingAllowedFunc m_tabbingAllowedFunc = nullptr;
    DropIndicatorAllowedFunc m_dropIndicatorAllowedFunc = nullptr;
    ViewFactory *m_viewFactory = nullptr;
    Flags m_flags = Flag_Default;
    InternalFlags m_internalFlags = InternalFlag_None;
    CustomizableWidgets m_disabledPaintEvents = CustomizableWidget_None;
    qreal m_draggedWindowOpacity = Q_QNAN;
    int m_mdiPopupThreshold = 250;
    int m_startDragDistance = -1;
    bool m_dropIndicatorsInhibited = false;
};

Config::Config()
    : d(new Private())
{
    d->fixFlags();
}

Config &Config::self()
{
    static Config config;
    return config;
}

Config::~Config()
{
    delete d;
}

Config::Flags Config::flags() const
{
    return d->m_flags;
}

void Config::setFlags(Flags f)
{
    auto dr = DockRegistry::self();
    if (!dr->isEmpty(/*excludeBeingDeleted=*/true)) {
        qWarning()
            << Q_FUNC_INFO
            << "Only use this function at startup before creating any DockWidget or MainWindow"
            << "; These are already created: " << dr->mainWindowsNames() << dr->dockWidgetNames()
            << dr->floatingWindows();
        return;
    }

    d->m_flags = f;
    d->fixFlags();
}

void Config::setDockWidgetFactoryFunc(DockWidgetFactoryFunc func)
{
    d->m_dockWidgetFactoryFunc = func;
}

DockWidgetFactoryFunc Config::dockWidgetFactoryFunc() const
{
    return d->m_dockWidgetFactoryFunc;
}

void Config::setMainWindowFactoryFunc(MainWindowFactoryFunc func)
{
    d->m_mainWindowFactoryFunc = func;
}

MainWindowFactoryFunc Config::mainWindowFactoryFunc() const
{
    return d->m_mainWindowFactoryFunc;
}

void Config::setViewFactory(ViewFactory *wf)
{
    Q_ASSERT(wf);
    delete d->m_viewFactory;
    d->m_viewFactory = wf;
}

ViewFactory *Config::viewFactory() const
{
    return d->m_viewFactory;
}

int Config::separatorThickness() const
{
    return Layouting::Item::separatorThickness;
}

void Config::setSeparatorThickness(int value)
{
    if (!DockRegistry::self()->isEmpty(/*excludeBeingDeleted=*/true)) {
        qWarning()
            << Q_FUNC_INFO
            << "Only use this function at startup before creating any DockWidget or MainWindow";
        return;
    }

    if (value < 0 || value >= 100) {
        qWarning() << Q_FUNC_INFO << "Invalid value" << value;
        return;
    }

    Layouting::Item::separatorThickness = value;
}

void Config::setDraggedWindowOpacity(qreal opacity)
{
    d->m_draggedWindowOpacity = opacity;
}

qreal Config::draggedWindowOpacity() const
{
    return d->m_draggedWindowOpacity;
}

void Config::setTabbingAllowedFunc(TabbingAllowedFunc func)
{
    d->m_tabbingAllowedFunc = func;
}

TabbingAllowedFunc Config::tabbingAllowedFunc() const
{
    return d->m_tabbingAllowedFunc;
}

void Config::setDropIndicatorAllowedFunc(DropIndicatorAllowedFunc func)
{
    d->m_dropIndicatorAllowedFunc = func;
}

DropIndicatorAllowedFunc Config::dropIndicatorAllowedFunc() const
{
    return d->m_dropIndicatorAllowedFunc;
}

void Config::setAbsoluteWidgetMinSize(QSize size)
{
    if (!DockRegistry::self()->isEmpty(/*excludeBeingDeleted=*/false)) {
        qWarning()
            << Q_FUNC_INFO
            << "Only use this function at startup before creating any DockWidget or MainWindow";
        return;
    }

    Layouting::Item::hardcodedMinimumSize = size;
}

QSize Config::absoluteWidgetMinSize() const
{
    return Layouting::Item::hardcodedMinimumSize;
}

void Config::setAbsoluteWidgetMaxSize(QSize size)
{
    if (!DockRegistry::self()->isEmpty(/*excludeBeingDeleted=*/false)) {
        qWarning()
            << Q_FUNC_INFO
            << "Only use this function at startup before creating any DockWidget or MainWindow";
        return;
    }

    Layouting::Item::hardcodedMaximumSize = size;
}

QSize Config::absoluteWidgetMaxSize() const
{
    return Layouting::Item::hardcodedMaximumSize;
}

Config::InternalFlags Config::internalFlags() const
{
    return d->m_internalFlags;
}

void Config::setInternalFlags(InternalFlags flags)
{
    d->m_internalFlags = flags;
}

void Config::Private::fixFlags()
{
#if defined(Q_OS_WIN)
    if (QOperatingSystemVersion::current().majorVersion() < 10) {
        // Aero-snap requires Windows 10
        m_flags = m_flags & ~Flag_AeroSnapWithClientDecos;
    } else {
        // Unconditional now
        m_flags |= Flag_AeroSnapWithClientDecos;
    }

    // These are mutually exclusive:
    if ((m_flags & Flag_AeroSnapWithClientDecos) && (m_flags & Flag_NativeTitleBar)) {
        // We're either using native or client decorations, let's use native.
        m_flags = m_flags & ~Flag_AeroSnapWithClientDecos;
    }
#elif defined(Q_OS_MACOS)
    // Not supported on macOS:
    m_flags = m_flags & ~Flag_AeroSnapWithClientDecos;
#else
    if (KDDockWidgets::isWayland()) {
        // Native title bar is forced on Wayland. Needed for moving the window.
        // The inner KDDW title bar is used for DnD.
        m_flags |= Flag_NativeTitleBar;
    } else {
        // Not supported on linux/X11
        // On Linux, dragging the title bar of a window doesn't generate NonClientMouseEvents
        // at least with KWin anyway. We can make this more granular and allow it for other
        // X11 window managers
        m_flags = m_flags & ~Flag_NativeTitleBar;
        m_flags = m_flags & ~Flag_AeroSnapWithClientDecos;
    }
#endif

#if (!defined(Q_OS_WIN) && !defined(Q_OS_MACOS))
    // QtQuick doesn't support AeroSnap yet. Some problem with the native events not being
    // received...
    m_flags = m_flags & ~Flag_AeroSnapWithClientDecos;
#endif


#if defined(DOCKS_DEVELOPER_MODE)
    // We allow to disable aero-snap during development
    if (m_internalFlags & InternalFlag_NoAeroSnap) {
        // The only way to disable AeroSnap
        m_flags = m_flags & ~Flag_AeroSnapWithClientDecos;
    }
#endif

    if (m_flags & Flag_DontUseUtilityFloatingWindows) {
        m_internalFlags |= InternalFlag_DontUseParentForFloatingWindows;
        m_internalFlags |= InternalFlag_DontUseQtToolWindowsForFloatingWindows;
    }

    if (m_flags & Flag_ShowButtonsOnTabBarIfTitleBarHidden) {
        // Flag_ShowButtonsOnTabBarIfTitleBarHidden doesn't make sense if used alone
        m_flags |= Flag_HideTitleBarWhenTabsVisible;
    }
}

void Config::setDisabledPaintEvents(CustomizableWidgets widgets)
{
    d->m_disabledPaintEvents = widgets;
}

Config::CustomizableWidgets Config::disabledPaintEvents() const
{
    return d->m_disabledPaintEvents;
}

void Config::setMDIPopupThreshold(int threshold)
{
    d->m_mdiPopupThreshold = threshold;
}

int Config::mdiPopupThreshold() const
{
    return d->m_mdiPopupThreshold;
}

void Config::setDropIndicatorsInhibited(bool inhibit) const
{
    if (d->m_dropIndicatorsInhibited != inhibit) {
        d->m_dropIndicatorsInhibited = inhibit;
        Q_EMIT DockRegistry::self()->dropIndicatorsInhibitedChanged(inhibit);
    }
}

bool Config::dropIndicatorsInhibited() const
{
    return d->m_dropIndicatorsInhibited;
}

void Config::setStartDragDistance(int pixels)
{
    d->m_startDragDistance = pixels;
}

int Config::startDragDistance() const
{
    return d->m_startDragDistance;
}

}
