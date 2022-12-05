#include <QQmlEngine>

#include "appshellmodule.h"
#include "internal/appshelluiactions.h"

using namespace gs::appshell;

static void appshellInitResources()
{
    Q_INIT_RESOURCE(appshell);
}

std::string AppShellModule::moduleName() const
{
    return "appshell";
}

void AppShellModule::registerResources()
{
    appshellInitResources();
}

void AppShellModule::registerModels()
{
    qmlRegisterSingletonInstance<AppShellUiActions>("GimelStudio.AppShell", 1, 0, "AppShell", new AppShellUiActions());
}
