#ifndef GS_INTERACTIVE_IINTERACTIVE_H
#define GS_INTERACTIVE_IINTERACTIVE_H

#include <any>
#include <map>
#include <string>
#include <variant>

#include <QVariant>

#include "global/ret.h"
#include "types/string.h"

using namespace gs::types;

using namespace gs;

namespace gs::interactive
{
class IInteractive
{
public:
    // TODO: Should std::any or std::variant be used?
    // using Values = std::variant<bool, int, float, double, String>;
    // using Params = std::map<String, Values>;
    // NOTE: Using a QVariant for now
    using Params = std::map<String, QVariant>;
    // using Params = std::map<String, std::any>;
    virtual void regDialog(const String& path, const String& resourcePath) {}
    // TODO: Use Ret and Val instead of Qt types
    using Result = QVariantMap;
    virtual Result openDialog(const String& path, Params& params) {return Result();}
};
} // gs::interactive

// Q_DECLARE_METATYPE(gs::interactive::IInteractive::Values);

#endif
