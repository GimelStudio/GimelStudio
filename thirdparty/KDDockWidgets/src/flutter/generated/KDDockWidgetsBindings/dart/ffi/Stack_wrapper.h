/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/
#include "KDDockWidgetsBindings_exports.h"
#include <Stack.h>
#include <qstring.h>
#include <DockWidget.h>
#include <TabBar.h>
#include <Group.h>
#include <qpoint.h>
#include <qobject.h>
#include <qcoreevent.h>
#include <qrect.h>
#include <qsize.h>
#include <View.h>

namespace KDDockWidgetsBindings_wrappersNS {
class Stack_wrapper : public ::KDDockWidgets::Controllers::Stack
{
public:
    ~Stack_wrapper();
    void addDockWidget(KDDockWidgets::Controllers::DockWidget *arg__1);
    bool contains(KDDockWidgets::Controllers::DockWidget *dw) const;
    virtual void customEvent(QEvent *event);
    virtual void customEvent_nocallback(QEvent *event);
    virtual bool event(QEvent *event);
    virtual bool event_nocallback(QEvent *event);
    virtual bool eventFilter(QObject *watched, QEvent *event);
    virtual bool eventFilter_nocallback(QObject *watched, QEvent *event);
    KDDockWidgets::Controllers::Group *group() const;
    bool insertDockWidget(KDDockWidgets::Controllers::DockWidget *dockwidget, int index);
    virtual bool isMDI() const;
    virtual bool isMDI_nocallback() const;
    virtual bool isPositionDraggable(QPoint p) const;
    virtual bool isPositionDraggable_nocallback(QPoint p) const;
    virtual bool isWindow() const;
    virtual bool isWindow_nocallback() const;
    int numDockWidgets() const;
    bool onMouseDoubleClick(QPoint localPos);
    void setDocumentMode(bool arg__1);
    virtual void setParentView_impl(KDDockWidgets::View *parent);
    virtual void setParentView_impl_nocallback(KDDockWidgets::View *parent);
    void setTabBarAutoHide(bool arg__1);
    virtual KDDockWidgets::Controllers::DockWidget *singleDockWidget() const;
    virtual KDDockWidgets::Controllers::DockWidget *singleDockWidget_nocallback() const;
    KDDockWidgets::Controllers::TabBar *tabBar() const;
    bool tabBarAutoHide() const;
    static QString tr(const char *s, const char *c, int n);
    typedef void (*Callback_customEvent)(void *, QEvent *event);
    Callback_customEvent m_customEventCallback = nullptr;
    typedef bool (*Callback_event)(void *, QEvent *event);
    Callback_event m_eventCallback = nullptr;
    typedef bool (*Callback_eventFilter)(void *, QObject *watched, QEvent *event);
    Callback_eventFilter m_eventFilterCallback = nullptr;
    typedef bool (*Callback_isMDI)(void *);
    Callback_isMDI m_isMDICallback = nullptr;
    typedef bool (*Callback_isPositionDraggable)(void *, QPoint *p);
    Callback_isPositionDraggable m_isPositionDraggableCallback = nullptr;
    typedef bool (*Callback_isWindow)(void *);
    Callback_isWindow m_isWindowCallback = nullptr;
    typedef void (*Callback_setParentView_impl)(void *, KDDockWidgets::View *parent);
    Callback_setParentView_impl m_setParentView_implCallback = nullptr;
    typedef KDDockWidgets::Controllers::DockWidget *(*Callback_singleDockWidget)(void *);
    Callback_singleDockWidget m_singleDockWidgetCallback = nullptr;
};
}
extern "C" {
// KDDockWidgets::Controllers::Stack::addDockWidget(KDDockWidgets::Controllers::DockWidget * arg__1)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Stack__addDockWidget_DockWidget(void *thisObj, void *arg__1_);
// KDDockWidgets::Controllers::Stack::contains(KDDockWidgets::Controllers::DockWidget * dw) const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Stack__contains_DockWidget(void *thisObj, void *dw_);
// KDDockWidgets::Controllers::Stack::customEvent(QEvent * event)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Stack__customEvent_QEvent(void *thisObj, void *event_);
// KDDockWidgets::Controllers::Stack::event(QEvent * event)
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Stack__event_QEvent(void *thisObj,
                                                                                    void *event_);
// KDDockWidgets::Controllers::Stack::eventFilter(QObject * watched, QEvent * event)
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Stack__eventFilter_QObject_QEvent(void *thisObj, void *watched_,
                                                                void *event_);
// KDDockWidgets::Controllers::Stack::group() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Stack__group(void *thisObj);
// KDDockWidgets::Controllers::Stack::insertDockWidget(KDDockWidgets::Controllers::DockWidget *
// dockwidget, int index)
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Stack__insertDockWidget_DockWidget_int(void *thisObj,
                                                                     void *dockwidget_, int index);
// KDDockWidgets::Controllers::Stack::isMDI() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Stack__isMDI(void *thisObj);
// KDDockWidgets::Controllers::Stack::isPositionDraggable(QPoint p) const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Stack__isPositionDraggable_QPoint(void *thisObj, void *p_);
// KDDockWidgets::Controllers::Stack::isWindow() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Stack__isWindow(void *thisObj);
// KDDockWidgets::Controllers::Stack::numDockWidgets() const
KDDockWidgetsBindings_EXPORT int c_KDDockWidgets__Controllers__Stack__numDockWidgets(void *thisObj);
// KDDockWidgets::Controllers::Stack::onMouseDoubleClick(QPoint localPos)
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Stack__onMouseDoubleClick_QPoint(void *thisObj, void *localPos_);
// KDDockWidgets::Controllers::Stack::setDocumentMode(bool arg__1)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Stack__setDocumentMode_bool(void *thisObj, bool arg__1);
// KDDockWidgets::Controllers::Stack::setParentView_impl(KDDockWidgets::View * parent)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Stack__setParentView_impl_View(void *thisObj, void *parent_);
// KDDockWidgets::Controllers::Stack::setTabBarAutoHide(bool arg__1)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Stack__setTabBarAutoHide_bool(void *thisObj, bool arg__1);
// KDDockWidgets::Controllers::Stack::singleDockWidget() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Stack__singleDockWidget(void *thisObj);
// KDDockWidgets::Controllers::Stack::tabBar() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Stack__tabBar(void *thisObj);
// KDDockWidgets::Controllers::Stack::tabBarAutoHide() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Stack__tabBarAutoHide(void *thisObj);
// KDDockWidgets::Controllers::Stack::tr(const char * s, const char * c, int n)
KDDockWidgetsBindings_EXPORT void *
c_static_KDDockWidgets__Controllers__Stack__tr_char_char_int(const char *s, const char *c, int n);
KDDockWidgetsBindings_EXPORT void c_KDDockWidgets__Controllers__Stack__destructor(void *thisObj);
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Stack__registerVirtualMethodCallback(void *ptr, void *callback,
                                                                   int methodId);
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Stack_Finalizer(void *, void *cppObj, void *);
}
