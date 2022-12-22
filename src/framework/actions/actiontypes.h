#ifndef GS_ACTIONS_ACTIONTYPES_H
#define GS_ACTIONS_ACTIONTYPES_H

#include <string>

#include "types/string.h"
#include "types/variantmap.h"

using namespace gs::types;

namespace gs::actions
{
// Until custom types are created
using ActionCode = String;
using ActionData = VariantMap;
using Method = std::function<void()>;
using MethodWithData = std::function<void(VariantMap)>;
} // namespace gs::actions

#endif
