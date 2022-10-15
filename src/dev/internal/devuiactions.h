#ifndef GT_DEV_DEVUIACTIONS_H
#define GT_DEV_DEVUIACTIONS_H

#include <QObject>
#include <QString>
#include <QVariantMap>

#include "actions/iactionable.h"

using namespace gs::actions;

namespace gs::dev
{
class DevUiActions : public QObject, public IActionable
{
    Q_OBJECT
public:
    DevUiActions();

    Q_INVOKABLE void openTestDialog();
};
} // gs::dev

#endif