#include <iomanip>
#include <iostream>
#include <string>
#include <type_traits>
#include <variant>
#include <vector>
#include <iostream>

#include <QQmlComponent>
#include <QString>
#include <QUrl>
#include <QVariant>

#include "ui/uiengines.h"
#include "uicomponents/view/dialogview.h"

#include "interactive.h"

using namespace gs::interactive;
using namespace gs::uicomponents;

Interactive::Interactive(QObject* parent) : QObject(parent)
{
}

Interactive* Interactive::instance()
{
    static Interactive i;
    return &i;
}

void Interactive::regDialog(const std::string& path, const std::string& resourcePath)
{
    m_dialogs.insert({path, resourcePath});
}

Interactive::Result Interactive::openDialog(const std::string& path, Params& params)
{
    Interactive::Result result;
    for (auto iter = m_dialogs.begin(); iter != m_dialogs.end(); ++iter) {
        // Path
        std::string p = iter->first;
        // Resource path
        std::string rp = iter->second;
        if (path == p) {
            QQmlComponent* component = new QQmlComponent(qmlAppEngine(), QUrl("qrc:/qml/GimelStudio/" + QString::fromStdString(rp)));
            if (component->isError()) {
                // TODO: Use a logger
                std::cout << "Will not open dialog due to the following error." << std::endl;
                std::cout << component->errorString().toStdString() << std::endl;
                result["code"] = static_cast<int>(Ret::Code::Bug);
                return result;
            }

            DialogView* dialog = qobject_cast<DialogView*>(component->create());

            for (auto& [ name, par ] : params) {
                // std::visit([name, dialog](auto&& c) {
                //     std::cout << c << std::endl;
                //     dialog->setProperty(name.c_str(), QVariant::fromValue(c);
                // }, par);
                dialog->setProperty(name.c_str(), par);
            }

            if (dialog->sync()) {
                result = dialog->exec();
            } else {
                dialog->open();
                result["code"] = static_cast<int>(Ret::Code::Ok);
            }

            break;
        }
    }

    return result;
}
