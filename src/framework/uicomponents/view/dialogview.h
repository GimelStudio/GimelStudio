#ifndef GS_UICOMPONENTS_DIALOGVIEW_H
#define GS_UICOMPONENTS_DIALOGVIEW_H

#include "global/ret.h"

#include "popupview.h"

using namespace gs;

namespace gs::uicomponents
{
class DialogView : public PopupView
{
    Q_OBJECT
public:
    explicit DialogView(QQuickItem* parent = nullptr);
    ~DialogView() override = default;

    bool isDialog() const override;
};
} // namespace gs::uicomponents


#endif