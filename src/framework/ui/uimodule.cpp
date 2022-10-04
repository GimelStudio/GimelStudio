#include "uimodule.h"

#include <QQmlEngine>

#include "uitheme.h"

using namespace gs::ui;

std::string UiModule::moduleName() const
{
    return "ui";
}

void UiModule::registerUiTypes()
{
    // TODO: Is ui.theme a better accesser in QML?
    qmlRegisterSingletonInstance<UiTheme>("GimelStudio.Ui", 0, 7, "UiTheme", new UiTheme());
}
