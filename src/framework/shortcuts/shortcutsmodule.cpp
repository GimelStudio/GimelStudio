#include "shortcutsmodule.h"

#include <QQmlEngine>
#include "view/shortcutsmodel.h"

using namespace gs::shortcuts;

static void shortcutsInitResources()
{
    Q_INIT_RESOURCE(shortcuts);
}

std::string ShortcutsModule::moduleName() const
{
    return "shortcuts";
}

void ShortcutsModule::registerResources()
{
    shortcutsInitResources();
}

void ShortcutsModule::registerStores()
{
    qmlRegisterType<ShortcutsModel>("GimelStudio.Shortcuts", 1, 0, "ShortcutsModel");
}
