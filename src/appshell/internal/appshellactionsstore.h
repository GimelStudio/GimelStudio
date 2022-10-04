#ifndef GS_APPSHELL_APPSHELLACTIONSSTORE
#define GS_APPSHELL_APPSHELLACTIONSSTORE

#include <QObject>
#include <QVariantMap>

#include "actions/istore.h"

using namespace gs::actions;

namespace gs::appshell
{
class AppShellActionsStore : public QObject, public IStore
{
    Q_OBJECT
public:
    AppShellActionsStore()
    {
        init();
    }

    void init() override;
    
    Q_INVOKABLE void about();
    Q_INVOKABLE void aboutQt();
};
} // gs::appshell

#endif
