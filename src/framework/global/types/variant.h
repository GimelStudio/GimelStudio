#ifndef GS_GLOBAL_TYPES_VARIANT_H
#define GS_GLOBAL_TYPES_VARIANT_H

#include "config.h"

#include "itype.h"
#include "string.h"

#include <map>
#include <string>
#include <variant>

#ifdef QT_SUPPORT
#include <QVariant>
#endif

namespace gs
{
typedef std::variant<double, float, int, IType, IType*, String> VariantType;

class Variant
{
private:
    VariantType m_variant;
public:
    static Variant fromValue(VariantType val);
    template<typename T> static Variant fromValue(T val);

    template<typename T> T value();
    template<typename T> T valueToType();
    void setValue(Variant val);
    void setValue(VariantType val);

    double toDouble();
    float toFloat();
    int toInt();
    IType* toIType();
#ifdef QT_SUPPORT
    // Unfortunately, a template has to be used here. Otherwise Qt has a massive hissy fit
    template<typename T> QVariant toQVariant();
#endif
    String toString();
    VariantType variant() const;
};
}

#endif // GS_GLOBAL_TYPES_VARIANT_H
