#ifndef GS_UI_UIMODULE_H
#define GS_UI_UIMODULE_H

#include "modularity/imodulesetup.h"

namespace gs::ui
{
class UiModule : public modularity::IModuleSetup
{
public:
    std::string moduleName() const override;
    void registerUiTypes() override;
};
} // namespace gs::ui

#endif
