import QtQuick 2.15

import GimelStudio.UiComponents 1.0

PopupView {
    id: root

    contentItem: GSPopupBackground {
        id: contentContainer
        popupViewRoot: root
    }
}
