import QtQuick 2.15

import GimelStudio.UiComponents 0.1

PopupView {
    id: root

    contentItem: GSPopupBackground {
        id: contentContainer
        popupViewRoot: root
    }
}
