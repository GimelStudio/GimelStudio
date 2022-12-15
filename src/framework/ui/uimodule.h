#ifndef GS_UI_UIMODULE_H
#define GS_UI_UIMODULE_H

#include "modularity/imodulesetup.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::ui
{
class UiModule : public modularity::IModuleSetup
{
public:
    String moduleName() const override;
    void registerUiTypes() override;
};
} // namespace gs::ui

#endif
