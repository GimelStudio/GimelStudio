#ifndef GT_DEV_DEVACTIONSSTORE_H
#define GT_DEV_DEVACTIONSSTORE_H

#include <QObject>
#include <QString>
#include <QVariantMap>

#include "actions/istore.h"

using namespace gs::actions;

namespace gs::dev
{
class DevActionsStore : public QObject, public IStore
{
    Q_OBJECT
public:
    DevActionsStore()
    {
        init();
    }

    void init() override;

    Q_INVOKABLE void openTestDialog();
};
} // gs::dev

#endif