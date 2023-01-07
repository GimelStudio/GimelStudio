#ifndef GS_NODES_PROPERTIESMODULE_H
#define GS_NODES_PROPERTIESMODULE_H

#include "modularity/imodulesetup.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::properties
{
class PropertiesModule : public modularity::IModuleSetup
{
public:
    String moduleName() const override;
};
} // namespace gs::properties

#endif // GS_NODES_PROPERTIESMODULE_H
