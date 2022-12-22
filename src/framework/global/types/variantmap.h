#ifndef GS_GLOBAL_TYPES_VARIANTMAP_H
#define GS_GLOBAL_TYPES_VARIANTMAP_H

#include "config.h"

#include <map>

#ifdef QT_SUPPORT
#include <QMetaType>
#endif

#include "string.h"
#include "variant.h"

namespace gs::types
{
// Use the standard library map for now (not even sure if a custom class should be created for this)
typedef std::map<String, Variant> VariantMap;
}

#ifdef QT_SUPPORT
Q_DECLARE_METATYPE(gs::types::VariantMap)
#endif

#endif // GS_GLOBAL_TYPES_VARIANTMAP_H
