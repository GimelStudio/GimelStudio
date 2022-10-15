#include "shortcutshandler.h"

#include <QKeyEvent>
#include <QString>

#include "actions/dispatcher.h"

#include "../view/shortcutsmodel.h"

#include <QDebug>


using namespace gs::shortcuts;

ShortcutsHandler::ShortcutsHandler(QObject *parent) : QObject(parent) {}

bool ShortcutsHandler::eventFilter(QObject *obj, QEvent *event)
{
    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);

        // TODO: Not sure if this is the most efficient way of doing this
        for (QVariantMap scMap : ShortcutsModel::instance()->shortcuts()) {
            if (scMap["seq"].toString().toLower() == keyEvent->text()) {
                dispatcher()->dispatch(scMap["key"].toString().toStdString(), QVariantMap());
                break;
            }
        }

        return true;
    } else {
        return QObject::eventFilter(obj, event);
    }
}
