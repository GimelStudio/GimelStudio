/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/
#include "DropArea_wrapper.h"


#include <QDebug>


namespace Dartagnan {

typedef int (*CleanupCallback)(void *thisPtr);
static CleanupCallback s_cleanupCallback = nullptr;

template<typename T>
struct ValueWrapper
{
    T value;
};

}
namespace KDDockWidgetsBindings_wrappersNS {
DropArea_wrapper::DropArea_wrapper(KDDockWidgets::View *parent,
                                   QFlags<KDDockWidgets::MainWindowOption> options,
                                   bool isMDIWrapper)
    : ::KDDockWidgets::Controllers::DropArea(parent, options, isMDIWrapper)
{
}
void DropArea_wrapper::addDockWidget(KDDockWidgets::Controllers::DockWidget *dw,
                                     KDDockWidgets::Location location,
                                     KDDockWidgets::Controllers::DockWidget *relativeTo,
                                     KDDockWidgets::InitialOption initialOption)
{
    ::KDDockWidgets::Controllers::DropArea::addDockWidget(dw, location, relativeTo, initialOption);
}
void DropArea_wrapper::addMultiSplitter(KDDockWidgets::Controllers::DropArea *splitter,
                                        KDDockWidgets::Location location,
                                        KDDockWidgets::Controllers::Group *relativeTo,
                                        KDDockWidgets::InitialOption option)
{
    ::KDDockWidgets::Controllers::DropArea::addMultiSplitter(splitter, location, relativeTo,
                                                             option);
}
void DropArea_wrapper::addWidget(KDDockWidgets::View *widget, KDDockWidgets::Location location,
                                 KDDockWidgets::Controllers::Group *relativeTo,
                                 KDDockWidgets::InitialOption option)
{
    ::KDDockWidgets::Controllers::DropArea::addWidget(widget, location, relativeTo, option);
}
Layouting::Item *DropArea_wrapper::centralFrame() const
{
    return ::KDDockWidgets::Controllers::DropArea::centralFrame();
}
bool DropArea_wrapper::containsDockWidget(KDDockWidgets::Controllers::DockWidget *arg__1) const
{
    return ::KDDockWidgets::Controllers::DropArea::containsDockWidget(arg__1);
}
KDDockWidgets::Controllers::Group *
DropArea_wrapper::createCentralFrame(QFlags<KDDockWidgets::MainWindowOption> options)
{
    return ::KDDockWidgets::Controllers::DropArea::createCentralFrame(options);
}
void DropArea_wrapper::customEvent(QEvent *event)
{
    if (m_customEventCallback) {
        const void *thisPtr = this;
        m_customEventCallback(const_cast<void *>(thisPtr), event);
    } else {
        ::KDDockWidgets::Controllers::DropArea::customEvent(event);
    }
}
void DropArea_wrapper::customEvent_nocallback(QEvent *event)
{
    ::KDDockWidgets::Controllers::DropArea::customEvent(event);
}
KDDockWidgets::Controllers::DropIndicatorOverlay *DropArea_wrapper::dropIndicatorOverlay() const
{
    return ::KDDockWidgets::Controllers::DropArea::dropIndicatorOverlay();
}
bool DropArea_wrapper::event(QEvent *event)
{
    if (m_eventCallback) {
        const void *thisPtr = this;
        return m_eventCallback(const_cast<void *>(thisPtr), event);
    } else {
        return ::KDDockWidgets::Controllers::DropArea::event(event);
    }
}
bool DropArea_wrapper::event_nocallback(QEvent *event)
{
    return ::KDDockWidgets::Controllers::DropArea::event(event);
}
bool DropArea_wrapper::eventFilter(QObject *watched, QEvent *event)
{
    if (m_eventFilterCallback) {
        const void *thisPtr = this;
        return m_eventFilterCallback(const_cast<void *>(thisPtr), watched, event);
    } else {
        return ::KDDockWidgets::Controllers::DropArea::eventFilter(watched, event);
    }
}
bool DropArea_wrapper::eventFilter_nocallback(QObject *watched, QEvent *event)
{
    return ::KDDockWidgets::Controllers::DropArea::eventFilter(watched, event);
}
QList<KDDockWidgets::Controllers::Group *> DropArea_wrapper::groups() const
{
    return ::KDDockWidgets::Controllers::DropArea::groups();
}
bool DropArea_wrapper::hasSingleFloatingFrame() const
{
    return ::KDDockWidgets::Controllers::DropArea::hasSingleFloatingFrame();
}
bool DropArea_wrapper::hasSingleFrame() const
{
    return ::KDDockWidgets::Controllers::DropArea::hasSingleFrame();
}
bool DropArea_wrapper::isMDIWrapper() const
{
    return ::KDDockWidgets::Controllers::DropArea::isMDIWrapper();
}
void DropArea_wrapper::layoutEqually()
{
    ::KDDockWidgets::Controllers::DropArea::layoutEqually();
}
void DropArea_wrapper::layoutParentContainerEqually(KDDockWidgets::Controllers::DockWidget *arg__1)
{
    ::KDDockWidgets::Controllers::DropArea::layoutParentContainerEqually(arg__1);
}
KDDockWidgets::Controllers::DockWidget *DropArea_wrapper::mdiDockWidgetWrapper() const
{
    return ::KDDockWidgets::Controllers::DropArea::mdiDockWidgetWrapper();
}
void DropArea_wrapper::removeHover()
{
    ::KDDockWidgets::Controllers::DropArea::removeHover();
}
void DropArea_wrapper::setParentView_impl(KDDockWidgets::View *parent)
{
    if (m_setParentView_implCallback) {
        const void *thisPtr = this;
        m_setParentView_implCallback(const_cast<void *>(thisPtr), parent);
    } else {
        ::KDDockWidgets::Controllers::DropArea::setParentView_impl(parent);
    }
}
void DropArea_wrapper::setParentView_impl_nocallback(KDDockWidgets::View *parent)
{
    ::KDDockWidgets::Controllers::DropArea::setParentView_impl(parent);
}
QString DropArea_wrapper::tr(const char *s, const char *c, int n)
{
    return ::KDDockWidgets::Controllers::DropArea::tr(s, c, n);
}
DropArea_wrapper::~DropArea_wrapper()
{
}

}
static KDDockWidgets::Controllers::DropArea *fromPtr(void *ptr)
{
    return reinterpret_cast<KDDockWidgets::Controllers::DropArea *>(ptr);
}
static KDDockWidgetsBindings_wrappersNS::DropArea_wrapper *fromWrapperPtr(void *ptr)
{
    return reinterpret_cast<KDDockWidgetsBindings_wrappersNS::DropArea_wrapper *>(ptr);
}
extern "C" {
void c_KDDockWidgets__Controllers__DropArea_Finalizer(void *, void *cppObj, void *)
{
    delete reinterpret_cast<KDDockWidgetsBindings_wrappersNS::DropArea_wrapper *>(cppObj);
}
void *c_KDDockWidgets__Controllers__DropArea__constructor_View_MainWindowOptions_bool(
    void *parent_, int options_, bool isMDIWrapper)
{
    auto parent = reinterpret_cast<KDDockWidgets::View *>(parent_);
    auto options = static_cast<QFlags<KDDockWidgets::MainWindowOption>>(options_);
    auto ptr =
        new KDDockWidgetsBindings_wrappersNS::DropArea_wrapper(parent, options, isMDIWrapper);
    return reinterpret_cast<void *>(ptr);
}
// addDockWidget(KDDockWidgets::Controllers::DockWidget * dw, KDDockWidgets::Location location,
// KDDockWidgets::Controllers::DockWidget * relativeTo, KDDockWidgets::InitialOption initialOption)
void c_KDDockWidgets__Controllers__DropArea__addDockWidget_DockWidget_Location_DockWidget_InitialOption(
    void *thisObj, void *dw_, int location, void *relativeTo_, void *initialOption_)
{
    auto dw = reinterpret_cast<KDDockWidgets::Controllers::DockWidget *>(dw_);
    auto relativeTo = reinterpret_cast<KDDockWidgets::Controllers::DockWidget *>(relativeTo_);
    assert(initialOption_);
    auto &initialOption = *reinterpret_cast<KDDockWidgets::InitialOption *>(initialOption_);
    fromPtr(thisObj)->addDockWidget(dw, static_cast<KDDockWidgets::Location>(location), relativeTo,
                                    initialOption);
}
// addMultiSplitter(KDDockWidgets::Controllers::DropArea * splitter, KDDockWidgets::Location
// location, KDDockWidgets::Controllers::Group * relativeTo, KDDockWidgets::InitialOption option)
void c_KDDockWidgets__Controllers__DropArea__addMultiSplitter_DropArea_Location_Group_InitialOption(
    void *thisObj, void *splitter_, int location, void *relativeTo_, void *option_)
{
    auto splitter = reinterpret_cast<KDDockWidgets::Controllers::DropArea *>(splitter_);
    auto relativeTo = reinterpret_cast<KDDockWidgets::Controllers::Group *>(relativeTo_);
    assert(option_);
    auto &option = *reinterpret_cast<KDDockWidgets::InitialOption *>(option_);
    fromPtr(thisObj)->addMultiSplitter(splitter, static_cast<KDDockWidgets::Location>(location),
                                       relativeTo, option);
}
// addWidget(KDDockWidgets::View * widget, KDDockWidgets::Location location,
// KDDockWidgets::Controllers::Group * relativeTo, KDDockWidgets::InitialOption option)
void c_KDDockWidgets__Controllers__DropArea__addWidget_View_Location_Group_InitialOption(
    void *thisObj, void *widget_, int location, void *relativeTo_, void *option_)
{
    auto widget = reinterpret_cast<KDDockWidgets::View *>(widget_);
    auto relativeTo = reinterpret_cast<KDDockWidgets::Controllers::Group *>(relativeTo_);
    assert(option_);
    auto &option = *reinterpret_cast<KDDockWidgets::InitialOption *>(option_);
    fromPtr(thisObj)->addWidget(widget, static_cast<KDDockWidgets::Location>(location), relativeTo,
                                option);
}
// centralFrame() const
void *c_KDDockWidgets__Controllers__DropArea__centralFrame(void *thisObj)
{
    return fromPtr(thisObj)->centralFrame();
}
// containsDockWidget(KDDockWidgets::Controllers::DockWidget * arg__1) const
bool c_KDDockWidgets__Controllers__DropArea__containsDockWidget_DockWidget(void *thisObj,
                                                                           void *arg__1_)
{
    auto arg__1 = reinterpret_cast<KDDockWidgets::Controllers::DockWidget *>(arg__1_);
    return fromPtr(thisObj)->containsDockWidget(arg__1);
}
// createCentralFrame(QFlags<KDDockWidgets::MainWindowOption> options)
void *
c_static_KDDockWidgets__Controllers__DropArea__createCentralFrame_MainWindowOptions(int options_)
{
    auto options = static_cast<QFlags<KDDockWidgets::MainWindowOption>>(options_);
    return KDDockWidgetsBindings_wrappersNS::DropArea_wrapper::createCentralFrame(options);
}
// customEvent(QEvent * event)
void c_KDDockWidgets__Controllers__DropArea__customEvent_QEvent(void *thisObj, void *event_)
{
    auto event = reinterpret_cast<QEvent *>(event_);
    fromWrapperPtr(thisObj)->customEvent_nocallback(event);
}
// dropIndicatorOverlay() const
void *c_KDDockWidgets__Controllers__DropArea__dropIndicatorOverlay(void *thisObj)
{
    return fromPtr(thisObj)->dropIndicatorOverlay();
}
// event(QEvent * event)
bool c_KDDockWidgets__Controllers__DropArea__event_QEvent(void *thisObj, void *event_)
{
    auto event = reinterpret_cast<QEvent *>(event_);
    return [&] {
        auto targetPtr = fromPtr(thisObj);
        auto wrapperPtr =
            dynamic_cast<KDDockWidgetsBindings_wrappersNS::DropArea_wrapper *>(targetPtr);
        if (wrapperPtr) {
            return wrapperPtr->event_nocallback(event);
        } else {
            return targetPtr->event(event);
        }
    }();
}
// eventFilter(QObject * watched, QEvent * event)
bool c_KDDockWidgets__Controllers__DropArea__eventFilter_QObject_QEvent(void *thisObj,
                                                                        void *watched_,
                                                                        void *event_)
{
    auto watched = reinterpret_cast<QObject *>(watched_);
    auto event = reinterpret_cast<QEvent *>(event_);
    return [&] {
        auto targetPtr = fromPtr(thisObj);
        auto wrapperPtr =
            dynamic_cast<KDDockWidgetsBindings_wrappersNS::DropArea_wrapper *>(targetPtr);
        if (wrapperPtr) {
            return wrapperPtr->eventFilter_nocallback(watched, event);
        } else {
            return targetPtr->eventFilter(watched, event);
        }
    }();
}
// groups() const
void *c_KDDockWidgets__Controllers__DropArea__groups(void *thisObj)
{
    return new Dartagnan::ValueWrapper<QList<KDDockWidgets::Controllers::Group *>> {
        fromPtr(thisObj)->groups()
    };
}
// hasSingleFloatingFrame() const
bool c_KDDockWidgets__Controllers__DropArea__hasSingleFloatingFrame(void *thisObj)
{
    return fromPtr(thisObj)->hasSingleFloatingFrame();
}
// hasSingleFrame() const
bool c_KDDockWidgets__Controllers__DropArea__hasSingleFrame(void *thisObj)
{
    return fromPtr(thisObj)->hasSingleFrame();
}
// isMDIWrapper() const
bool c_KDDockWidgets__Controllers__DropArea__isMDIWrapper(void *thisObj)
{
    return fromPtr(thisObj)->isMDIWrapper();
}
// layoutEqually()
void c_KDDockWidgets__Controllers__DropArea__layoutEqually(void *thisObj)
{
    fromPtr(thisObj)->layoutEqually();
}
// layoutParentContainerEqually(KDDockWidgets::Controllers::DockWidget * arg__1)
void c_KDDockWidgets__Controllers__DropArea__layoutParentContainerEqually_DockWidget(void *thisObj,
                                                                                     void *arg__1_)
{
    auto arg__1 = reinterpret_cast<KDDockWidgets::Controllers::DockWidget *>(arg__1_);
    fromPtr(thisObj)->layoutParentContainerEqually(arg__1);
}
// mdiDockWidgetWrapper() const
void *c_KDDockWidgets__Controllers__DropArea__mdiDockWidgetWrapper(void *thisObj)
{
    return fromPtr(thisObj)->mdiDockWidgetWrapper();
}
// removeHover()
void c_KDDockWidgets__Controllers__DropArea__removeHover(void *thisObj)
{
    fromPtr(thisObj)->removeHover();
}
// setParentView_impl(KDDockWidgets::View * parent)
void c_KDDockWidgets__Controllers__DropArea__setParentView_impl_View(void *thisObj, void *parent_)
{
    auto parent = reinterpret_cast<KDDockWidgets::View *>(parent_);
    fromWrapperPtr(thisObj)->setParentView_impl_nocallback(parent);
}
// tr(const char * s, const char * c, int n)
void *c_static_KDDockWidgets__Controllers__DropArea__tr_char_char_int(const char *s, const char *c,
                                                                      int n)
{
    return new Dartagnan::ValueWrapper<QString> {
        KDDockWidgetsBindings_wrappersNS::DropArea_wrapper::tr(s, c, n)
    };
}
void c_KDDockWidgets__Controllers__DropArea__destructor(void *thisObj)
{
    delete fromPtr(thisObj);
}
void c_KDDockWidgets__Controllers__DropArea__registerVirtualMethodCallback(void *ptr,
                                                                           void *callback,
                                                                           int methodId)
{
    auto wrapper = fromWrapperPtr(ptr);
    switch (methodId) {
    case 295:
        wrapper->m_customEventCallback = reinterpret_cast<
            KDDockWidgetsBindings_wrappersNS::DropArea_wrapper::Callback_customEvent>(callback);
        break;
    case 306:
        wrapper->m_eventCallback =
            reinterpret_cast<KDDockWidgetsBindings_wrappersNS::DropArea_wrapper::Callback_event>(
                callback);
        break;
    case 307:
        wrapper->m_eventFilterCallback = reinterpret_cast<
            KDDockWidgetsBindings_wrappersNS::DropArea_wrapper::Callback_eventFilter>(callback);
        break;
    case 891:
        wrapper->m_setParentView_implCallback = reinterpret_cast<
            KDDockWidgetsBindings_wrappersNS::DropArea_wrapper::Callback_setParentView_impl>(
            callback);
        break;
    }
}
}
