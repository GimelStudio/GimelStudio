#include <QApplication>
#include <QGuiApplication>
#include <QMetaType>
#include <QString>
#include <QStringLiteral>
#include <QUrl>
#include <QVariantMap>

#include "appshell.h"
#include "actions/dispatcher.h"

#include "ui/uiengines.h"

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

    qmlAppEngine()->addImportPath(":/qml");

    for (modularity::IModuleSetup* m : m_modules) {
        m->registerResources();
        m->registerStores();
        m->registerUiTypes();
    }

    const QUrl url(QStringLiteral("qrc:/qml") + "/Main.qml");
    qmlAppEngine()->load(url);

    int result = app.exec();

    qDeleteAll(m_modules);
    m_modules.clear();

    return result;
}
