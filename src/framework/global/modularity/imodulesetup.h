#ifndef GS_MODULARITY_IMODULESETUP_H
#define GS_MODULARITY_IMODULESETUP_H

#include <string>

namespace modularity {
class IModuleSetup
{
public:
    virtual ~IModuleSetup() {}
    virtual std::string moduleName() const = 0;
    virtual void registerImports() {}
    // As a general rule, singletons are used for action models while types are used for data models
    // singletons -> use qmlRegisterSingletonInstance
    // types -> use qmlRegisterType
    virtual void registerModels() {}
    virtual void registerResources() {}
    virtual void registerUiTypes() {}
};
} // gs::modularity

#endif
