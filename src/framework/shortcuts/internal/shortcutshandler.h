#ifndef GS_SHORTCUTS_SHORTCUTSHANDLER
#define GS_SHORTCUTS_SHORTCUTSHANDLER

#include <QEvent>
#include <QObject>

namespace gs::shortcuts {

class ShortcutsHandler : public QObject
{
    Q_OBJECT

public:
    ShortcutsHandler(QObject *parent = nullptr);

protected:
    bool eventFilter(QObject *obj, QEvent *event) override;
};

}

#endif // GS_SHORTCUTS_SHORTCUTSHANDLER
