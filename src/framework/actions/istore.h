#ifndef GS_ACTIONS_ISTORE_H
#define GS_ACTIONS_ISTORE_H

namespace gs::actions
{
class IStore
{
public:
    virtual ~IStore() {}
    virtual void init() {}
};
} // namespace gs::actions

#endif
