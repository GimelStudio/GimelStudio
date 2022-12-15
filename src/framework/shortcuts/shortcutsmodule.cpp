#include "shortcutsmodule.h"

#include <QQmlEngine>
#include "view/shortcutsmodel.h"

using namespace gs::shortcuts;

static void shortcutsInitResources()
{
    Q_INIT_RESOURCE(shortcuts);
}

String ShortcutsModule::moduleName() const
{
    return "shortcuts";
}

void ShortcutsModule::registerResources()
{
    shortcutsInitResources();
}

void ShortcutsModule::registerModels()
{
    qmlRegisterType<ShortcutsModel>("GimelStudio.Shortcuts", 1, 0, "ShortcutsModel");
}
