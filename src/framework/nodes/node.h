#ifndef GS_NODES_NODE_H
#define GS_NODES_NODE_H

#include "types/list.h"
#include "types/map.h"
#include "types/string.h"
#include "types/variantmap.h"

#include "iproperty.h"

using namespace gs::types;

class Node
{
private:
    bool m_isMuted = false;
    bool m_needExec = false;
    Map<String, IProperty*> m_properties = {};
public:
    void addProperty(String name, IProperty* property);
    // TODO: Come up with more accurate names for `checkInputs` and `evaluation`
    void checkInputs();
    // TODO: `exec` instead of `evaluation`?
    virtual void evaluation();
    virtual void initProperties();
    List<IProperty*> inputProperties();

    bool isMuted();
    void setIsMuted(bool newValue);

    virtual VariantMap metaData();

    virtual void mutedEvaluation();
    List<IProperty*> outputProperties();

    bool needExec();
    void setNeedExec(bool newValue);

    template<typename T> T property(String propertyName);
};

#endif // GS_NODES_NODE_H
