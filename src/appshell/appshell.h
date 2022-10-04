#ifndef GS_APPSHELL_APPSHELL_H
#define GS_APPSHELL_APPSHELL_H

#include <QList>

#include "modularity/imodulesetup.h"

namespace gs::appshell
{

class AppShell
{
public:
    AppShell();

    void addModule(modularity::IModuleSetup* module);

    int run(int argc, char** argv);
private:
    QList<modularity::IModuleSetup*> m_modules;
};

} // namespace gs::appshell

#endif
