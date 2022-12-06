#include "gsviewfactory.h"

using namespace gs::appshell;

GSViewFactory::~GSViewFactory() = default;

QUrl GSViewFactory::titleBarFilename() const
{
    return QUrl("qrc:/qml/GimelStudio/AppShell/GSTitleBar.qml");
}

QUrl GSViewFactory::tabbarFilename() const
{
    return QUrl("qrc:/qml/GimelStudio/AppShell/GSDockTabBar.qml");
}
