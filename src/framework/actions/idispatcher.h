#ifndef GS_ACTIONS_IDISPATCHER_H
#define GS_ACTIONS_IDISPATCHER_H

#include <functional>
#include <map>
#include <string>

#include "actiontypes.h"
#include "iactionable.h"

#include "types/string.h"

using namespace gs::types;

namespace gs::actions
{
class IDispatcher
{
public:
    virtual void dispatch(String actionCode)
    {
        QVariantMap dummy;
        dispatch(actionCode, dummy);
    }
    virtual void dispatch(String actionCode, QVariantMap actionData) {}
    virtual void reg(IActionable* store, const String& actionCode, const MethodWithData& callback) {}
    virtual void unReg(IActionable* store) {}
    virtual void unReg(IActionable* store, String actionCode) {}
};
}

#endif
