#include "appshellactionsstore.h"
#include "actions/dispatcher.h"
#include "interactive/internal/interactive.h"

#include <QApplication>

using namespace gs::actions;
using namespace gs::interactive;
using namespace gs::appshell;

void AppShellActionsStore::init()
{
    Interactive::instance()->regDialog("gslauncher://appshell/about", "AppShell/AboutDialog.qml");
}

void AppShellActionsStore::about()
{
    Interactive::Params params;
    Interactive::instance()->openDialog("gslauncher://appshell/about", params);
}

void AppShellActionsStore::aboutQt()
{
    qApp->aboutQt();
}
