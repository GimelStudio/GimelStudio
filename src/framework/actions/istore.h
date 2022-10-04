#ifndef GS_ACTIONS_ISTORE_H
#define GS_ACTIONS_ISTORE_H

namespace gs::actions
{
class IStore
{
public:
    // TODO: Is there a better way instead of typing the following in every subclass?
    IStore()
    {
        init();
    }
    virtual ~IStore() {}
    virtual void init() {}
};
} // namespace gs::actions

#endif
