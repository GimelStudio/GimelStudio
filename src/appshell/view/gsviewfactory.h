#ifndef GS_APPSHELL_GSVIEWFACTORY_H
#define GS_APPSHELL_GSVIEWFACTORY_H

#include <QUrl>

#include <kddockwidgets/Config.h>
#include <kddockwidgets/views/DockWidget_qtquick.h>
#include <kddockwidgets/Platform_qtquick.h>
#include <kddockwidgets/ViewFactory_qtquick.h>
#include <kddockwidgets/private/DockRegistry.h>
#include <kddockwidgets/views/MainWindow_qtquick.h>

namespace gs::appshell
{
class GSViewFactory : public KDDockWidgets::ViewFactory_qtquick
{
public:
    ~GSViewFactory() override;

    QUrl tabbarFilename() const override;
};
} // gs::appshell

#endif
