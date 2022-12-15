#include "uimodule.h"

#include <QQmlEngine>

#include "iconcodes.h"
#include "uitheme.h"

using namespace gs::ui;

String UiModule::moduleName() const
{
    return "ui";
}

void UiModule::registerUiTypes()
{
    qmlRegisterUncreatableType<IconCode>("GimelStudio.Ui", 1, 0, "IconCode", "Not creatable as it is an enum type");

    // TODO: Is ui.theme a better accesser in QML?
    qmlRegisterSingletonInstance<UiTheme>("GimelStudio.Ui", 1, 0, "UiTheme", new UiTheme());

}
