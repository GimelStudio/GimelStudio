#ifndef GS_ACTIONS_INTERNAL_DISPATCHER_H
#define GS_ACTIONS_INTERNAL_DISPATCHER_H

#include <QVariantMap>

#include "global/inject.h"
#include "types/string.h"

#include "../idispatcher.h"

using namespace gs::types;

namespace gs::actions
{
class Dispatcher : public IDispatcher
{
    INJECT_INSTANCE_METHOD(Dispatcher)
public:
    void dispatch(String actionCode, QVariantMap actionData) override;
    void reg(IActionable* client, const String& actionCode, const MethodWithData& callback) override;
private:
    // TODO: Avoid using Qt classes here
    using Callbacks = std::map<String, MethodWithData>;
    using Clients = std::map<IActionable*, Callbacks>;
    std::map<String, Clients> m_clients;
};
}

#endif
