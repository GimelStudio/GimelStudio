#include "devactionsstore.h"

#include <QVariant>
#include <QDebug>

#include "actions/dispatcher.h"
#include "actions/actiontypes.h"
#include "interactive/internal/interactive.h"

using namespace gs::actions;
using namespace gs::dev;
using namespace gs::interactive;

void DevActionsStore::init()
{
    Interactive::instance()->regDialog("gimelstudio://dev/testdialog", "Dev/TestDialog.qml");
}

void DevActionsStore::openTestDialog()
{
    Interactive::Params params = {};
    Interactive::Result result = Interactive::instance()->openDialog("gimelstudio://dev/testdialog", params);
}
