#ifndef GS_ACTIONS_IACTIONABLE_H
#define GS_ACTIONS_IACTIONABLE_H

namespace gs::actions
{
class IActionable
{
public:
    virtual ~IActionable() {}
    virtual void init() {}
};
} // namespace gs::actions

#endif
