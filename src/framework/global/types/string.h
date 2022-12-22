#ifndef GS_GLOBAL_TYPES_STRING_H
#define GS_GLOBAL_TYPES_STRING_H

#include "config.h"

#include <string>

#ifdef QT_SUPPORT
#include <QMetaType>
#endif

namespace gs::types
{
// Until a custom string type is made
using String = std::string;
}

#ifdef QT_SUPPORT
Q_DECLARE_METATYPE(gs::types::String)
#endif

#endif // GS_GLOBAL_TYPES_STRING_H
