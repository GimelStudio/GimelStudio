#include <iostream>
#include "dispatcher.h"

using namespace gs::actions;

void Dispatcher::dispatch(String actionCode, QVariantMap actionData)
{
    auto actionIter = m_clients.find(actionCode);
    if (actionIter == m_clients.end()) {
        return;
    }

    const Clients clients = actionIter->second;
    for (auto clientIter = clients.begin(); clientIter != clients.end(); ++clientIter) {
        const IActionable* store = clientIter->first;
        const Callbacks callbacks = clientIter->second;
        auto a = callbacks.find(actionCode);
        if (callbacks.size() == 0) {
            continue;
        }
        a->second(actionData);
    }
}

void Dispatcher::reg(IActionable* client, const String& actionCode, const MethodWithData& callback)
{
    Clients& clients = m_clients[actionCode];
    Callbacks& callbacks = clients[client];
    callbacks.insert({actionCode, callback});
}
