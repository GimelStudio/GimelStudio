#ifndef GS_APPSHELL_APPSHELLMODULE_H
#define GS_APPSHELL_APPSHELLMODULE_H

#include "modularity/imodulesetup.h"

namespace gs::appshell
{
class AppShellModule : public modularity::IModuleSetup
{
public:
    std::string moduleName() const override;
    void registerResources() override;
    void registerModels() override;
};

} // namespace gs::appshell

#endif
