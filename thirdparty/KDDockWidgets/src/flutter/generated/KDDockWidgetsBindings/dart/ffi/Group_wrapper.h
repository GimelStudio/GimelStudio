/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/
#include "KDDockWidgetsBindings_exports.h"
#include <Group.h>
#include <qstring.h>
#include <View.h>
#include <DockWidget.h>
#include <KDDockWidgets.h>
#include <FloatingWindow.h>
#include <Stack.h>
#include <TabBar.h>
#include <qpoint.h>
#include <TitleBar.h>
#include <MainWindow.h>
#include <Item_p.h>
#include <qrect.h>
#include <DropArea.h>
#include <controllers/Layout.h>
#include <qsize.h>
#include <qobject.h>
#include <qcoreevent.h>

namespace KDDockWidgetsBindings_wrappersNS {
class Group_wrapper : public ::KDDockWidgets::Controllers::Group
{
public:
    ~Group_wrapper();
    Group_wrapper(KDDockWidgets::View *parent = nullptr);
    KDDockWidgets::Controllers::TitleBar *actualTitleBar() const;
    void actualTitleBarChanged();
    void addTab(KDDockWidgets::Controllers::DockWidget *arg__1,
                KDDockWidgets::InitialOption arg__2 = {});
    void addTab(KDDockWidgets::Controllers::FloatingWindow *floatingWindow,
                KDDockWidgets::InitialOption arg__2 = {});
    void addTab(KDDockWidgets::Controllers::Group *arg__1,
                KDDockWidgets::InitialOption arg__2 = {});
    bool allDockWidgetsHave(KDDockWidgets::DockWidgetOption arg__1) const;
    bool allDockWidgetsHave(KDDockWidgets::LayoutSaverOption arg__1) const;
    bool alwaysShowsTabs() const;
    bool anyDockWidgetsHas(KDDockWidgets::DockWidgetOption arg__1) const;
    bool anyDockWidgetsHas(KDDockWidgets::LayoutSaverOption arg__1) const;
    bool anyNonClosable() const;
    bool anyNonDockable() const;
    bool beingDeletedLater() const;
    QSize biggestDockWidgetMaxSize() const;
    bool containsDockWidget(KDDockWidgets::Controllers::DockWidget *w) const;
    bool containsMouse(QPoint globalPos) const;
    KDDockWidgets::Controllers::DockWidget *currentDockWidget() const;
    int currentIndex() const;
    int currentTabIndex() const;
    virtual void customEvent(QEvent *event);
    virtual void customEvent_nocallback(QEvent *event);
    static int dbg_numFrames();
    KDDockWidgets::Controllers::FloatingWindow *
    detachTab(KDDockWidgets::Controllers::DockWidget *arg__1);
    KDDockWidgets::Controllers::DockWidget *dockWidgetAt(int index) const;
    int dockWidgetCount() const;
    QSize dockWidgetsMinSize() const;
    virtual QRect dragRect() const;
    virtual QRect dragRect_nocallback() const;
    virtual bool event(QEvent *event);
    virtual bool event_nocallback(QEvent *event);
    virtual bool eventFilter(QObject *watched, QEvent *event);
    virtual bool eventFilter_nocallback(QObject *watched, QEvent *event);
    KDDockWidgets::Controllers::FloatingWindow *floatingWindow() const;
    void focusedWidgetChanged();
    virtual void focusedWidgetChangedCallback();
    virtual void focusedWidgetChangedCallback_nocallback();
    bool hasNestedMDIDockWidgets() const;
    bool hasSingleDockWidget() const;
    bool hasTabsVisible() const;
    void hasTabsVisibleChanged();
    int indexOfDockWidget(const KDDockWidgets::Controllers::DockWidget *arg__1);
    void insertDockWidget(KDDockWidgets::Controllers::DockWidget *arg__1, int index);
    void insertWidget(KDDockWidgets::Controllers::DockWidget *arg__1, int index,
                      KDDockWidgets::InitialOption arg__3 = {});
    bool isCentralFrame() const;
    bool isDockable() const;
    bool isEmpty() const;
    bool isFloating() const;
    void isFocusedChanged();
    virtual void isFocusedChangedCallback();
    virtual void isFocusedChangedCallback_nocallback();
    bool isInFloatingWindow() const;
    bool isInMainWindow() const;
    void isInMainWindowChanged();
    bool isMDI() const;
    void isMDIChanged();
    bool isMDIWrapper() const;
    bool isOverlayed() const;
    bool isTheOnlyFrame() const;
    Layouting::Item *layoutItem() const;
    KDDockWidgets::Controllers::MainWindow *mainWindow() const;
    KDDockWidgets::Controllers::DockWidget *mdiDockWidgetWrapper() const;
    KDDockWidgets::Controllers::DropArea *mdiDropAreaWrapper() const;
    KDDockWidgets::Controllers::Group *mdiFrame() const;
    int nonContentsHeight() const;
    void numDockWidgetsChanged();
    void onDockWidgetCountChanged();
    void onDockWidgetTitleChanged();
    void removeWidget(KDDockWidgets::Controllers::DockWidget *arg__1);
    void renameTab(int index, const QString &arg__2);
    void restoreToPreviousPosition();
    void setCurrentDockWidget(KDDockWidgets::Controllers::DockWidget *arg__1);
    void setCurrentTabIndex(int index);
    void setLayout(KDDockWidgets::Controllers::Layout *arg__1);
    void setLayoutItem(Layouting::Item *item);
    virtual void setParentView_impl(KDDockWidgets::View *parent);
    virtual void setParentView_impl_nocallback(KDDockWidgets::View *parent);
    KDDockWidgets::Controllers::Stack *stack() const;
    KDDockWidgets::Controllers::TabBar *tabBar() const;
    QString title() const;
    KDDockWidgets::Controllers::TitleBar *titleBar() const;
    static QString tr(const char *s, const char *c, int n);
    void unoverlay();
    void updateFloatingActions();
    void updateTitleAndIcon();
    void updateTitleBarVisibility();
    int userType() const;
    typedef void (*Callback_customEvent)(void *, QEvent *event);
    Callback_customEvent m_customEventCallback = nullptr;
    typedef QRect *(*Callback_dragRect)(void *);
    Callback_dragRect m_dragRectCallback = nullptr;
    typedef bool (*Callback_event)(void *, QEvent *event);
    Callback_event m_eventCallback = nullptr;
    typedef bool (*Callback_eventFilter)(void *, QObject *watched, QEvent *event);
    Callback_eventFilter m_eventFilterCallback = nullptr;
    typedef void (*Callback_focusedWidgetChangedCallback)(void *);
    Callback_focusedWidgetChangedCallback m_focusedWidgetChangedCallbackCallback = nullptr;
    typedef void (*Callback_isFocusedChangedCallback)(void *);
    Callback_isFocusedChangedCallback m_isFocusedChangedCallbackCallback = nullptr;
    typedef void (*Callback_setParentView_impl)(void *, KDDockWidgets::View *parent);
    Callback_setParentView_impl m_setParentView_implCallback = nullptr;
};
}
extern "C" {
// KDDockWidgets::Controllers::Group::Group(KDDockWidgets::View * parent)
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__constructor_View(void *parent_);
// KDDockWidgets::Controllers::Group::actualTitleBar() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__actualTitleBar(void *thisObj);
// KDDockWidgets::Controllers::Group::actualTitleBarChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__actualTitleBarChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::addTab(KDDockWidgets::Controllers::DockWidget * arg__1,
// KDDockWidgets::InitialOption arg__2)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__addTab_DockWidget_InitialOption(void *thisObj, void *arg__1_,
                                                                     void *arg__2_);
// KDDockWidgets::Controllers::Group::addTab(KDDockWidgets::Controllers::FloatingWindow *
// floatingWindow, KDDockWidgets::InitialOption arg__2)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__addTab_FloatingWindow_InitialOption(void *thisObj,
                                                                         void *floatingWindow_,
                                                                         void *arg__2_);
// KDDockWidgets::Controllers::Group::addTab(KDDockWidgets::Controllers::Group * arg__1,
// KDDockWidgets::InitialOption arg__2)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__addTab_Group_InitialOption(void *thisObj, void *arg__1_,
                                                                void *arg__2_);
// KDDockWidgets::Controllers::Group::allDockWidgetsHave(KDDockWidgets::DockWidgetOption arg__1)
// const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__allDockWidgetsHave_DockWidgetOption(void *thisObj, int arg__1);
// KDDockWidgets::Controllers::Group::allDockWidgetsHave(KDDockWidgets::LayoutSaverOption arg__1)
// const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__allDockWidgetsHave_LayoutSaverOption(void *thisObj,
                                                                          int arg__1);
// KDDockWidgets::Controllers::Group::alwaysShowsTabs() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__alwaysShowsTabs(void *thisObj);
// KDDockWidgets::Controllers::Group::anyDockWidgetsHas(KDDockWidgets::DockWidgetOption arg__1)
// const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__anyDockWidgetsHas_DockWidgetOption(void *thisObj, int arg__1);
// KDDockWidgets::Controllers::Group::anyDockWidgetsHas(KDDockWidgets::LayoutSaverOption arg__1)
// const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__anyDockWidgetsHas_LayoutSaverOption(void *thisObj, int arg__1);
// KDDockWidgets::Controllers::Group::anyNonClosable() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__anyNonClosable(void *thisObj);
// KDDockWidgets::Controllers::Group::anyNonDockable() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__anyNonDockable(void *thisObj);
// KDDockWidgets::Controllers::Group::beingDeletedLater() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__beingDeletedLater(void *thisObj);
// KDDockWidgets::Controllers::Group::biggestDockWidgetMaxSize() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__biggestDockWidgetMaxSize(void *thisObj);
// KDDockWidgets::Controllers::Group::containsDockWidget(KDDockWidgets::Controllers::DockWidget * w)
// const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__containsDockWidget_DockWidget(void *thisObj, void *w_);
// KDDockWidgets::Controllers::Group::containsMouse(QPoint globalPos) const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__containsMouse_QPoint(void *thisObj, void *globalPos_);
// KDDockWidgets::Controllers::Group::currentDockWidget() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__currentDockWidget(void *thisObj);
// KDDockWidgets::Controllers::Group::currentIndex() const
KDDockWidgetsBindings_EXPORT int c_KDDockWidgets__Controllers__Group__currentIndex(void *thisObj);
// KDDockWidgets::Controllers::Group::currentTabIndex() const
KDDockWidgetsBindings_EXPORT int
c_KDDockWidgets__Controllers__Group__currentTabIndex(void *thisObj);
// KDDockWidgets::Controllers::Group::customEvent(QEvent * event)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__customEvent_QEvent(void *thisObj, void *event_);
// KDDockWidgets::Controllers::Group::dbg_numFrames()
KDDockWidgetsBindings_EXPORT int c_static_KDDockWidgets__Controllers__Group__dbg_numFrames();
// KDDockWidgets::Controllers::Group::detachTab(KDDockWidgets::Controllers::DockWidget * arg__1)
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__detachTab_DockWidget(void *thisObj, void *arg__1_);
// KDDockWidgets::Controllers::Group::dockWidgetAt(int index) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__dockWidgetAt_int(void *thisObj, int index);
// KDDockWidgets::Controllers::Group::dockWidgetCount() const
KDDockWidgetsBindings_EXPORT int
c_KDDockWidgets__Controllers__Group__dockWidgetCount(void *thisObj);
// KDDockWidgets::Controllers::Group::dockWidgetsMinSize() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__dockWidgetsMinSize(void *thisObj);
// KDDockWidgets::Controllers::Group::dragRect() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__dragRect(void *thisObj);
// KDDockWidgets::Controllers::Group::event(QEvent * event)
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Group__event_QEvent(void *thisObj,
                                                                                    void *event_);
// KDDockWidgets::Controllers::Group::eventFilter(QObject * watched, QEvent * event)
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__eventFilter_QObject_QEvent(void *thisObj, void *watched_,
                                                                void *event_);
// KDDockWidgets::Controllers::Group::floatingWindow() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__floatingWindow(void *thisObj);
// KDDockWidgets::Controllers::Group::focusedWidgetChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__focusedWidgetChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::focusedWidgetChangedCallback()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__focusedWidgetChangedCallback(void *thisObj);
// KDDockWidgets::Controllers::Group::hasNestedMDIDockWidgets() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__hasNestedMDIDockWidgets(void *thisObj);
// KDDockWidgets::Controllers::Group::hasSingleDockWidget() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__hasSingleDockWidget(void *thisObj);
// KDDockWidgets::Controllers::Group::hasTabsVisible() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__hasTabsVisible(void *thisObj);
// KDDockWidgets::Controllers::Group::hasTabsVisibleChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__hasTabsVisibleChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::indexOfDockWidget(const KDDockWidgets::Controllers::DockWidget
// * arg__1)
KDDockWidgetsBindings_EXPORT int
c_KDDockWidgets__Controllers__Group__indexOfDockWidget_DockWidget(void *thisObj, void *arg__1_);
// KDDockWidgets::Controllers::Group::insertDockWidget(KDDockWidgets::Controllers::DockWidget *
// arg__1, int index)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__insertDockWidget_DockWidget_int(void *thisObj, void *arg__1_,
                                                                     int index);
// KDDockWidgets::Controllers::Group::insertWidget(KDDockWidgets::Controllers::DockWidget * arg__1,
// int index, KDDockWidgets::InitialOption arg__3)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__insertWidget_DockWidget_int_InitialOption(void *thisObj,
                                                                               void *arg__1_,
                                                                               int index,
                                                                               void *arg__3_);
// KDDockWidgets::Controllers::Group::isCentralFrame() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__isCentralFrame(void *thisObj);
// KDDockWidgets::Controllers::Group::isDockable() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Group__isDockable(void *thisObj);
// KDDockWidgets::Controllers::Group::isEmpty() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Group__isEmpty(void *thisObj);
// KDDockWidgets::Controllers::Group::isFloating() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Group__isFloating(void *thisObj);
// KDDockWidgets::Controllers::Group::isFocusedChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__isFocusedChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::isFocusedChangedCallback()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__isFocusedChangedCallback(void *thisObj);
// KDDockWidgets::Controllers::Group::isInFloatingWindow() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__isInFloatingWindow(void *thisObj);
// KDDockWidgets::Controllers::Group::isInMainWindow() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__isInMainWindow(void *thisObj);
// KDDockWidgets::Controllers::Group::isInMainWindowChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__isInMainWindowChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::isMDI() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Group__isMDI(void *thisObj);
// KDDockWidgets::Controllers::Group::isMDIChanged()
KDDockWidgetsBindings_EXPORT void c_KDDockWidgets__Controllers__Group__isMDIChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::isMDIWrapper() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Group__isMDIWrapper(void *thisObj);
// KDDockWidgets::Controllers::Group::isOverlayed() const
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__Controllers__Group__isOverlayed(void *thisObj);
// KDDockWidgets::Controllers::Group::isTheOnlyFrame() const
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__Controllers__Group__isTheOnlyFrame(void *thisObj);
// KDDockWidgets::Controllers::Group::layoutItem() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__layoutItem(void *thisObj);
// KDDockWidgets::Controllers::Group::mainWindow() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__mainWindow(void *thisObj);
// KDDockWidgets::Controllers::Group::mdiDockWidgetWrapper() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__mdiDockWidgetWrapper(void *thisObj);
// KDDockWidgets::Controllers::Group::mdiDropAreaWrapper() const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__Controllers__Group__mdiDropAreaWrapper(void *thisObj);
// KDDockWidgets::Controllers::Group::mdiFrame() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__mdiFrame(void *thisObj);
// KDDockWidgets::Controllers::Group::nonContentsHeight() const
KDDockWidgetsBindings_EXPORT int
c_KDDockWidgets__Controllers__Group__nonContentsHeight(void *thisObj);
// KDDockWidgets::Controllers::Group::numDockWidgetsChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__numDockWidgetsChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::onDockWidgetCountChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__onDockWidgetCountChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::onDockWidgetTitleChanged()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__onDockWidgetTitleChanged(void *thisObj);
// KDDockWidgets::Controllers::Group::removeWidget(KDDockWidgets::Controllers::DockWidget * arg__1)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__removeWidget_DockWidget(void *thisObj, void *arg__1_);
// KDDockWidgets::Controllers::Group::renameTab(int index, const QString & arg__2)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__renameTab_int_QString(void *thisObj, int index,
                                                           const char *arg__2_);
// KDDockWidgets::Controllers::Group::restoreToPreviousPosition()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__restoreToPreviousPosition(void *thisObj);
// KDDockWidgets::Controllers::Group::setCurrentDockWidget(KDDockWidgets::Controllers::DockWidget *
// arg__1)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__setCurrentDockWidget_DockWidget(void *thisObj, void *arg__1_);
// KDDockWidgets::Controllers::Group::setCurrentTabIndex(int index)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__setCurrentTabIndex_int(void *thisObj, int index);
// KDDockWidgets::Controllers::Group::setLayout(KDDockWidgets::Controllers::Layout * arg__1)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__setLayout_Layout(void *thisObj, void *arg__1_);
// KDDockWidgets::Controllers::Group::setLayoutItem(Layouting::Item * item)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__setLayoutItem_Item(void *thisObj, void *item_);
// KDDockWidgets::Controllers::Group::setParentView_impl(KDDockWidgets::View * parent)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__setParentView_impl_View(void *thisObj, void *parent_);
// KDDockWidgets::Controllers::Group::stack() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__stack(void *thisObj);
// KDDockWidgets::Controllers::Group::tabBar() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__tabBar(void *thisObj);
// KDDockWidgets::Controllers::Group::title() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__title(void *thisObj);
// KDDockWidgets::Controllers::Group::titleBar() const
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__Controllers__Group__titleBar(void *thisObj);
// KDDockWidgets::Controllers::Group::tr(const char * s, const char * c, int n)
KDDockWidgetsBindings_EXPORT void *
c_static_KDDockWidgets__Controllers__Group__tr_char_char_int(const char *s, const char *c, int n);
// KDDockWidgets::Controllers::Group::unoverlay()
KDDockWidgetsBindings_EXPORT void c_KDDockWidgets__Controllers__Group__unoverlay(void *thisObj);
// KDDockWidgets::Controllers::Group::updateFloatingActions()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__updateFloatingActions(void *thisObj);
// KDDockWidgets::Controllers::Group::updateTitleAndIcon()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__updateTitleAndIcon(void *thisObj);
// KDDockWidgets::Controllers::Group::updateTitleBarVisibility()
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__updateTitleBarVisibility(void *thisObj);
// KDDockWidgets::Controllers::Group::userType() const
KDDockWidgetsBindings_EXPORT int c_KDDockWidgets__Controllers__Group__userType(void *thisObj);
KDDockWidgetsBindings_EXPORT void c_KDDockWidgets__Controllers__Group__destructor(void *thisObj);
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group__registerVirtualMethodCallback(void *ptr, void *callback,
                                                                   int methodId);
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__Controllers__Group_Finalizer(void *, void *cppObj, void *);
}
