#ifndef GS_ACTIONS_IDISPATCHER_H
#define GS_ACTIONS_IDISPATCHER_H

#include <functional>
#include <map>
#include <string>

#include "actiontypes.h"
#include "iactionable.h"

namespace gs::actions
{
class IDispatcher
{
public:
    virtual void dispatch(std::string actionCode)
    {
        QVariantMap dummy;
        dispatch(actionCode, dummy);
    }
    virtual void dispatch(std::string actionCode, QVariantMap actionData) {}
    virtual void reg(IActionable* store, const std::string& actionCode, const MethodWithData& callback) {}
    virtual void unReg(IActionable* store) {}
    virtual void unReg(IActionable* store, std::string actionCode) {}
};
}

#endif
