#ifndef GS_SHORTCUTS_SHORTCUTSMODULE_H
#define GS_SHORTCUTS_SHORTCUTSMODULE_H

#include "modularity/imodulesetup.h"

namespace gs::shortcuts
{
class ShortcutsModule : public modularity::IModuleSetup
{
    std::string moduleName() const override;
    void registerResources() override;
    void registerModels() override;
};
} // namespace gs::shortcuts

#endif
