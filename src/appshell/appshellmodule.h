#ifndef GS_APPSHELL_APPSHELLMODULE_H
#define GS_APPSHELL_APPSHELLMODULE_H

#include "modularity/imodulesetup.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::appshell
{
class AppShellModule : public modularity::IModuleSetup
{
public:
    String moduleName() const override;
    void registerResources() override;
    void registerModels() override;
};

} // namespace gs::appshell

#endif
