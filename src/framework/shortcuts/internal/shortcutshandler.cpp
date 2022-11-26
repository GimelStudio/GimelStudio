#include "shortcutshandler.h"

#include <QKeyEvent>
#include <QString>

#include "actions/dispatcher.h"

#include "../view/shortcutsmodel.h"

#include <QApplication>
#include <QKeySequence>


using namespace gs::shortcuts;

ShortcutsHandler::ShortcutsHandler(QObject *parent) : QObject(parent) {}

bool ShortcutsHandler::eventFilter(QObject *obj, QEvent *event)
{
    // TODO: Allow shortcuts in focused UI components

    if (qApp->focusObject()) {
        // Check if there is a focused UI component
        if (QString(qApp->focusObject()->metaObject()->className()) != "QQuickContentItem") {
            return QObject::eventFilter(obj, event);
        }
    }

    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);

        // TODO: Not sure if this is the most efficient way of doing this
        for (QVariantMap scMap : ShortcutsModel::instance()->shortcuts()) {
            if (scMap["seq"].toString() == QKeySequence(keyEvent->key() | keyEvent->modifiers()).toString()) {
                dispatcher()->dispatch(scMap["key"].toString().toStdString(), QVariantMap());
                break;
            }
        }

        return true;
    } else {
        return QObject::eventFilter(obj, event);
    }
}
