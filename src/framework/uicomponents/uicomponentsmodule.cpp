#include "uicomponentsmodule.h"
#include "ui/uiengines.h"

#include "view/dialogview.h"
#include "view/nodeview.h"
#include "view/popupview.h"

using namespace gs::uicomponents;

static void uicomponentsInitResources()
{
    Q_INIT_RESOURCE(uicomponents);
}

String UiComponentsModule::moduleName() const
{
    return "uicomponents";
}

void UiComponentsModule::registerResources()
{
    uicomponentsInitResources();
}

void UiComponentsModule::registerUiTypes()
{
    qmlRegisterType<DialogView>("GimelStudio.UiComponents", 1, 0, "DialogView");
    qmlRegisterType<NodeView>("GimelStudio.UiComponents", 1, 0, "NodeView");
    qmlRegisterType<PopupView>("GimelStudio.UiComponents", 1, 0, "PopupView");
}
