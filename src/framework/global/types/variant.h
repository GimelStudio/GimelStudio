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
    template<typename T> static Variant fromValue(T val);

    template<typename T> T value() const;
    template<typename T> T valueToType() const;
    void setValue(Variant val);
    void setValue(VariantType val);

    double toDouble() const;
    float toFloat() const;
    int toInt() const;
    IType* toIType() const;
#ifdef QT_SUPPORT
    // Unfortunately, a template has to be used here. Otherwise Qt has a massive hissy fit
    template<typename T> QVariant toQVariant();
#endif
    String toString() const;
    VariantType variant() const;
};
}

#endif // GS_GLOBAL_TYPES_VARIANT_H
