#ifndef GS_DEV_DEVMODULE_H
#define GS_DEV_DEVMODULE_H

#include "modularity/imodulesetup.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::dev
{
class DevModule : public modularity::IModuleSetup
{
public:
    String moduleName() const override;
    void registerResources() override;
    void registerModels() override;
};

} // namespace gs::dev

#endif
