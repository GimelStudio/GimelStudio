#ifndef GS_GLOBAL_TYPES_VARIANT_H
#define GS_GLOBAL_TYPES_VARIANT_H

#include "config.h"

#include "itype.h"
#include "string.h"
#include "versionnumber.h"

#include <map>
#include <string>
#include <variant>

#ifdef QT_SUPPORT
#include <QMetaType>
#include <QVariant>
#endif

namespace gs::types
{
typedef std::variant<double, float, int, IType, IType*, String, VersionNumber> VariantType;

class Variant
{
private:
    VariantType m_variant;
public:
    static Variant fromValue(VariantType val);
    // See https://stackoverflow.com/a/495056 and https://stackoverflow.com/a/10632266 for why the implementation is here
    template<typename T> static Variant fromValue(T val)
    {
        Variant v = Variant();
        v.setValue(val);
        return v;
    }

    template<typename T> T value() const
    {
        return std::get<T>(m_variant);
    }

    template<typename T> T valueToType() const
    {
        return static_cast<T>(toIType());
    }

    void setValue(Variant val);
    void setValue(VariantType val);

    double toDouble() const;
    float toFloat() const;
    int toInt() const;
    IType* toIType() const;
#ifdef QT_SUPPORT
    // Unfortunately, a template has to be used here. Otherwise Qt has a massive hissy fit
    template<typename T> QVariant toQVariant()
    {
        return QVariant::fromValue<T>(m_variant);
    }
#endif
    String toString() const;
    VariantType variant() const;
};
}

#ifdef QT_SUPPORT
Q_DECLARE_METATYPE(gs::types::Variant)
#endif

#endif // GS_GLOBAL_TYPES_VARIANT_H
