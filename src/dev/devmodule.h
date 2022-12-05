#ifndef GS_DEV_DEVMODULE_H
#define GS_DEV_DEVMODULE_H

#include "modularity/imodulesetup.h"

namespace gs::dev
{
class DevModule : public modularity::IModuleSetup
{
public:
    std::string moduleName() const override;
    void registerResources() override;
    void registerModels() override;
};

} // namespace gs::dev

#endif
