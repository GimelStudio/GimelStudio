#ifndef GS_GLOBAL_TYPES_ITYPE_H
#define GS_GLOBAL_TYPES_ITYPE_H

#ifdef QT_SUPPORT
#include <QMetaType>
#include <QVariant>
#endif

namespace gs
{
class IType {};
}

Q_DECLARE_METATYPE(gs::IType)

#endif // GS_GLOBAL_TYPES_ITYPE_H
