#include "variant.h"
#include "versionnumber.h"

using namespace gs::types;

Variant Variant::fromValue(VariantType val)
{
    Variant v = Variant();
    v.setValue(val);
    return v;
}

void Variant::setValue(Variant val)
{
    m_variant = val.variant();
}

void Variant::setValue(VariantType val)
{
    m_variant = val;
}

double Variant::toDouble() const
{
    return std::get<double>(m_variant);
}

float Variant::toFloat() const
{
    return std::get<float>(m_variant);
}

int Variant::toInt() const
{
    return std::get<int>(m_variant);
}

IType* Variant::toIType() const
{
    return std::get<IType*>(m_variant);
}

String Variant::toString() const
{
    return std::get<String>(m_variant);
}

VariantType Variant::variant() const
{
    return m_variant;
}
