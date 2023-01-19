#ifndef GT_DEV_DEVUIACTIONS_H
#define GT_DEV_DEVUIACTIONS_H

#include <QObject>
#include <QString>

#include "actions/iactionable.h"
#include "interactive/internal/interactive.h"

using namespace gs::actions;
using namespace gs::interactive;

namespace gs::dev
{
class DevUiActions : public QObject, public IActionable
{
    Q_OBJECT

    INJECT_CLASS_INSTANCE(Interactive, interactive)
public:
    DevUiActions();

    Q_INVOKABLE void openTestDialog();
};
} // gs::dev

#endif