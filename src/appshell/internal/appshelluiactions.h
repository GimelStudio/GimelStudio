#ifndef GS_APPSHELL_APPSHELLUIACTIONS
#define GS_APPSHELL_APPSHELLUIACTIONS

#include <QObject>
#include <QVariantMap>

#include "actions/istore.h"

using namespace gs::actions;

namespace gs::appshell
{
class AppShellUiActions : public QObject, public IStore
{
    Q_OBJECT
public:
    AppShellUiActions();
    
    Q_INVOKABLE void about();
    Q_INVOKABLE void aboutQt();
};
} // gs::appshell

#endif
