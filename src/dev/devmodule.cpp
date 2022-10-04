#include <QQmlEngine>

#include "devmodule.h"

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
}
