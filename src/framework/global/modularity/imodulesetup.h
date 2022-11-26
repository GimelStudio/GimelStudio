#ifndef GS_MODULARITY_IMODULESETUP_H
#define GS_MODULARITY_IMODULESETUP_H

#include <string>

namespace modularity {
class IModuleSetup
{
public:
    // virtual IModuleSetup();
    virtual ~IModuleSetup() {}
    virtual std::string moduleName() const = 0;
    virtual void registerImports() {}
    virtual void registerResources() {}
    // As a general rule, singletons are used for action stores while types are used for data stores
    // singletons -> use qmlRegisterSingletonInstance
    // types -> use qmlRegisterType
    virtual void registerStores() {}
    virtual void registerUiTypes() {}
};
} // gs::modularity

#endif
