#ifndef GS_NODES_NODESMODULE_H
#define GS_NODES_NODESMODULE_H

#include "modularity/imodulesetup.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::nodes
{
class NodesModule : public modularity::IModuleSetup
{
public:
    String moduleName() const override;
};
} // namespace gs::nodes

#endif // GS_NODES_NODESMODULE_H
