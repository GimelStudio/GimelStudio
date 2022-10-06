import QtQuick 2.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

DialogView {
    id: root

    default property alias contentData: contentBody.data

    property int margins: 16

    contentItem: FocusScope {
        id: rootContainer

        width: root.width
        height: root.height

        Rectangle {
            anchors.fill: rootContainer
            color: UiTheme.backgroundPrimaryColor
        }

        Item {
            id: contentBody
            anchors.fill: parent
        }
    }
}
