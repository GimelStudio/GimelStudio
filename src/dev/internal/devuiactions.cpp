#include "devuiactions.h"

#include <QVariant>
#include <QDebug>

#include "actions/actiontypes.h"

using namespace gs::actions;
using namespace gs::dev;
using namespace gs::interactive;

DevUiActions::DevUiActions()
{
    interactive()->regDialog("gimelstudio://dev/testdialog", "Dev/TestDialog.qml");
}

void DevUiActions::openTestDialog()
{
    // TODO: Clean up Interactive::Params and Interactive::Result
    Interactive::Params params = {};
    Interactive::Result result = interactive()->openDialog("gimelstudio://dev/testdialog", params);
}
