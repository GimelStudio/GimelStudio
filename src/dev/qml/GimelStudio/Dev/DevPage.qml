import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import GimelStudio.Ui 1.0
import GimelStudio.UiComponents 1.0

Item {
    id: root

    GSFlickable {
        anchors.fill: parent
        contentWidth: mainLayout.width
        contentHeight: mainLayout.height 

        ColumnLayout {
            id: mainLayout

            GSLabel {
                text: qsTr("Label")
            }
        }
    }
}
