// TODO: Perhaps rename to shorcuthandler.[cpp,h]?

#ifndef GS_SHORTCUTS_SHORTCUTSREGISTER
#define GS_SHORTCUTS_SHORTCUTSREGISTER

#include <QEvent>
#include <QObject>

namespace gs::shortcuts {

class ShortcutsRegister : public QObject
{
    Q_OBJECT

public:
    ShortcutsRegister(QObject *parent = nullptr);

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
};

}

#endif // GS_SHORTCUTS_SHORTCUTSREGISTER
