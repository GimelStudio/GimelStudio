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
    UiTheme* uitheme = new UiTheme();
    // TODO: init() should probably be called in the UiTheme constructor
    uitheme->init();
    // TODO: Is ui.theme a better accesser in QML?
    qmlRegisterSingletonInstance<UiTheme>("GimelStudio.Ui", 1, 0, "UiTheme", uitheme);
}
