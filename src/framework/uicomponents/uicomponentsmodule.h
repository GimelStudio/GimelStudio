#ifndef GS_UICOMPONENTS_UICOMPONENTS_MODULE_H
#define GS_UICOMPONENTS_UICOMPONENTS_MODULE_H

#include "modularity/imodulesetup.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::uicomponents
{
class UiComponentsModule : public modularity::IModuleSetup
{
public:
    String moduleName() const override;
    void registerResources() override;
    void registerUiTypes() override;
};
}

#endif