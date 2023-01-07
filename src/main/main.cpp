#include "appshell/appshell.h"

#include "appshell/appshellmodule.h"
#include "dev/devmodule.h"
#include "nodes/nodesmodule.h"
#include "properties/propertiesmodule.h"
#include "shortcuts/shortcutsmodule.h"
#include "ui/uimodule.h"
#include "uicomponents/uicomponentsmodule.h"

int main(int argc, char *argv[])
{
    gs::appshell::AppShell app;

    app.addModule(new gs::appshell::AppShellModule());
    app.addModule(new gs::dev::DevModule());
    app.addModule(new gs::nodes::NodesModule());
    app.addModule(new gs::properties::PropertiesModule());
    app.addModule(new gs::shortcuts::ShortcutsModule());
    app.addModule(new gs::ui::UiModule());
    app.addModule(new gs::uicomponents::UiComponentsModule());

    int code = app.run(argc, argv);
    return code;
}
