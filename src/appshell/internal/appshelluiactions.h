#ifndef GS_APPSHELL_APPSHELLUIACTIONS
#define GS_APPSHELL_APPSHELLUIACTIONS

#include <QObject>
#include <QVariantMap>

#include "actions/iactionable.h"

using namespace gs::actions;

namespace gs::appshell
{
class AppShellUiActions : public QObject, public IActionable
{
    Q_OBJECT
public:
    AppShellUiActions();
    
    Q_INVOKABLE void about();
    Q_INVOKABLE void aboutQt();

    Q_INVOKABLE void quit();
};
} // gs::appshell

#endif
