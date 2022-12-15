#ifndef GS_GLOBAL_TYPES_VARIANTMAP_H
#define GS_GLOBAL_TYPES_VARIANTMAP_H

#include <map>

#include "string.h"
#include "variant.h"

namespace gs::types
{
// Use the standard library map for now (not even sure if a custom class should be created for this)
using VariantMap = std::map<String, Variant>;
}

#endif // GS_GLOBAL_TYPES_VARIANTMAP_H
