#ifndef GS_GLOBAL_TYPES_ITYPE_H
#define GS_GLOBAL_TYPES_ITYPE_H

#ifdef QT_SUPPORT
#include <QMetaType>
#include <QVariant>
#endif

namespace gs::types
{
class IType {};
}

#ifdef QT_SUPPORT
Q_DECLARE_METATYPE(gs::types::IType)
#endif

#endif // GS_GLOBAL_TYPES_ITYPE_H
