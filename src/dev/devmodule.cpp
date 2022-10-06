#include <QQmlEngine>

#include "devmodule.h"
#include "internal/devactionsstore.h"

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
    qmlRegisterSingletonInstance<DevActionsStore>("GimelStudio.Dev", 1, 0, "Dev", new DevActionsStore());
}
