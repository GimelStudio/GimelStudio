#ifndef GS_GLOBAL_TYPES_LIST_H
#define GS_GLOBAL_TYPES_LIST_H

#include "config.h"

#include <vector>

#ifdef QT_SUPPORT
#include <QMetaType>
#include <QObject>
#endif

namespace gs::types
{
// Until a custom type is made
template<typename T> class List : public std::vector<T> {};
}

#ifdef QT_SUPPORT
Q_DECLARE_METATYPE_TEMPLATE_1ARG(gs::types::List)
#endif

#endif // GS_GLOBAL_TYPES_LIST_H
