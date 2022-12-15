#ifndef GS_ACTIONS_ACTIONTYPES_H
#define GS_ACTIONS_ACTIONTYPES_H

#include <QVariantMap>
#include <string>

#include "types/string.h"

using namespace gs::types;

namespace gs::actions
{
// Until custom types are created
using ActionCode = String;
using ActionData = QVariantMap;
using Method = std::function<void()>;
using MethodWithData = std::function<void(QVariantMap)>;
} // namespace gs::actions

#endif
