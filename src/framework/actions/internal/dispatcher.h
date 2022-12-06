#ifndef GS_ACTIONS_INTERNAL_DISPATCHER_H
#define GS_ACTIONS_INTERNAL_DISPATCHER_H

#include <QVariantMap>

#include "global/inject.h"

#include "../idispatcher.h"

namespace gs::actions
{
class Dispatcher : public IDispatcher
{
    INJECT_INSTANCE_METHOD(Dispatcher)
public:
    void dispatch(std::string actionCode, QVariantMap actionData) override;
    void reg(IActionable* client, const std::string& actionCode, const MethodWithData& callback) override;
private:
    // TODO: Avoid using Qt classes here
    using Callbacks = std::map<std::string, MethodWithData>;
    using Clients = std::map<IActionable*, Callbacks>;
    std::map<std::string, Clients> m_clients;
};
}

#endif
