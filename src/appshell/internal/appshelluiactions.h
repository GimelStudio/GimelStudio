#ifndef GS_APPSHELL_APPSHELLUIACTIONS
#define GS_APPSHELL_APPSHELLUIACTIONS

#include <QObject>
#include <QVariantMap>

#include "global/inject.h"

#include "actions/iactionable.h"
#include "actions/internal/dispatcher.h"
#include "interactive/internal/interactive.h"

using namespace gs::actions;
using namespace gs::interactive;

namespace gs::appshell
{
class AppShellUiActions : public QObject, public IActionable
{
    Q_OBJECT
    INJECT_STATIC(Dispatcher, dispatcher)
    INJECT_STATIC(Interactive, interactive)
public:
    AppShellUiActions();
    
    Q_INVOKABLE void about();
    Q_INVOKABLE void aboutQt();

    Q_INVOKABLE void quit();
};
} // gs::appshell

#endif
