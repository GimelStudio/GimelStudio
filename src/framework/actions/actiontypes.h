#ifndef GS_ACTIONS_ACTIONTYPES_H
#define GS_ACTIONS_ACTIONTYPES_H

#include <QVariantMap>
#include <string>

namespace gs::actions
{
using ActionCode = std::string;
using ActionData = QVariantMap;
using Method = std::function<void()>;
using MethodWithData = std::function<void(QVariantMap)>;
} // namespace gs::actions

#endif
