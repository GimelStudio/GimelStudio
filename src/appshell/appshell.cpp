#include <QApplication>
#include <QGuiApplication>
#include <QMetaType>
#include <QString>
#include <QStringLiteral>
#include <QUrl>

#include <kddockwidgets/Config.h>
#include <kddockwidgets/views/DockWidget_qtquick.h>
#include <kddockwidgets/Platform_qtquick.h>
#include <kddockwidgets/ViewFactory_qtquick.h>
#include <kddockwidgets/private/DockRegistry.h>
#include <kddockwidgets/views/MainWindow_qtquick.h>

#include "appshell.h"

#include "ui/uiengines.h"

#include "view/gsviewfactory.h"


using namespace gs::appshell;

AppShell::AppShell()
{
}

void AppShell::addModule(modularity::IModuleSetup* module)
{
    m_modules.push_back(module);
}

int AppShell::run(int argc, char** argv)
{
    QApplication app(argc, argv);

    KDDockWidgets::initFrontend(KDDockWidgets::FrontendType::QtQuick);

    auto &config = KDDockWidgets::Config::self();
    auto flags = config.flags() | KDDockWidgets::Config::Flag_AlwaysShowTabs
                                     | KDDockWidgets::Config::Flag_AllowReorderTabs
                                     | KDDockWidgets::Config::Flag_HideTitleBarWhenTabsVisible;

    config.setFlags(flags);
    config.setViewFactory(new GSViewFactory());

    qmlAppEngine()->addImportPath(":/qml");
    KDDockWidgets::Platform_qtquick::instance()->setQmlEngine(qmlAppEngine());

    for (modularity::IModuleSetup* m : m_modules) {
        m->registerResources();
        m->registerModels();
        m->registerUiTypes();
    }

    const QUrl url(QStringLiteral("qrc:/qml") + "/Main.qml");
    qmlAppEngine()->load(url);

    int result = app.exec();

    qDeleteAll(m_modules);
    m_modules.clear();

    return result;
}
