#include "shortcutsmodel.h"

#include <QByteArray>
#include <QDebug>
#include <QDir>
#include <QDirIterator>
#include <QFile>
#include <QJsonDocument>
#include <QString>
#include <QVariantMap>
#include <QXmlStreamReader>

using namespace gs::shortcuts;

ShortcutsModel::ShortcutsModel(QObject* parent) : QAbstractListModel(parent), IActionable()
{
    m_roles.insert(rKey, "key");
    m_roles.insert(rSequence, "sequence");

    m_xmlStringValues["key"] = XmlStringValue::Key;
    m_xmlStringValues["seq"] = XmlStringValue::Sequence;

    load();
}

 bool ShortcutsModel::activate(const QString& sequence)
 {
    for (QVariantMap shortcut : m_shortcuts) {
        if (shortcut["seq"].toString() == sequence) {
            dispatcher()->dispatch(shortcut["key"].toString().toStdString(), QVariantMap());   
            return true;
        }
    }

    return false;
 }

QVariant ShortcutsModel::data(const QModelIndex& index, int role) const
{
    if (!index.isValid()) {
        return QVariant();
    }

    QVariantMap ag = m_shortcuts[index.row()];

    switch (role) {
        case rKey:
            return ag["key"];
        case rSequence:
            return ag["sequence"];
    }

    return QVariant();
}

int ShortcutsModel::rowCount(const QModelIndex&) const
{
    return m_shortcuts.count();
}

QHash<int, QByteArray> ShortcutsModel::roleNames() const
{
    return m_roles;
}

QList<QVariantMap> ShortcutsModel::shortcuts()
{
    return m_shortcuts;
}

void ShortcutsModel::load()
{
    QXmlStreamReader xmlReader;
    QFile shortcutsFile(":/shortcuts/shortcuts_qwerty.xml");

    if (!shortcutsFile.open(QFile::ReadOnly | QFile::Text)) {
        return;
    }

    xmlReader.setDevice(&shortcutsFile);

    while (xmlReader.readNextStartElement()) {
        if (xmlReader.name() == "shortcuts") {
            while (xmlReader.readNextStartElement()) {
                if (xmlReader.name() == "sc" && xmlReader.isStartElement()) {
                    QVariantMap rowData;
                    while (xmlReader.readNextStartElement()) {
                        switch (m_xmlStringValues[xmlReader.name().toString()]) {
                            case Key:
                                rowData["key"] = xmlReader.readElementText();
                                break;
                            case Sequence:
                                rowData["seq"] = xmlReader.readElementText();
                                break;
                            default:
                                xmlReader.skipCurrentElement();
                                break;
                        }
                    }

                    m_shortcuts.append(rowData);
                } else {
                    xmlReader.skipCurrentElement();
                }
            }
        }
    }

    shortcutsFile.close();
}
