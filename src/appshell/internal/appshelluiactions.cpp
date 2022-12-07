#include "appshelluiactions.h"
#include "actions/internal/dispatcher.h"
#include "interactive/internal/interactive.h"

#include <QApplication>
#include <QVariantMap>

using namespace gs::actions;
using namespace gs::interactive;
using namespace gs::appshell;

AppShellUiActions::AppShellUiActions()
{
    dispatcher()->reg(this, "about", [this](QVariantMap args) {this->about();});
    dispatcher()->reg(this, "quit", [this](QVariantMap args) {this->quit();});
    interactive()->regDialog("gslauncher://appshell/about", "AppShell/AboutDialog.qml");
}

void AppShellUiActions::about()
{
    Interactive::Params params;
    interactive()->openDialog("gslauncher://appshell/about", params);
}

void AppShellUiActions::aboutQt()
{
    qApp->aboutQt();
}

void AppShellUiActions::quit()
{
    qApp->quit();
}
