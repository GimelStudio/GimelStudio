/*
  This file is part of KDDockWidgets.

  SPDX-FileCopyrightText: 2019-2022 Klarälvdalens Datakonsult AB, a KDAB Group company <info@kdab.com>
  Author: Sérgio Martins <sergio.martins@kdab.com>

  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only

  Contact KDAB at <info@kdab.com> for commercial licensing options.
*/
#include "KDDockWidgetsBindings_exports.h"
#include <ViewFactory_flutter.h>
#include <qstring.h>
#include <View.h>
#include <Group.h>
#include <TitleBar.h>
#include <Stack.h>
#include <TabBar.h>
#include <Separator.h>
#include <FloatingWindow.h>
#include <MainWindow.h>
#include <SideBar.h>
#include <DropArea.h>
#include <ClassicIndicatorWindowViewInterface.h>
#include <ClassicIndicators.h>
#include <qcoreevent.h>
#include <qobject.h>

namespace KDDockWidgetsBindings_wrappersNS {
class ViewFactory_flutter_wrapper : public ::KDDockWidgets::ViewFactory_flutter
{
public:
    ~ViewFactory_flutter_wrapper();
    ViewFactory_flutter_wrapper();
    virtual KDDockWidgets::Views::ClassicIndicatorWindowViewInterface *
    createClassicIndicatorWindow(KDDockWidgets::Controllers::ClassicIndicators *arg__1) const;
    virtual KDDockWidgets::Views::ClassicIndicatorWindowViewInterface *
    createClassicIndicatorWindow_nocallback(
        KDDockWidgets::Controllers::ClassicIndicators *arg__1) const;
    virtual KDDockWidgets::View *
    createDockWidget(const QString &uniqueName, QFlags<KDDockWidgets::DockWidgetOption> arg__2 = {},
                     QFlags<KDDockWidgets::LayoutSaverOption> arg__3 = {},
                     Qt::WindowFlags arg__4 = {}) const;
    virtual KDDockWidgets::View *createDockWidget_nocallback(
        const QString &uniqueName, QFlags<KDDockWidgets::DockWidgetOption> arg__2 = {},
        QFlags<KDDockWidgets::LayoutSaverOption> arg__3 = {}, Qt::WindowFlags arg__4 = {}) const;
    virtual KDDockWidgets::View *createDropArea(KDDockWidgets::Controllers::DropArea *arg__1,
                                                KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *
    createDropArea_nocallback(KDDockWidgets::Controllers::DropArea *arg__1,
                              KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *
    createFloatingWindow(KDDockWidgets::Controllers::FloatingWindow *arg__1,
                         KDDockWidgets::Controllers::MainWindow *parent = nullptr,
                         Qt::WindowFlags windowFlags = {}) const;
    virtual KDDockWidgets::View *
    createFloatingWindow_nocallback(KDDockWidgets::Controllers::FloatingWindow *arg__1,
                                    KDDockWidgets::Controllers::MainWindow *parent = nullptr,
                                    Qt::WindowFlags windowFlags = {}) const;
    virtual KDDockWidgets::View *createGroup(KDDockWidgets::Controllers::Group *arg__1,
                                             KDDockWidgets::View *parent = nullptr) const;
    virtual KDDockWidgets::View *
    createGroup_nocallback(KDDockWidgets::Controllers::Group *arg__1,
                           KDDockWidgets::View *parent = nullptr) const;
    virtual KDDockWidgets::View *createRubberBand(KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *createRubberBand_nocallback(KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *createSeparator(KDDockWidgets::Controllers::Separator *arg__1,
                                                 KDDockWidgets::View *parent = nullptr) const;
    virtual KDDockWidgets::View *
    createSeparator_nocallback(KDDockWidgets::Controllers::Separator *arg__1,
                               KDDockWidgets::View *parent = nullptr) const;
    virtual KDDockWidgets::View *createSideBar(KDDockWidgets::Controllers::SideBar *arg__1,
                                               KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *
    createSideBar_nocallback(KDDockWidgets::Controllers::SideBar *arg__1,
                             KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *createStack(KDDockWidgets::Controllers::Stack *arg__1,
                                             KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *createStack_nocallback(KDDockWidgets::Controllers::Stack *arg__1,
                                                        KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *createTabBar(KDDockWidgets::Controllers::TabBar *tabBar,
                                              KDDockWidgets::View *parent = nullptr) const;
    virtual KDDockWidgets::View *
    createTabBar_nocallback(KDDockWidgets::Controllers::TabBar *tabBar,
                            KDDockWidgets::View *parent = nullptr) const;
    virtual KDDockWidgets::View *createTitleBar(KDDockWidgets::Controllers::TitleBar *arg__1,
                                                KDDockWidgets::View *parent) const;
    virtual KDDockWidgets::View *
    createTitleBar_nocallback(KDDockWidgets::Controllers::TitleBar *arg__1,
                              KDDockWidgets::View *parent) const;
    virtual void customEvent(QEvent *event);
    virtual void customEvent_nocallback(QEvent *event);
    virtual bool event(QEvent *event);
    virtual bool event_nocallback(QEvent *event);
    virtual bool eventFilter(QObject *watched, QEvent *event);
    virtual bool eventFilter_nocallback(QObject *watched, QEvent *event);
    static QString tr(const char *s, const char *c, int n);
    typedef KDDockWidgets::Views::ClassicIndicatorWindowViewInterface *(
        *Callback_createClassicIndicatorWindow)(
        void *, KDDockWidgets::Controllers::ClassicIndicators *arg__1);
    Callback_createClassicIndicatorWindow m_createClassicIndicatorWindowCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createDockWidget)(
        void *, const QString &uniqueName, QFlags<KDDockWidgets::DockWidgetOption> arg__2,
        QFlags<KDDockWidgets::LayoutSaverOption> arg__3, Qt::WindowFlags arg__4);
    Callback_createDockWidget m_createDockWidgetCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createDropArea)(
        void *, KDDockWidgets::Controllers::DropArea *arg__1, KDDockWidgets::View *parent);
    Callback_createDropArea m_createDropAreaCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createFloatingWindow)(
        void *, KDDockWidgets::Controllers::FloatingWindow *arg__1,
        KDDockWidgets::Controllers::MainWindow *parent, Qt::WindowFlags windowFlags);
    Callback_createFloatingWindow m_createFloatingWindowCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createGroup)(void *,
                                                         KDDockWidgets::Controllers::Group *arg__1,
                                                         KDDockWidgets::View *parent);
    Callback_createGroup m_createGroupCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createRubberBand)(void *, KDDockWidgets::View *parent);
    Callback_createRubberBand m_createRubberBandCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createSeparator)(
        void *, KDDockWidgets::Controllers::Separator *arg__1, KDDockWidgets::View *parent);
    Callback_createSeparator m_createSeparatorCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createSideBar)(
        void *, KDDockWidgets::Controllers::SideBar *arg__1, KDDockWidgets::View *parent);
    Callback_createSideBar m_createSideBarCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createStack)(void *,
                                                         KDDockWidgets::Controllers::Stack *arg__1,
                                                         KDDockWidgets::View *parent);
    Callback_createStack m_createStackCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createTabBar)(
        void *, KDDockWidgets::Controllers::TabBar *tabBar, KDDockWidgets::View *parent);
    Callback_createTabBar m_createTabBarCallback = nullptr;
    typedef KDDockWidgets::View *(*Callback_createTitleBar)(
        void *, KDDockWidgets::Controllers::TitleBar *arg__1, KDDockWidgets::View *parent);
    Callback_createTitleBar m_createTitleBarCallback = nullptr;
    typedef void (*Callback_customEvent)(void *, QEvent *event);
    Callback_customEvent m_customEventCallback = nullptr;
    typedef bool (*Callback_event)(void *, QEvent *event);
    Callback_event m_eventCallback = nullptr;
    typedef bool (*Callback_eventFilter)(void *, QObject *watched, QEvent *event);
    Callback_eventFilter m_eventFilterCallback = nullptr;
};
}
extern "C" {
// KDDockWidgets::ViewFactory_flutter::ViewFactory_flutter()
KDDockWidgetsBindings_EXPORT void *c_KDDockWidgets__ViewFactory_flutter__constructor();
// KDDockWidgets::ViewFactory_flutter::createClassicIndicatorWindow(KDDockWidgets::Controllers::ClassicIndicators
// * arg__1) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createClassicIndicatorWindow_ClassicIndicators(void *thisObj,
                                                                                     void *arg__1_);
// KDDockWidgets::ViewFactory_flutter::createDockWidget(const QString & uniqueName,
// QFlags<KDDockWidgets::DockWidgetOption> arg__2, QFlags<KDDockWidgets::LayoutSaverOption> arg__3,
// Qt::WindowFlags arg__4) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createDockWidget_QString_DockWidgetOptions_LayoutSaverOptions_WindowFlags(
    void *thisObj, const char *uniqueName_, int arg__2_, int arg__3_, int arg__4);
// KDDockWidgets::ViewFactory_flutter::createDropArea(KDDockWidgets::Controllers::DropArea * arg__1,
// KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createDropArea_DropArea_View(void *thisObj, void *arg__1_,
                                                                   void *parent_);
// KDDockWidgets::ViewFactory_flutter::createFloatingWindow(KDDockWidgets::Controllers::FloatingWindow
// * arg__1, KDDockWidgets::Controllers::MainWindow * parent, Qt::WindowFlags windowFlags) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createFloatingWindow_FloatingWindow_MainWindow_WindowFlags(
    void *thisObj, void *arg__1_, void *parent_, int windowFlags);
// KDDockWidgets::ViewFactory_flutter::createGroup(KDDockWidgets::Controllers::Group * arg__1,
// KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createGroup_Group_View(void *thisObj, void *arg__1_,
                                                             void *parent_);
// KDDockWidgets::ViewFactory_flutter::createRubberBand(KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createRubberBand_View(void *thisObj, void *parent_);
// KDDockWidgets::ViewFactory_flutter::createSeparator(KDDockWidgets::Controllers::Separator *
// arg__1, KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createSeparator_Separator_View(void *thisObj, void *arg__1_,
                                                                     void *parent_);
// KDDockWidgets::ViewFactory_flutter::createSideBar(KDDockWidgets::Controllers::SideBar * arg__1,
// KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createSideBar_SideBar_View(void *thisObj, void *arg__1_,
                                                                 void *parent_);
// KDDockWidgets::ViewFactory_flutter::createStack(KDDockWidgets::Controllers::Stack * arg__1,
// KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createStack_Stack_View(void *thisObj, void *arg__1_,
                                                             void *parent_);
// KDDockWidgets::ViewFactory_flutter::createTabBar(KDDockWidgets::Controllers::TabBar * tabBar,
// KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createTabBar_TabBar_View(void *thisObj, void *tabBar_,
                                                               void *parent_);
// KDDockWidgets::ViewFactory_flutter::createTitleBar(KDDockWidgets::Controllers::TitleBar * arg__1,
// KDDockWidgets::View * parent) const
KDDockWidgetsBindings_EXPORT void *
c_KDDockWidgets__ViewFactory_flutter__createTitleBar_TitleBar_View(void *thisObj, void *arg__1_,
                                                                   void *parent_);
// KDDockWidgets::ViewFactory_flutter::customEvent(QEvent * event)
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__ViewFactory_flutter__customEvent_QEvent(void *thisObj, void *event_);
// KDDockWidgets::ViewFactory_flutter::event(QEvent * event)
KDDockWidgetsBindings_EXPORT bool c_KDDockWidgets__ViewFactory_flutter__event_QEvent(void *thisObj,
                                                                                     void *event_);
// KDDockWidgets::ViewFactory_flutter::eventFilter(QObject * watched, QEvent * event)
KDDockWidgetsBindings_EXPORT bool
c_KDDockWidgets__ViewFactory_flutter__eventFilter_QObject_QEvent(void *thisObj, void *watched_,
                                                                 void *event_);
// KDDockWidgets::ViewFactory_flutter::tr(const char * s, const char * c, int n)
KDDockWidgetsBindings_EXPORT void *
c_static_KDDockWidgets__ViewFactory_flutter__tr_char_char_int(const char *s, const char *c, int n);
KDDockWidgetsBindings_EXPORT void c_KDDockWidgets__ViewFactory_flutter__destructor(void *thisObj);
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__ViewFactory_flutter__registerVirtualMethodCallback(void *ptr, void *callback,
                                                                    int methodId);
KDDockWidgetsBindings_EXPORT void
c_KDDockWidgets__ViewFactory_flutter_Finalizer(void *, void *cppObj, void *);
}
