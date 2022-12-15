#ifndef GS_INTERACTIVE_INTERNAL_INTERACTIVE_H
#define GS_INTERACTIVE_INTERNAL_INTERACTIVE_H

#include "../iinteractive.h"

#include <vector>

#include <QObject>

#include "global/inject.h"
#include "types/string.h"

using namespace gs::types;

namespace gs::interactive
{
class Interactive : public QObject, public IInteractive
{
    Q_OBJECT

    INJECT_INSTANCE_METHOD(Interactive)
public:
    explicit Interactive(QObject* parent = nullptr);
    ~Interactive() override = default;

    void regDialog(const String& path, const String& resourcePath) override;
    Result openDialog(const String& path, Params& params) override;
private:
    std::map<String, String> m_dialogs;
};
} // gs::interactive

#endif
