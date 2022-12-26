#ifndef GS_GLOBAL_TYPES_MAP_H
#define GS_GLOBAL_TYPES_MAP_H

#include "config.h"

#include <map>

#ifdef QT_SUPPORT
#include <QMetaType>
#include <QObject>
#endif

namespace gs::types
{
// Until a custom type is made
template<typename T1, typename T2> class Map : public std::map<T1, T2> {};
}

#ifdef QT_SUPPORT
Q_DECLARE_METATYPE_TEMPLATE_2ARG(gs::types::Map)
#endif

#endif // GS_GLOBAL_TYPES_MAP_H
