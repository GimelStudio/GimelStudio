#ifndef GS_GLOBAL_TYPES_VARIANT_H
#define GS_GLOBAL_TYPES_VARIANT_H

#include "config.h"

#include <map>
#include <string>
#include <variant>

#ifdef QT_SUPPORT
#include <QMetaObject>
#include <QVariant>
#endif

typedef std::variant<double, float, int, std::string> VariantType;

class Variant
{
private:
    VariantType m_variant;
public:
    static Variant fromValue(VariantType val)
    {
        Variant v = Variant();
        v.setValue(val);
        return v;
    }
    template<typename T> static Variant fromValue(T val)
    {
        Variant v = Variant();
        v.setValue(val);
        return v;
    }
    template<typename T> T value() { return std::get<T>(m_variant); }
    template<typename T> T valueToType() { return static_cast<T>(toIType()); }
    void setValue(Variant val) { m_variant = val.variant(); };
    void setValue(VariantType val) { m_variant = val; };

    double toDouble() { return std::get<double>(m_variant); }
    float toFloat() { return std::get<float>(m_variant); }
    int toInt() { return std::get<int>(m_variant); }
    IType* toIType() { return std::get<IType*>(m_variant); }
#ifdef QT_SUPPORT
    // Unfortunately, a template has to be used here. Otherwise Qt has a massive hissy fit
    template<typename T> QVariant toQVariant() { return QVariant::fromValue<T>(m_variant); }
#endif
    std::string toString() { return std::get<std::string>(m_variant); }
    VariantType variant() const { return m_variant; }
};

#endif // GS_GLOBAL_TYPES_VARIANT_H
