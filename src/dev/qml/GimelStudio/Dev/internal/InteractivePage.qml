import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Dev 1.0
import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    GSFlickable {
        anchors.fill: root
        contentWidth: mainLayout.width
        contentHeight: mainLayout.height 

        Column {
            id: mainLayout
            spacing: 16

            GSButton {
                text: qsTr("Open Test Dialog")
                onClicked: Dev.openTestDialog()
            }
        }
    }
}
