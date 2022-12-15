#ifndef GS_SHORTCUTS_SHORTCUTSMODULE_H
#define GS_SHORTCUTS_SHORTCUTSMODULE_H

#include "modularity/imodulesetup.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::shortcuts
{
class ShortcutsModule : public modularity::IModuleSetup
{
    String moduleName() const override;
    void registerResources() override;
    void registerModels() override;
};
} // namespace gs::shortcuts

#endif
