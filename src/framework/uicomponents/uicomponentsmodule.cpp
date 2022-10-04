#include "uicomponentsmodule.h"
#include "ui/uiengines.h"

#include "view/dialogview.h"
#include "view/popupview.h"

using namespace gs::uicomponents;

static void uicomponentsInitResources()
{
    Q_INIT_RESOURCE(uicomponents);
}

std::string UiComponentsModule::moduleName() const
{
    return "uicomponents";
}

void UiComponentsModule::registerResources()
{
    uicomponentsInitResources();
}

void UiComponentsModule::registerUiTypes()
{
    qmlRegisterType<DialogView>("GimelStudio.UiComponents", 0, 1, "DialogView");
    qmlRegisterType<PopupView>("GimelStudio.UiComponents", 0, 1, "PopupView");
}
