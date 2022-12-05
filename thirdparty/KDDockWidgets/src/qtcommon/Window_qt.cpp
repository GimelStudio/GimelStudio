/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/


#include "kddockwidgets/Screen_qt.h"
#include "kddockwidgets/Window_qt.h"
#include "kddockwidgets/Platform_qt.h"

#include <QWindow>
#include <QScreen>
#include <QVariant>

#include <QtGui/private/qhighdpiscaling_p.h>

using namespace KDDockWidgets;

Window_qt::Window_qt(QWindow *window)
    : m_window(window)
{
    Q_ASSERT(window);
}

Window_qt::~Window_qt()
{
}

void Window_qt::onScreenChanged(QObject *context, WindowScreenChangedCallback callback)
{
    // Window_qt can't have a "screenChanged" signal since it's a short-lived object which
    // just wraps QWindow API. Instead, connects need to be done directly to QWindow
    QWindow *window = m_window; // copy before "this" is deleted
    context = context ? context : m_window;
    QObject::connect(m_window, &QWindow::screenChanged, context, [context, window, callback] {
        callback(context, Platform_qt::instance()->windowFromQWindow(window));
    });
}

void Window_qt::setWindowState(WindowState state)
{
    m_window->setWindowState(( Qt::WindowState )state);
}

WindowState Window_qt::windowState() const
{
    return WindowState(m_window->windowState());
}

QRect Window_qt::geometry() const
{
    return m_window->geometry();
}

void Window_qt::setProperty(const char *name, const QVariant &value)
{
    Q_ASSERT(m_window);
    m_window->setProperty(name, value);
}

bool Window_qt::isVisible() const
{
    return m_window->isVisible();
}

WId Window_qt::handle() const
{
    if (m_window->handle())
        return m_window->winId();
    return 0;
}

QWindow *Window_qt::qtWindow() const
{
    return m_window;
}

bool Window_qt::equals(std::shared_ptr<Window> other) const
{
    auto otherQt = static_cast<Window_qt *>(other.get());
    return other && otherQt->m_window == m_window;
}

void Window_qt::setFramePosition(QPoint targetPos)
{
    m_window->setFramePosition(targetPos);
}

QRect Window_qt::frameGeometry() const
{
    return m_window->frameGeometry();
}

void Window_qt::resize(int width, int height)
{
    m_window->resize(width, height);
}

bool Window_qt::isActive() const
{
    return m_window->isActive();
}

QPoint Window_qt::mapFromGlobal(QPoint globalPos) const
{
    return m_window->mapFromGlobal(globalPos);
}

QPoint Window_qt::mapToGlobal(QPoint localPos) const
{
    return m_window->mapToGlobal(localPos);
}

Screen::Ptr Window_qt::screen() const
{
    return std::make_shared<Screen_qt>(m_window->screen());
}

void Window_qt::destroy()
{
    delete m_window;
}

QVariant Window_qt::property(const char *name) const
{
    return m_window->property(name);
}

QSize Window_qt::minSize() const
{
    return m_window->minimumSize();
}

QSize Window_qt::maxSize() const
{
    return m_window->maximumSize();
}

QPoint Window_qt::fromNativePixels(QPoint nativePos) const
{
    return QHighDpi::fromNativePixels(nativePos, m_window.data());
}

void Window_qt::startSystemMove()
{
    m_window->startSystemMove();
}

void Window_qt::setGeometry(QRect geo) const
{
    m_window->setGeometry(geo);
}

void Window_qt::setVisible(bool is)
{
    m_window->setVisible(is);
}

bool Window_qt::isFullScreen() const
{
    return m_window->windowStates() & Qt::WindowFullScreen;
}
