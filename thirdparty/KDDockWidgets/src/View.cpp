/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2020-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/

#include "View.h"
#include "private/View_p.h"
#include "private/multisplitter/Item_p.h"

#include "controllers/FloatingWindow.h"
#include "controllers/Group.h"
#include "controllers/Stack.h"
#include "controllers/TitleBar.h"
#include "controllers/TabBar.h"
#include "controllers/MainWindow.h"
#include "controllers/DropArea.h"
#include "controllers/MDILayout.h"

#include "Platform.h"
#include "Window.h"

using namespace KDDockWidgets;

namespace KDDockWidgets {
static qint64 s_nextId = 1;

Controller *maybeCreateController(Controller *controller, Type type, View *view)
{
    if (controller)
        return controller;

    if (type == Type::ViewWrapper)
        return new Controller(Type::ViewWrapper, view);

    return new Controller(Type::None, view);
}

}

View::View(Controller *controller, Type type)
    : d(new Private())
    , m_controller(maybeCreateController(controller, type, this))
    , m_id(QString::number(KDDockWidgets::s_nextId++))
    , m_type(type)
{
}

View::~View()
{
    m_inDtor = true;
    d->beingDestroyed.emit();

    if (!freed() && !is(Type::ViewWrapper)) {
        // TODOm3
        // Views should be deleted via View::free()!
        // However some of our deletes are coming from widgets parent destroying their children
        // But we want the controllers to drive things instead. For now detect the view destruction
        // and destroy its controller, which was the old behaviour.
        delete m_controller;
    }

    delete d;
}

QString View::id() const
{
    return m_id;
}

Type View::type() const
{
    return m_type;
}

void View::free()
{
    if (m_freed) {
        qWarning() << Q_FUNC_INFO << "Free already called";
        return;
    }

    m_freed = true;
    free_impl();
}

bool View::freed() const
{
    return m_freed;
}

bool View::inDtor() const
{
    return m_inDtor;
}

void View::free_impl()
{
    delete this;
}

QSize View::sizeHint() const
{
    return {};
}

QSize View::size() const
{
    return geometry().size();
}

QPoint View::pos() const
{
    return geometry().topLeft();
}

QRect View::rect() const
{
    return QRect(QPoint(0, 0), size());
}

int View::x() const
{
    return geometry().x();
}

int View::y() const
{
    return geometry().y();
}

int View::height() const
{
    return geometry().height();
}

int View::width() const
{
    return geometry().width();
}

void View::move(QPoint pt)
{
    move(pt.x(), pt.y());
}

void View::resize(QSize sz)
{
    setSize(sz.width(), sz.height());
}

void View::setSize(QSize sz)
{
    setSize(sz.width(), sz.height());
}

void View::resize(int w, int h)
{
    setSize(w, h);
}

QSize View::boundedMaxSize(QSize min, QSize max)
{
    // Max should be bigger than min, but not bigger than the hardcoded max
    max = max.boundedTo(Layouting::Item::hardcodedMaximumSize);

    // 0 interpreted as not having max
    if (max.width() <= 0)
        max.setWidth(Layouting::Item::hardcodedMaximumSize.width());
    if (max.height() <= 0)
        max.setHeight(Layouting::Item::hardcodedMaximumSize.height());

    max = max.expandedTo(min);

    return max;
}

Controller *View::controller() const
{
    return m_controller;
}

/** static */
QSize View::hardcodedMinimumSize()
{
    return Layouting::Item::hardcodedMinimumSize;
}

bool View::is(Type t) const
{
    return int(m_type) & int(t);
}

Controllers::FloatingWindow *View::asFloatingWindowController() const
{
    if (m_controller && m_controller->is(Type::FloatingWindow))
        return qobject_cast<Controllers::FloatingWindow *>(m_controller);

    return nullptr;
}

Controllers::Group *View::asGroupController() const
{
    if (m_controller && m_controller->is(Type::Frame))
        return qobject_cast<Controllers::Group *>(m_controller);

    return nullptr;
}

Controllers::TitleBar *View::asTitleBarController() const
{
    if (m_controller && m_controller->is(Type::TitleBar))
        return qobject_cast<Controllers::TitleBar *>(m_controller);

    return nullptr;
}

Controllers::TabBar *View::asTabBarController() const
{
    if (m_controller && m_controller->is(Type::TabBar))
        return qobject_cast<Controllers::TabBar *>(m_controller);

    return nullptr;
}

Controllers::Stack *View::asStackController() const
{
    if (m_controller && m_controller->is(Type::Stack))
        return qobject_cast<Controllers::Stack *>(m_controller);

    return nullptr;
}

Controllers::DockWidget *View::asDockWidgetController() const
{
    if (m_controller && m_controller->is(Type::DockWidget))
        return qobject_cast<Controllers::DockWidget *>(m_controller);

    return nullptr;
}

Controllers::MainWindow *View::asMainWindowController() const
{
    if (m_controller && m_controller->is(Type::MainWindow))
        return qobject_cast<Controllers::MainWindow *>(m_controller);

    return nullptr;
}

Controllers::DropArea *View::asDropAreaController() const
{
    if (!m_inDtor && m_controller && m_controller->is(Type::DropArea)) {
        return qobject_cast<Controllers::DropArea *>(m_controller);
    }
    return nullptr;
}

Controllers::MDILayout *View::asMDILayoutController() const
{
    if (!m_inDtor && m_controller && m_controller->is(Type::MDILayout))
        return qobject_cast<Controllers::MDILayout *>(m_controller);

    return nullptr;
}

Controllers::Layout *View::asLayout() const
{
    if (Controllers::DropArea *da = asDropAreaController()) {
        return da;
    } else if (Controllers::MDILayout *mdi = asMDILayoutController()) {
        return mdi;
    }

    return nullptr;
}

bool View::equals(const View *other) const
{
    return other && handle() == other->handle();
}

bool View::equals(const std::shared_ptr<View> &other) const
{
    if (isNull() || !other || other->isNull()) {
        // We don't care about nullity for identity
        return false;
    }

    return handle() == other->handle();
}

bool View::isNull() const
{
    return false;
}

bool View::isInWindow(std::shared_ptr<Window> window) const
{
    if (!window)
        return false;

    if (auto ourWindow = this->window())
        return ourWindow->equals(window);

    return false;
}

QSize View::parentSize() const
{
    if (auto p = parentView())
        return p->size();
    return {};
}

QRect View::windowGeometry() const
{
    if (Window::Ptr window = this->window())
        return window->geometry();

    return {};
}

void View::closeRootView()
{
    if (auto view = rootView())
        view->close();
}

Screen::Ptr View::screen() const
{
    if (Window::Ptr window = this->window())
        return window->screen();

    return nullptr;
}

void View::setAboutToBeDestroyed()
{
    m_aboutToBeDestroyed = true;
}

bool View::aboutToBeDestroyed() const
{
    return m_aboutToBeDestroyed;
}


/** static */
Controller *View::firstParentOfType(View *view, KDDockWidgets::Type type)
{
    auto p = view->asWrapper();
    while (p) {
        if (p->is(type))
            return p->controller();

        // Ignore QObject hierarchies spanning though multiple windows
        if (p->isRootView())
            return nullptr;

        p = p->parentView();
    }

    return nullptr;
}

Controller *View::firstParentOfType(KDDockWidgets::Type type) const
{
    return View::firstParentOfType(const_cast<View *>(this), type);
}

QRect View::globalGeometry() const
{
    QRect geo = geometry();
    if (!isRootView())
        geo.moveTopLeft(mapToGlobal(QPoint(0, 0)));
    return geo;
}

void View::createPlatformWindow()
{
    // Only qtwidgets need this
    qFatal("Shouldn't be called on this platform");
}

std::shared_ptr<Window> View::transientWindow() const
{
    if (auto w = window())
        return w->transientParent();

    return {};
}

bool View::onResize(int w, int h)
{
    d->resized.emit(QSize(w, h));
    return false;
}

bool View::onResize(QSize sz)
{
    return onResize(sz.width(), sz.height());
}

/** static */
bool View::equals(const View *one, const View *two)
{
    if ((one && !two) || (!one && two))
        return false;

    if (!one && !two)
        return true;

    return one->equals(two);
}

void View::installViewEventFilter(EventFilterInterface *filter)
{
    d->m_viewEventFilters.push_back(filter);
}

void View::removeViewEventFilter(EventFilterInterface *filter)
{
    d->m_viewEventFilters.erase(
        std::remove(d->m_viewEventFilters.begin(), d->m_viewEventFilters.end(), filter),
        d->m_viewEventFilters.end());
}
