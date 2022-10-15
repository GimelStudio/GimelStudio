#ifndef GS_SHORTCUTS_SHORTCUTSMODEL_H
#define GS_SHORTCUTS_SHORTCUTSMODEL_H

#include <QAbstractListModel>
#include <QHash>
#include <QMap>
#include <QModelIndex>
#include <QObject>
#include <QString>
#include <QVariant>


#include "actions/iactionable.h"

using namespace gs::actions;

namespace gs::shortcuts {

class ShortcutsModel : public QAbstractListModel, public IActionable
{
    Q_OBJECT

public:
    explicit ShortcutsModel(QObject* parent = nullptr);
    static ShortcutsModel* instance();

    QVariant data(const QModelIndex& index, int role) const override;
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QHash<int, QByteArray> roleNames() const override;

    QList<QVariantMap> shortcuts();

    Q_INVOKABLE void load();

private:
    enum Roles {
        rKey = Qt::UserRole + 1,
        rSequence,
    };

    enum XmlStringValue {
        Key,
        Sequence
    };

    QMap<QString, XmlStringValue> m_xmlStringValues;

    QHash<int, QByteArray> m_roles;
    QList<QVariantMap> m_shortcuts;
};

} // gs::shortcuts

#endif // GS_SHORTCUTS_SHORTCUTSMODEL_H