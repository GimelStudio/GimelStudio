#include "appshelluiactions.h"
#include "actions/dispatcher.h"
#include "interactive/internal/interactive.h"

#include <QApplication>

using namespace gs::actions;
using namespace gs::interactive;
using namespace gs::appshell;

AppShellUiActions::AppShellUiActions()
{
    Interactive::instance()->regDialog("gslauncher://appshell/about", "AppShell/AboutDialog.qml");
}

void AppShellUiActions::about()
{
    Interactive::Params params;
    Interactive::instance()->openDialog("gslauncher://appshell/about", params);
}

void AppShellUiActions::aboutQt()
{
    qApp->aboutQt();
}
