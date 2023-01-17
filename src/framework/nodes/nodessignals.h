#ifndef GS_NODES_NODESSIGNALS_H
#define GS_NODES_NODESSIGNALS_H

#include "bindings/signal.h"

#include "nodes.h"

using namespace gs::bindings;

namespace gs::nodes {
Signal<Node*> nodeAdded;
Signal<Node*> nodeRemoved;
}

#endif // GS_NODES_NODESSIGNALS_H
