#ifndef GS_NODES_IPROPERTY_H
#define GS_NODES_IPROPERTY_H

#include <iostream>
#include <vector>

#include "types/list.h"
#include "types/string.h"
#include "types/variant.h"

using namespace gs::types;

namespace gs::nodes {
enum PropertyType {
    INPUT,
    OUTPUT
};

class Node;

class IProperty
{
private:
    String m_name;
    Variant m_defaultVariant;
    Variant m_variant;
    Node* m_node;
    int m_type = PropertyType::INPUT;
public:
    List<IProperty*> m_linkedInputProperties;
    List<IProperty*> m_linkedOutputProperties;

    void linkProperty(IProperty* property)
    {
        if (type() == PropertyType::OUTPUT && property->type() == PropertyType::INPUT) {
            m_linkedInputProperties.push_back(property);
            property->m_linkedOutputProperties.push_back(this);
        } else if (type() == PropertyType::INPUT && property->type() == PropertyType::OUTPUT) {
            m_linkedOutputProperties.push_back(property);
            property->m_linkedInputProperties.push_back(this);
        }
    };

    List<IProperty*> linkedInputProperties() { return m_linkedInputProperties; };
    List<IProperty*> linkedOutputProperties() { return m_linkedOutputProperties; };

    Variant defaultVariant() { return m_defaultVariant; }
    void setDefaultValue(Variant v) { m_defaultVariant.setValue(v); }
    void setDefaultValue(VariantType v) { m_defaultVariant.setValue(v); }

    String name() { return m_name; }
    void setName(String val) { m_name = val; }

    Node* node() { return m_node; }
    void setNode(Node* n) { m_node = n; }

    int type() { return m_type; }
    void setType(int type) { m_type = type; };

    Variant variant() const { return m_variant; }
    void setValue(Variant v) { m_variant.setValue(v); }
    void setValue(VariantType v) { m_variant.setValue(v); }
};
} // gs::nodes

#endif // GS_NODES_IPROPERTY_H
