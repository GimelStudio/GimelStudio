#include <QQmlEngine>

#include "devmodule.h"
#include "internal/devuiactions.h"

using namespace gs::dev;

static void devInitResources()
{
    Q_INIT_RESOURCE(dev);
}

std::string DevModule::moduleName() const
{
    return "dev";
}

void DevModule::registerResources()
{
    devInitResources();
}

void DevModule::registerStores()
{
    qmlRegisterSingletonInstance<DevUiActions>("GimelStudio.Dev", 1, 0, "Dev", new DevUiActions());
}
